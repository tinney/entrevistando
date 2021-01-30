# == Schema Information
#
# Table name: candidates
#
#  id               :integer          not null, primary key
#  recruiterbox_id  :integer
#  start_date_epoch :integer
#  end_date_epoch   :integer
#  first_name       :string
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
  SENIOR_SOFTWARE_CONSULTANT_OPENING_ID = 254644.freeze
  SUBCONTRACTOR_OPENING = 332205.freeze
  THREE_DAYS_IN_SECONDS = 259_200.freeze

  has_many :interviews

  scope :active, -> { where(state: 'in_process') }
  scope :inactive, -> { where(state: ["rejected", "hired", "withdrawn", "declined_offer"]) }
  scope :unpopulated, -> { where(state: nil) }
  scope :in_consultant_opening, -> { where(opening_id: SENIOR_SOFTWARE_CONSULTANT_OPENING_ID) }
  scope :in_subcontractor_opening, -> { where(opening_id: SUBCONTRACTOR_OPENING) }

  scope :this_year, -> { where("start_date_epoch >= ?", Date.today.beginning_of_year.to_time.to_i) }
  scope :last_12_months, -> { where("start_date_epoch >= ?", 1.year.ago.to_i) }
  scope :interviewed, -> { where("end_date_epoch IS NULL OR (end_date_epoch - start_date_epoch) > ?", THREE_DAYS_IN_SECONDS) }

  def stage
    stages[stage_id] || stage_id
  end

  def name
    "#{first_name} #{last_name}"
  end

  def start_date
    Time.at(start_date_epoch).to_date
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
