ActiveRecord::Schema.define(:version => 1) do
  create_table :links do |t|
    t.string    :title, :url
    t.timestamp :created_at
    t.integer   :creator_id
  end

  create_table :users do |t|
    t.string    :name, :email, :password_hash
    t.timestamp :created_at
  end
  
  create_table :votes do |t|
    t.integer   :link_id, :user_id
    t.timestamp :created_at
  end
end
