class CreateSettings < ActiveRecord::Migration[5.2]
  def change
    create_table :settings do |t|
      t.string :title, null: false  # 网站标题
      t.string :description, null: false  # 网站描述
      t.string :domain_name, null: false  # 域名

      t.timestamps
    end
  end
end
