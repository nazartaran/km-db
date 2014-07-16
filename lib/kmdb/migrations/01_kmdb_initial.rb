=begin
  
  Setup a custom database for KissMetrics tracking events.

=end
require 'active_record'
require 'kmdb'

class KmdbInitial < ActiveRecord::Migration

  def up
    create_table :events do |t|
      t.integer  :user_id
      t.integer  :n
      t.datetime :t
    end
    add_index :events, [:n],          using: :hash
    add_index :events, [:user_id],    using: :hash


    create_table :keys do |t|
      t.string :string
    end
    add_index :keys, [:string],         using: :hash

    create_table :properties do |t|
      t.integer  :user_id
      t.integer  :event_id
      t.integer  :key
      t.string   :value
      t.datetime :t
    end
    add_index :properties, [:key],      using: :hash
    add_index :properties, [:user_id],  using: :hash
    add_index :properties, [:event_id], using: :hash
    add_index :properties, [:t, :id],   unique: true # for partitioning purposes

    create_table :users do |t|
      t.string  :name, :limit => 48
      t.integer :alias_id
    end
    add_index :users, [:name]

    create_table :dumpfiles do |t|
      t.string  :path
      t.integer :offset
    end
    add_index :dumpfiles, [:path]
  end

  def down
    drop_table :events
    drop_table :properties
    drop_table :users
    drop_table :aliases
  end
end