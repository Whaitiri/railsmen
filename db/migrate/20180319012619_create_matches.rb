class CreateMatches < ActiveRecord::Migration[5.1]
  def change
    create_table :matches do |t|
      t.string :word
      t.integer :game_won

      t.timestamps
    end
    add_reference(:matches, :current_game, foreign_key: {to_table: :games})
  end
end
