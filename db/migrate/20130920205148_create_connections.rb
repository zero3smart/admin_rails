class CreateConnections < ActiveRecord::Migration
  def change
    create_table :connections do |t|
      t.integer :user_id
      t.integer :contact_id
      t.boolean :is_pending

      t.timestamps
    end
  end
end
