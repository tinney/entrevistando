class Candidates::IndexPresenter
  include ActionView::Helpers::DateHelper

  attr_reader :candidate

  delegate :name, :start_date, :stage, :assigned_to, :id, :recruiterbox_id, :interviews, to: :candidate

  def initialize(candidate)
    @candidate = candidate
  end

  def bridge_date
    interview = interviews.bridge.first
    format_time(interview)
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

  def bridge_state
    interview = interviews.bridge.first
    state(interview)
  end

  def pairing_state
    interview = interviews.pairing.first
    state(interview)
  end
  
  def technical_state
    interview = interviews.technical.first
    state(interview)
  end
  
  def consulting_state
    interview = interviews.consulting.first
    state(interview)
  end

  def takehome_state
    interview = interviews.takehome.first
    state(interview)
  end

  def determination_state
    interview = interviews.determination.first
    state(interview)
  end

  def state(interview)
    return 'upcoming' unless interview
    return 'current' unless interview.time

    if interview.time > Time.now
      "current"
    else
      "completed"
    end
  end

  def format_time(interview)
    return '-' unless interview
    return 'slots suggested' unless interview.time

    time = interview.time

    if time > Time.now
      time.strftime("%a")
    else
      "✓"
    end
  end
end