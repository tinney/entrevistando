class Charts
  class << self
    def weekly_candidates
      weekly_counts = {}
      Candidate.in_consultant_opening
        .this_year
        .interviewed
        .each do |candidate|
          next unless candidate.start_date.cwyear == Date.today.year
          key = candidate.start_date.beginning_of_week.strftime("%m/%d")
          puts "#{key} - #{candidate.first_name} #{candidate.last_name}"
          weekly_counts[key] ||= 0
          weekly_counts[key] += 1
        end

      weekly_counts.sort
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
        "December": (18 / 60).to_s,
        "January": "30",
      }
    end

    def percent_offers
      percent_offers = {}
      candidates = Candidate.in_consultant_opening
        .inactive
        .interviewed
        
      percent_offers = candidates.group_by { |c| c.state }
      percent_offers.each { |k, v| percent_offers[k] = to_percent(v.count, candidates.count) }
    end

    def to_percent(value, total)
      ((value / total.to_f) * 100).to_i
    end
  end
end