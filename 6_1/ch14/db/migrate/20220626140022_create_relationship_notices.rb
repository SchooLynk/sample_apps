class CreateRelationshipNotices < ActiveRecord::Migration[6.1]
  def change
    create_table :relationship_notices do |t|
      t.references :relationship, null: false, foreign_key: true
      t.integer :read, null: false, default: 0

      t.timestamps
    end
  end
end
