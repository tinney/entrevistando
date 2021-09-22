class CandidateImporter
  class << self
    def create_or_update_interview_from_csv!(attributes)
      Interview.create!(attributes)
      # if candidate = Candidate.where(recruiterbox_id: attributes[:recruiterbox_id]).first
      #   puts "Updating #{attributes[:first_name]}, #{attributes[:last_name]}"
      #   candidate.update!(attributes)
      # else
      #   puts "Importing #{attributes[:first_name]}, #{attributes[:last_name]}"
      # end
    end

    def needs_import?(attributes)
      candidate = Candidate.find_by(recruiterbox_id: attributes[:recruiterbox_id])

      return true unless candidate
      return true if candidate.active
      
      candidate.state != attributes['state']
    end

    def create_or_update_from_csv!(attributes)
      if candidate = Candidate.find_by(recruiterbox_id: attributes[:recruiterbox_id])
        puts "Updating #{attributes[:first_name]}, #{attributes[:last_name]}"
        candidate.update!(attributes)
      else
        puts "Importing #{attributes[:first_name]}, #{attributes[:last_name]}"
        Candidate.create!(attributes)
      end
    end

    def update_from_attributes!(candidate, attributes)
      puts "Updating Candidate #{candidate.first_name} #{candidate.last_name}"
      candidate.update!(
        first_name: attributes['first_name'],
        last_name: attributes['last_name'],
        email: attributes['email'],
        start_date_epoch: attributes['created_date'],
        updated_date_epoch: attributes['updated_date'],
        assigned: attributes['assigned_to']['email'],
        source: attributes['source'],
        opening_id: attributes['opening_id'],
        stage_id: attributes['stage_id'],
        state: attributes['state']
      )
    end

    def create_from_attributes!(candidate_attributes)
      if Candidate.find_by(recruiterbox_id: candidate_attributes['id'])
        puts "Skipping #{candidate_attributes['first_name']} #{candidate_attributes['last_name']} exists"
      else
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