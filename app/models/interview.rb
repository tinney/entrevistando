# == Schema Information
#
# Table name: interviews
#
#  id              :integer          not null, primary key
#  recruiterbox_id :integer
#  title           :string
#  time_epoch      :integer
#  date_created    :integer
#  candidate_id    :integer
#  user_id         :integer
#
class Interview < ApplicationRecord
  PAIRING_TITLE = "Pairing Interview"
  CONSULTING_TITLE = "Consulting Interview"
  TECHNICAL_TITLE = "Technical"
  TAKEHOME_TITLE = "Home"
  DETERMINATION_TITLE = "Determination"

  belongs_to :candidate
  belongs_to :user

  scope :pairing, -> { where(title: PAIRING_TITLE) }
  scope :consulting, -> { where(title: CONSULTING_TITLE) }
  scope :technical, -> { where("title like ?", "%#{TECHNICAL_TITLE}%") }
  scope :takehome, -> { where("title like ?", "%#{TAKEHOME_TITLE}%") }
  scope :determination, -> { where("title like ?", "#{DETERMINATION_TITLE}%") }

  def date
    Time.at(date_created)
  end

  def time
    time_epoch && Time.at(time_epoch)
  end
end
