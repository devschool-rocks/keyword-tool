class CreatePageFactors < ActiveRecord::Migration
  def change
    create_table :page_factors do |t|
      t.string :title
      t.string :description
      t.string :h1
      t.string :html_text_ratio
      t.references :ranking, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
