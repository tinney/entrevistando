class Candidates::IndexPresenter
  include ActionView::Helpers::DateHelper

  attr_reader :candidate

  delegate :name, :start_date, :stage, :assigned_to, :id, :interviews, to: :candidate

  def initialize(candidate)
    @candidate = candidate
  end

  def pairing_date
    interview = interviews.pairing.first
    format_time(interview)
  end
  
  def technical_date
    interview = interviews.technical.first
    format_time(interview)
  end
  
  def consulting_date
    interview = interviews.consulting.first
    format_time(interview)
  end

  def takehome_date
    interview = interviews.takehome.first
    format_time(interview)
  end

  def determination_date
    interview = interviews.determination.first
    format_time(interview)
  end

  def format_time(interview)
    return '-' unless interview
    return 'slots suggested' unless interview.time

    time = interview.time

    if time > Time.now
      time.strftime("%a")
    else
      "#{time_ago_in_words(time)} ago"
    end
  end
end