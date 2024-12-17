class CreateUrls < ActiveRecord::Migration[7.1]
  def change
    create_table :urls do |t|
      t.string :original_url, null: false
      t.string :short_code, null: false, index: { unique: true }

      t.timestamps
    end
  end
end
