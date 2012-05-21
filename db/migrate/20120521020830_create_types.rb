class CreateTypes < ActiveRecord::Migration
  def change
    create_table :types do |t|
      t.string :name
      t.references :team

      t.timestamps
    end
    add_index :types, :team_id
  end
end
