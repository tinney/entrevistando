class RecruiterBoxCsvParser
  class << self
    def parse_interviews(file)
      csv = CSV.read(file, headers: true)
      csv.each do |row|
        attributes = row_to_interview_attributes(row)
        yield attributes unless attributes.nil?
      end
    end

    def parse_candidates(file)
      csv = CSV.read(file, headers: true)
      csv.each do |row|
        yield row_to_candidate_attributes(row)
      end
    end

    private

    def row_to_candidate_attributes(row)
      state = row["Current Candidate Status"].parameterize.underscore.to_sym
      first_name = row["Candidate Name"]&.split(" ")&.first
      last_name = row["Candidate Name"]&.split(" ")&.last
      { 
        recruiterbox_id: row["Candidate ID"], 
        first_name: first_name, 
        last_name: last_name,
        email: row["Candidate Email"],
        opening_id: row["Opening ID"],
        state: state, 
        start_date_epoch: to_epoch(row["Candidate Created On"]),
        end_date_epoch: to_epoch(row["Candidate Decisioned On"]),
      }
    end

    def row_to_interview_attributes(row)
      candidate = Candidate.find_by(recruiterbox_id: row["Candidate ID"])
      return nil unless candidate
      user = User.find_or_create_by(name: row["Interviewer"])

      { 
        candidate: candidate, 
        user: user,
        title: row["Interview Stage"],
        time_epoch: to_epoch(row["Time of Interview"]),
      }
    end

    def to_epoch(date)
      return nil unless date
      Date.parse(date).to_time.to_i
    end
  end
end