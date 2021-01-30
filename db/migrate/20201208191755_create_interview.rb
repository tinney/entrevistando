class CreateInterview < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :email
      t.string :name
      t.timestamps
    end

    
    create_table :interviews do |t|
      t.integer :recruiterbox_id
      t.string :title
      t.integer :time_epoch
      t.integer :date_created
      t.references :candidate
      t.references :user
    end
  end
end