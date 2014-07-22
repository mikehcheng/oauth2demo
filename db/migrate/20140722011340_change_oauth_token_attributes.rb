class ChangeOauthTokenAttributes < ActiveRecord::Migration
  def change
    remove_column :oauth_tokens, :resource_owner_id, :string
    add_column :oauth_tokens, :user_attributes, :string
  end
end
