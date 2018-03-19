class CreateMatches < ActiveRecord::Migration[5.1]
  def change
    create_table :matches do |t|
      t.references :game1
      t.references :game2

      t.timestamps
    end
  end
end
