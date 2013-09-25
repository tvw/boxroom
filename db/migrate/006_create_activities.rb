class CreateActivities < ActiveRecord::Migration
  def self.up
    create_table :activities do |t|
      t.string  :category,    :null => false, :length => 20
      t.integer :user_id,     :null => true
      t.integer :object_id,   :null => true
      t.string  :object_type, :null => true,  :length => 100
      t.string  :description, :null => false

      t.timestamps
    end

    add_index :activities, :category
    add_index :activities, :user_id
    add_index :activities, [:object_id, :object_type]
  end

  def self.down
    drop_table :activities
  end
end
