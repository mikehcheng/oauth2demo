class CreateOauthTokens < ActiveRecord::Migration
  def change
    create_table :oauth_tokens do |t|
      t.string   "access_token"
      t.string   "refresh_token"
      t.datetime "created_at"
      t.string   "resource_owner_id"
    end
  end
end
