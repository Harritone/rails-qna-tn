class CreateLinks < ActiveRecord::Migration[6.1]
  def change
    create_table :links do |t|
      t.string :name
      t.string :url
      t.references :question, null: false, foreign_key: true, on_delete: :cascade

      t.timestamps
    end
  end
end
