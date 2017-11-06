class CreateUser < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
        t.string :name
        t.text :email
        t.text :pwd
        t.timestamps null: false
      end
  end
end
