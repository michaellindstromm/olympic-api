class CreateEvents < ActiveRecord::Migration[5.1]
  def change
    create_table :events do |t|
      t.string :event_name
      t.string :gender
      t.references :discipline, index: true

      t.timestamps
    end
  end
end
