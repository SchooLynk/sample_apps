class AddTrackableToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :last_sign_in_ip, :string
    add_column :users, :last_sign_in_at, :datetime
  end
end
