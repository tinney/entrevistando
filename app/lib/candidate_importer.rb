class CandidateImporter
  class << self
    def update_from_attributes!(candidate, attributes)
      candidate.update!(
        first_name: attributes['first_name'],
        last_name: attributes['last_name'],
        email: attributes['email'],
        start_date_epoch: attributes['created_date'],
        updated_date_epoch: attributes['updated_date'],
        state: attributes['state'],
        assigned: attributes['assigned_to']['email'],
        source: attributes['source'],
        opening_id: attributes['opening_id'],
        stage_id: attributes['stage_id'],
      )
    end

    def create_or_update_interview_from_csv!(attributes)
      Interview.create!(attributes)
      # if candidate = Candidate.where(recruiterbox_id: attributes[:recruiterbox_id]).first
      #   puts "Updating #{attributes[:first_name]}, #{attributes[:last_name]}"
      #   candidate.update!(attributes)
      # else
      #   puts "Importing #{attributes[:first_name]}, #{attributes[:last_name]}"
      # end
    end

    def create_or_update_from_csv!(attributes)
      if candidate = Candidate.where(recruiterbox_id: attributes[:recruiterbox_id]).first
        puts "Updating #{attributes[:first_name]}, #{attributes[:last_name]}"
        candidate.update!(attributes)
      else
        puts "Importing #{attributes[:first_name]}, #{attributes[:last_name]}"
        Candidate.create!(attributes)
      end
    end

    def create_from_attributes!(candidate_attributes)
      if candidate = Candidate.where(recruiterbox_id: candidate_attributes['id']).first
        puts "Updating Candidate #{candidate.first_name} #{candidate.last_name}"
        Candidate.update(
          updated_date_epoch: candidate_attributes['updated_date'],
          stage_id: candidate_attributes['stage_id'],
          opening_id: candidate_attributes['opening_id'],
        )
      else
        puts "Importing: #{candidate_attributes['first_name']} #{candidate_attributes['last_name']}"
        Candidate.create!(
          recruiterbox_id: candidate_attributes['id'],
          first_name: candidate_attributes['first_name'],
          last_name: candidate_attributes['last_name'],
          email: candidate_attributes['email'],
          start_date_epoch: candidate_attributes['created_date'],
          updated_date_epoch: candidate_attributes['updated_date'],
          source: candidate_attributes['source'],
          stage_id: candidate_attributes['stage_id'],
          opening_id: candidate_attributes['opening_id'],
        )
      end
    end
  end
end