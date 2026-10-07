class CreateSavedTools < ActiveRecord::Migration[8.1]
  def change
    create_table :saved_tools do |t|
      t.references :user, null: false, foreign_key: true
      t.string :slug, null: false
      t.timestamps
    end
    add_index :saved_tools, [ :user_id, :slug ], unique: true
  end
end
