class CreateAccounts < ActiveRecord::Migration[5.2]
  def change
    create_table :accounts do |t|
      t.string :phone, null: false
      t.string :password, null: false
      t.text :token, null: false
      t.boolean  :is_export, default: false, null: false
      t.boolean :is_normal, default: true, null: false
      t.string :time
      t.string :operator
      t.string :link

      t.timestamps
    end
  end
end
