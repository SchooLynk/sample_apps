class CreateSignedIns < ActiveRecord::Migration[6.1]
  def change
    create_table :signed_ins do |t|
      t.references :user, null: false, foreign_key: true
      t.string :remote_ip, null: false

      t.timestamps
    end
  end
end
