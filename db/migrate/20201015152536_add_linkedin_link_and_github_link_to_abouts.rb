class AddLinkedinLinkAndGithubLinkToAbouts < ActiveRecord::Migration[6.0]
  def change
    add_column :abouts, :linkedin_link, :string
    add_column :abouts, :github_link, :string
  end
end
