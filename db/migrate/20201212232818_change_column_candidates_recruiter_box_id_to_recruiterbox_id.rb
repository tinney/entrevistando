class ChangeColumnCandidatesRecruiterBoxIdToRecruiterboxId < ActiveRecord::Migration[6.0]
  def change
    rename_column :candidates, :recruiter_box_id, :recruiterbox_id
  end
end
