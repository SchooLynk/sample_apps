class CreateFirstLoginNotices < ActiveRecord::Migration[6.1]
  def change
    create_table :first_login_notices do |t|
      t.references :user, null: false, foreign_key: true, index: { unique: true }
      t.integer :read, null: false, default: 0

      t.timestamps
    end
  end
end
