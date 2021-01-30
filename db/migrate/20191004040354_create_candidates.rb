class CreateCandidates < ActiveRecord::Migration[5.2]
  def change
    create_table :candidates do |t|
      t.integer :recruiter_box_id
      t.integer :start_date_epoch
      t.integer :updated_date_epoch
      t.integer :end_date_epoch
      t.string  :first_name
      t.string  :last_name
      t.string  :email
      t.string  :source
      t.integer :stage_id
      t.integer :opening_id
      t.string  :state
      t.timestamps
    end
  end
end
