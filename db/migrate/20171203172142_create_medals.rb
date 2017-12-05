class CreateMedals < ActiveRecord::Migration[5.1]
  def change
    create_table :medals do |t|
      t.string :rank
      t.references :event, index: true
      t.references :athlete, index: true
      t.references :olympic, index: true
      t.references :country, index: true

      t.timestamps
    end
  end
end
