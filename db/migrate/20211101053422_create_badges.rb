class CreateBadges < ActiveRecord::Migration[6.1]
  def change
    create_table :badges do |t|
      t.references :user
      t.references :question, null: false, foreign_key: true
      t.string :name

      t.timestamps
    end
  end
end
