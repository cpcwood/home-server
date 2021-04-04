class MigratePostTextToPostSection < ActiveRecord::Migration[6.1]
  def up
    Post.find_each do |post|
      PostSection.create!(post: post, text: post.text)
    end
    remove_column :posts, :text
  end

  def down
    add_column :posts, :text, :text
    Post.find_each do |post|
      Post.post_sections.order(order: :asc).each do |post_section|
        post.text += post_section.text
      end
      post.save!
    end
  end
end
