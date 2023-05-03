# frozen_string_literal: true

class AddTemperToResolution < ActiveRecord::Migration[7.0]
  def change
    add_column :resolutions, :temper, :integer
  end
end