class CreateToolHistories < ActiveRecord::Migration[8.1]
  def change
    create_table :tool_histories do |t|
      t.references :user, null: false, foreign_key: true
      t.string :slug, null: false
      t.string :input_preview
      t.timestamps
    end
    add_index :tool_histories, [ :user_id, :created_at ]
  end
end
