class CreateDisciplines < ActiveRecord::Migration[5.1]
  def change
    create_table :disciplines do |t|
      t.string :discipline_name
      t.references :sport, index: true

      t.timestamps
    end
  end
end
