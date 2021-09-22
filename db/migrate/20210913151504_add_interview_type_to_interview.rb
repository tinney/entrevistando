class AddInterviewTypeToInterview < ActiveRecord::Migration[6.0]
  def change
    add_column :interviews, :type, :string
  end
end
