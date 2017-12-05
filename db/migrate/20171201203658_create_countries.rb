class CreateCountries < ActiveRecord::Migration[5.1]
  def change
    create_table :countries do |t|
      t.string :country_name
      t.string :noc

      t.timestamps
    end
  end
end
