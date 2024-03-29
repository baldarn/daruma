# frozen_string_literal: true

class Rpush330Updates < ActiveRecord::Migration[5.0]
  def self.up
    add_column :rpush_notifications, :thread_id, :string, null: true
  end

  def self.down
    remove_column :rpush_notifications, :thread_id
  end
end
