class Finders::CandidateFinder
  class << self
    def recent_consultants
      Candidate.in_consultant_opening.this_year.interviewed
    end

    def recent_subcontractors
      Candidate.in_subcontractor_opening.this_year.interviewed
    end
  end
end