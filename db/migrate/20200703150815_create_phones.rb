class CreatePhones < ActiveRecord::Migration[5.1]
  def change
    create_table :phones do |t|
      t.bigint :number, index: { unique: true }, limit: 10
      t.boolean :system_genrated, default: false
      t.boolean :special_number, default: false
      t.timestamps
    end
  end
end
