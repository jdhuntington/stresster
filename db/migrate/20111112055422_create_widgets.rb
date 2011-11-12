class CreateWidgets < ActiveRecord::Migration
  def change
    create_table :widgets do |t|
      t.string :key
      t.text :data

      t.timestamps
    end

    add_index :widgets, :key
  end
end
