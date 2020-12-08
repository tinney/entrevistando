# == Schema Information
#
# Table name: candidates
#
#  id               :integer          not null, primary key
#  recruiter_box_id :integer
#  start_date_epoch :integer
#  end_date_epoch   :integer
#  first_name       :text
#  last_name        :string
#  email            :string
#  source           :string
#  stage_id         :integer
#  opening_id       :integer
#  state            :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  assigned         :string
#

class Candidate < ApplicationRecord
  scope :active, -> { where(state: 'in_process') }
  scope :unpopulated, -> { where(state: nil) }

  SENIOR_SOFTWARE_CONSULTANT_OPENING_ID = 254644

  scope :in_consultant_openings, -> { where(opening_id: [SENIOR_SOFTWARE_CONSULTANT_OPENING_ID, 332205]) }

  def stage
    stages[stage_id] || stage_id
  end

  def name
    "#{first_name} #{last_name}"
  end

  def start_date
    Time.at(start_date_epoch)
  end

  def dq_reason
    ''
  end

  def assigned_to
    assigned
  end

  private

  def stages
    {
      2329545 => 'Technical',
      2319330 => 'Consulting',
      2319011 => 'Screening',
      2319012 => 'Social',
      2745784 => 'Bridge',
      2329547 => 'Take-home',
      2329555 => 'Pairing',
      2319014 => 'Determination',
      2626199 => 'Offer',

      2944550 => 'Prioritization', 
      2626201 => 'Send Rejection',
      2944560 => "Sub-Pairing", 
      2944562 => 'Discuss Subcontracting',
      2944556 => 'Sub-Conversation'

    }
  end
end
