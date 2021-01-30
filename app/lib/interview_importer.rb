class InterviewImporter
  class << self
    def create_or_update!(attributes)
      attributes.each do |interview_attributes|
        interview = Interview.find_by(recruiterbox_id: interview_attributes['id'])
        interview.nil? ? create!(interview_attributes) : update!(interview, interview_attributes)
      end
    end

    def update!(interview, attributes)
      puts "Updating Interview: #{attributes['title']}"
      interview.update!(
        title: attributes['title'],
        time_epoch: attributes['time'],
        date_created: attributes['date_created'],
      )
    end

    def create!(attributes)
      user_attrs = attributes['invitees'].first
      candidate_attrs = attributes['candidate']

      user = User.find_or_create_by(name: user_attrs['name'], email: user_attrs['email']) 
      candidate = Candidate.find_by(recruiterbox_id: candidate_attrs['id']) 

      puts "Creating Interview: #{attributes['title']} for #{candidate.id} - #{candidate.name} w/ user: #{user.id} - #{user.name}"
      if Interview.where(recruiterbox_id: attributes['id']).exists?
        puts "Interview exists, exiting."
        return 
      else
        Interview.create!(
          recruiterbox_id: attributes['id'],
          title: attributes['title'],
          time_epoch: attributes['time'],
          date_created: attributes['date_created'],
          candidate_id: candidate.id,
          user_id: user.id
        )
      end
    end
  end
end