class AddBestToAnswer < ActiveRecord::Migration[7.2]
  def change
    add_column :answers, :best, :boolean, default: false, null: false
  end
end
