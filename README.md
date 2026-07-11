# Home Server

[![Coverage Status](https://img.shields.io/coveralls/github/cpcwood/home-server?style=flat-square&color=sucess)](https://coveralls.io/github/cpcwood/home-server?branch=main) [![GitHub Actions](https://img.shields.io/github/actions/workflow/status/cpcwood/home-server/main.yml?style=flat-square&color=success)](https://github.com/cpcwood/home-server/actions) [![JavaScript Style Guide](https://img.shields.io/badge/JS_code_style-standard-informational.svg?style=flat-square)](https://standardjs.com)

## Overview

General portfolio style website and a place to prototype new rails features I find interesting.

### Technology

- Ruby on Rails & PostgreSQL
- Stimulus
- Google reCaptcha
- TOTP two factor authentication (authenticator app)
- Email via AWS SES (SMTP)
- Docker
- Kubernetes + Helm + Gateway API (Traefik)
- Terraform (AWS infra)
- AWS Systems Manager Parameter Store + External Secrets Operator

### Design

| Public sections | Admin sections              |
|-                |-                            |
| Homepage        | Login, 2FA, Password Reset  |
| About me        | Edit sections               |
| Projects        | Add resources               |
| Blog            | Notifications               |
| Code Snippets   | Website analytics           |
| Gallery         | Contact messages            |
| Contact         |                             |



## Setup

### Prerequisites

The application is designed to run in a containerized workflow to allow for good runtime consistency across environments. 

Make sure [docker](https://www.docker.com/) v20.10+ is installed, clone or download the git repository, then move to the project root directory.

### Environment

The application is set up to have three different environments: production, development, test.

### Development

#### Configuration


##### Application

Since the application is designed to be containerized, its configuration is passed through environment variables. 

Development environment variables are loaded from ```config/env/.env``` by docker-compose. Create the ```config/env/.env``` file from the template of required variables in [```config/env/.env.template```](/config/env/.env.template).

#### Install Dependencies

Build the development container images, using ```./tasks build```

In order for commands to run inside the application containers scripts are used instead of calling the commands directly. Scripts are run from the [`tasks`](./tasks) file and the following scripts are current provided:
- ```./tasks start``` - start the application
- ```./tasks stop``` - stop the application
- ```./tasks build``` - build the application containers
- ```./tasks exec``` - run command in application container
- ```./tasks sh``` - enter shell in application container
- ```./tasks rspec``` - rspec test suite
- ```./tasks yarn``` - yarn
- ```./tasks rails``` - rails
- ```./tasks bundle``` - bundler
- ```./tasks rubocop``` - run ruby code linter

Then container start up scripts will install the application dependencies automatically on the first run. Updates to dependencies, such as adding a new gem, should be performed manually.

Notes:
- Arguments added to the scripts are passed through.
- To run other commands use the ```docker-compose run``` syntax.

#### Setup Database

The container image [startup script](./.docker/scripts/startup-worker-dev) will automatically create and seed the database on start.

#### Start the Development Server

To start the development server using docker-compose, run: ```./tasks up```

The server should now be running on ```http://0.0.0.0:3000```

### Production

Production deploys to a Kubernetes cluster across two layers:

1. **Platform** — Traefik (Gateway API), cert-manager, External Secrets Operator, `ClusterIssuer`s, the `aws-parameter-store` `ClusterSecretStore`, and the IAM principal ESO uses. Owned by a separate Terraform stack.
2. **App** — this repo. The Helm chart in `infrastructure/helm/` deploys the app, worker, db, cache, and backup cronjob. Runtime secrets are pulled from AWS Parameter Store (SecureString, free) via `ExternalSecret` resources. Ingress is Gateway API (`Gateway` + `HTTPRoute`) routed by Traefik.

The platform must be in place before the app chart will install successfully. The interface between the two is documented in [docs/platform-contract.md](docs/platform-contract.md).

#### Infrastructure (AWS side)

Terraform in `infrastructure/terraform/` manages the AWS resources (S3, Parameter Store, IAM/OIDC) **and** the in-cluster CI deploy identity (ServiceAccount + namespaced RBAC, via the `kubernetes` provider). The first apply runs locally and needs AWS credentials able to manage these resources and a `kubectl` context with cluster admin.

The whole bootstrap is one idempotent command — `bootstrap.sh` ensures the namespace, runs `terraform init && apply` (interactive — review the plan), then pushes the CI credentials to GitHub:

```bash
./scripts/bootstrap.sh
```

The namespace can't be a Terraform resource: it's cluster-scoped, and CI runs terraform as the namespace-scoped deploy SA (which can't manage cluster objects). So the script creates it with your admin context first, before the apply that puts the SA inside it.

Subsequent applies run in CI: AWS via OIDC role assumption (`home-server-github-actions-production`), cluster via the deploy SA's kubeconfig. Because every cluster resource here is namespace-scoped, that SA can manage them itself — CI never needs cluster-wide access.

(Backend config — bucket, key, region — is hardcoded in `main.tf` since values can't be parameterised in a `backend` block. State key is `home-server/production/terraform.tfstate`; locking uses the native S3 lockfile (`use_lockfile`), no DynamoDB table.)

What Terraform creates:

| Resource | Purpose |
|---|---|
| `aws_s3_bucket.application_storage_s3` | User uploads (ActiveStorage backend) — versioned, lifecycle-pruned |
| `aws_ssm_parameter.app` | Rails / Sidekiq runtime secrets bundle — at `/cpcwood-k8s/home-server/production/app` |
| `aws_ssm_parameter.app_storage` | App S3 storage IAM keys + bucket name — `…/app-storage` (Terraform-generated) |
| `aws_ssm_parameter.db` | Postgres `POSTGRES_USER` + `POSTGRES_PASSWORD` — `…/db` (Terraform-generated) |
| `aws_ssm_parameter.build` | Docker build-time secrets — `…/build` |
| `aws_ssm_parameter.email` | SES SMTP username + password — `…/email` (Terraform-generated) |
| `aws_iam_user.app_storage` | Dedicated IAM user scoped to the storage bucket (app + worker S3 access) |
| `aws_ses_domain_identity.email` (+ DKIM, `aws_iam_user.ses_smtp` + access key) | Outbound SMTP via SES — DNS verification/DKIM from the `ses_*` outputs |
| `aws_iam_role.github_actions` | OIDC role this repo's CI assumes |
| `kubernetes_service_account_v1.deploy` (+ token, RoleBindings, CRD Role) | CI deploy identity — namespace-scoped admin + ESO/Gateway CRD verbs (`ci.tf`) |

Parameter naming hierarchy is `/<cluster>/<app>/<env>/<bundle>` (today: `/cpcwood-k8s/home-server/production/<bundle>`). Leading `/` is the Parameter Store convention. Override the prefix at deploy time with `--set global.secretPrefix=...`.

The `app` and `build` parameter values are not in Terraform — Terraform creates them empty (with `ignore_changes` on the value) and `scripts/populate-parameter-store.sh` fills them in, so rotating a secret never needs a Terraform run. The `db`, `app-storage` and `email` (SES SMTP) values are generated by Terraform directly.

Postgres backups are handled at the platform layer by Velero (cluster-wide PV snapshots), so this app no longer ships its own backup job or bucket.

#### Populating secrets

After `terraform apply`, populate values once:

```bash
./scripts/populate-parameter-store.sh all
```

The script reads existing values (if any), prompts per key, and writes via `aws ssm put-parameter`. Run again to rotate any subset; press enter at a prompt to keep the existing value.

#### SES cutover runbook

1. `terraform apply` — creates the SES identity, SMTP user, and `/…/email` SSM parameter.
2. Add DNS records at the DNS host: TXT `_amazonses.cpcwood.com` = `ses_domain_verification_token` output; three DKIM CNAMEs from `ses_dkim_tokens` (`<token>._domainkey.cpcwood.com` → `<token>.dkim.amazonses.com`).
3. Wait for the identity to show **Verified** in the SES console. Domain identity (TXT) and DKIM verification are async and lag DNS propagation — don't rely on SES until it flips to Verified.
4. Request SES production access in the AWS console (new accounts start sandboxed — sandbox delivers only to verified addresses). This is a separate async AWS approval, typically ~24h.
5. Deploy the Helm change. Contact-form email works as soon as the identity is Verified (recipient is `contact@cpcwood.com` on the verified domain). Only run the external password-reset test AFTER the identity is Verified **and** production access is granted — while sandboxed, external password-reset recipients bounce.

#### Wiring CI to the cluster

The final step of `bootstrap.sh` does this: Terraform creates the `home-server-deploy` ServiceAccount, its namespace-scoped RBAC, and a `ci_kubeconfig` output (public API endpoint `k8s.cpcwood.com:58497` baked in); the script then reads `github_actions_role_arn` + `ci_kubeconfig` from terraform output and sets the `AWS_OIDC_ROLE_ARN` repo **variable** and the `KUBE_CONFIG_DATA` repo **secret** (base64 kubeconfig, consumed by the `terraform`, `terraform-plan`, and `deploy` jobs). Re-run the script any time to rotate the SA token — `gh auth login` first if needed.

#### Deploy

CI runs the equivalent of:

```bash
helm dependency update ./infrastructure/helm
helm upgrade --install home-server ./infrastructure/helm \
  --namespace home-server-production \
  --set app.image.tag=<sha> \
  --set worker.image.tag=<sha>
```

Pre-flight check: `kubectl get clustersecretstore aws-parameter-store` should be `Ready`. If it is not, the platform stack has not been applied — fix that first, otherwise the app `ExternalSecret`s will never sync and pods will crashloop on missing env vars.

#### First-time GitHub repo settings

One-time clicks that can't (sensibly) be scripted:

- **GHCR package access** — after the first `main` build, packages `home-server-app` and `home-server-worker` appear at https://github.com/cpcwood?tab=packages (base and worker-dependencies are built in a job-local registry and never published). For each: *Package settings → Manage Actions access → Add Repository* → `home-server` with **Write**. To let the cluster pull without auth, also set visibility to **Public**.
- **Auto-merge for Dependabot** — *Settings → General → Pull Requests* → enable **Allow auto-merge**. Then *Settings → Branches → Branch protection rules* for `main`: require a PR, require status checks (`test`, `helm-validate`, `terraform-validate`), require up-to-date branches. Without these the `automerge` job has no gate to wait on.


## Tests

#### Server Tests

RSpec and Capybara are used to run unit and feature tests on the application. 

To run test suite, run ```./tasks rspec``` in the command line.

#### Frontend Tests

Jest is used to test the client frontend JavaScript.

To run the test suite run ```./tasks yarn test``` in the command line.


## Usage

#### Adding Personal Details and Images

Once the application is running, head to the homepage, click on the hamburger icon, and click on login.

Login with your seeded admin credentials.

Click on the site settings tab and add the values or upload:
- website name
- images for the homepage tiles 
- images for the header

#### Two Factor Authentication

Enrol from *User Settings → Set up 2FA*: scan the QR code with an authenticator app and confirm with a generated code. Until enrolled, login proceeds without a second factor.

#### 2FA reset

If the authenticator device is lost, clear the secret from a Rails console and re-enroll:
```ruby
User.first.update(otp_secret: nil, otp_consumed_timestep: nil)
```


## Contributing

Any pull requests are welcome. If you have a question or find a bug, create a GitHub issue.


## LICENSE

This software is distributed under the MIT license.
