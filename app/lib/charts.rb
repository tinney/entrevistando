class Charts
  class << self
    def weekly_candidates
      map_weekly_counts(Finders::CandidateFinder.recent_consultants)
    end

    def weekly_subcontractors
      map_weekly_counts(Finders::CandidateFinder.recent_subcontractors)
    end

    def weekly_staffing_needs
      [
      {
        name: "Staffing Needs", 
        data: {
          "01/04": "19",
          "01/11": "7",
          "01/18": "9",
          "01/25": "13"
        }
      },
      {
        name: "Bench",
        data: {
          "01/04": "0",
          "01/11": "1",
          "01/18": "1",
          "01/25": "2"
        }
      }
    ]
    end
    
    def subcontractor_percent
      { 
        "2021-01-17": (17 / 54.0) * 100,
        "2021-01-10": (17 / 54.0) * 100,
        "2020-12-27": (18 / 54.0) * 100,
        "2020-12-20": (18 / 53.0) * 100,
        "2020-12-13": (18 / 51.0) * 100,
        "2020-12-06": (18 / 51.0) * 100,
        "2020-11-29": (18 / 52.0) * 100,
        "2020-11-22": (17 / 50.0) * 100,
        "2020-11-15": (17 / 51.0) * 100,
        "2020-11-08": (17 / 50.0) * 100,
        "2020-11-01": (18 / 48.0) * 100
      }
      # 2021-01-17 | SUB       |    17
      # 2021-01-10 | FTE       |    54
      # 2021-01-10 | SUB       |    17
      # 2021-01-03 | SUB       |    17
      # 2021-01-03 | FTE       |    54
      # 2020-12-27 | FTE       |    53
      # 2020-12-27 | SUB       |    18
      # 2020-12-20 | FTE       |    53
      # 2020-12-20 | SUB       |    17
      # 2020-12-13 | FTE       |    52
      # 2020-12-13 | SUB       |    18
      # 2020-12-06 | FTE       |    51
      # 2020-12-06 | SUB       |    18
      # 2020-11-29 | FTE       |    52
      # 2020-11-29 | SUB       |    18
      # 2020-11-22 | FTE       |    50
      # 2020-11-22 | SUB       |    17
      # 2020-11-15 | SUB       |    17
      # 2020-11-15 | FTE       |    51
      # 2020-11-08 | SUB       |    17
      # 2020-11-08 | FTE       |    50
      # 2020-11-01 | FTE       |    48
      # 2020-11-01 | SUB       |    18
    end

    def percent_offers
      percent_offers = {}
      candidates = Candidate.in_consultant_opening
        .inactive
        .interviewed
        
      percent_offers = candidates.group_by { |c| c.state }
      percent_offers.each { |k, v| percent_offers[k] = to_percent(v.count, candidates.count) }
    end

    private

    def to_percent(value, total)
      ((value / total.to_f) * 100).to_i
    end

    def map_weekly_counts(candidates)
      weekly_counts = Hash.new(0)
      recent_candidates = candidates.filter { |c| c.start_date.cwyear == Date.today.year }

      recent_candidates.each do |candidate|
        key = candidate.start_date.beginning_of_week.strftime("%m/%d")
        weekly_counts[key] += 1
      end

      weekly_counts.sort
    end
  end
end