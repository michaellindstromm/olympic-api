class CreateOlympics < ActiveRecord::Migration[5.1]
  def change
    create_table :olympics do |t|
      t.date :year
      t.string :season
      t.references :city, index: true

      t.timestamps
    end
  end
end
