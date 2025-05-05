# frozen_string_literal: true

class AddAdminOnlyToTopics < ActiveRecord::Migration[6.0]
    def change
      add_column :topics, :admin_only, :boolean, default: false
    end
  end
  