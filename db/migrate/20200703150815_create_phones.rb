class CreatePhones < ActiveRecord::Migration[5.1]
  def change
    create_table :phones do |t|
      t.bigint :phone
      t.timestamps
    end

    add_index :phones, :phone
  end
end
