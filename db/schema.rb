ActiveRecord::Schema.define(:version => 1) do
  create_table :links do |t|
    t.string    :title, :url
    t.datetime  :created_at
    t.integer   :creator_id
  end

  create_table :users do |t|
    t.string    :login, :limit => 40
    t.string    :name, :limit => 100, :default => '', :null => true
    t.string    :email, :limit => 100
    t.string    :crypted_password, :limit => 40
    t.string    :salt, :limit => 40
    t.datetime  :created_at
    t.datetime  :updated_at
    t.string    :remember_token, :limit => 40
    t.datetime  :remember_token_expires_at
  end
  add_index :users, :login, :unique => true
  
  create_table :votes do |t|
    t.integer   :link_id, :user_id
    t.datetime  :created_at
  end
end
