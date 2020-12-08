class CandidateImporter
  class << self
    def update_from_attributes!(candidate, attributes)
      candidate.update!(state: attributes['state'], assigned: attributes['assigned_to']['email'])
    end

    def create_from_attributes!(candidate_attributes)
      if candidate = Candidate.where(recruiter_box_id: candidate_attributes['id']).first
        puts "Candidate exists #{candidate.first_name} #{candidate.last_name}"
        return 
      else
        puts "Importing: #{candidate_attributes['first_name']} #{candidate_attributes['last_name']}"
        Candidate.create!(
          recruiter_box_id: candidate_attributes['id'],
          first_name: candidate_attributes['first_name'],
          last_name: candidate_attributes['last_name'],
          email: candidate_attributes['email'],
          start_date_epoch: candidate_attributes['created_date'],
          source: candidate_attributes['source'],
          stage_id: candidate_attributes['stage_id'],
          opening_id: candidate_attributes['opening_id'],
        )
      end
    end
  end
end