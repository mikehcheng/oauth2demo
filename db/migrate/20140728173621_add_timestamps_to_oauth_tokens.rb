class AddTimestampsToOauthTokens < ActiveRecord::Migration
  def change
    remove_column :oauth_tokens, :created_at, :datetime
    add_timestamps :oauth_tokens
  end
end
