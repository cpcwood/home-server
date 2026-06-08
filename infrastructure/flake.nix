{
  description = "home-server infrastructure dev shell — terraform + helm + kubectl + AWS CLI";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
  };

  outputs = { self, nixpkgs }:
    let
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      forAllSystems = f: builtins.listToAttrs (
        map (system: { name = system; value = f system; }) systems
      );
    in
    {
      devShells = forAllSystems (system:
        let
          pkgs = import nixpkgs { inherit system; config.allowUnfree = true; };

          # Print the AWS account + kube context before each local terraform run
          # — catches "wrong account" before apply. Skipped in CI ($CI is set).
          # Diagnostics go to stderr so they never pollute `$(terraform output …)`.
          terraformWrapped = pkgs.writeShellScriptBin "terraform" ''
            if [ -z "''${CI:-}" ]; then
              {
                echo "AWS Account:     $(aws sts get-caller-identity --query Account --output text 2>/dev/null || echo 'N/A')"
                echo "AWS Profile:     ''${AWS_PROFILE:-N/A}"
                echo "Kubectl Context: $(kubectl config current-context 2>/dev/null || echo 'N/A')"
              } >&2
            fi
            exec ${pkgs.terraform_1}/bin/terraform "$@"
          '';
        in
        {
          default = pkgs.mkShell {
            buildInputs = with pkgs; [
              terraformWrapped
              awscli2
              kubectl
              kubernetes-helm
              gh
              jq
              shellcheck
              tflint
              trivy
              checkov
              pre-commit
            ];

            shellHook = ''
              echo "home-server infra dev shell (${system})"
              if root=$(git rev-parse --show-toplevel 2>/dev/null); then
                (cd "$root" && pre-commit install --install-hooks) >/dev/null 2>&1 || true
              fi
            '';
          };
        }
      );
    };
}
