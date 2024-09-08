class ChangeColumnsToQuestion < ActiveRecord::Migration[7.2]
  def change
    change_column_null(:questions, :title, false)
    change_column_null(:questions, :body, false)
  end
end
