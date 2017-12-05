class CreateAthletes < ActiveRecord::Migration[5.1]
  def change
    create_table :athletes do |t|
      t.string :first_name
      t.string :last_name
      t.string :gender

      t.timestamps
    end
  end
end
