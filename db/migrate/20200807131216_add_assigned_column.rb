class AddAssignedColumn < ActiveRecord::Migration[5.2]
  def change
    add_column :candidates, :assigned, :string
  end
end
