require 'httparty'

class RecruiterBoxService
  MAX_CANDIDATES = 100
  DEFAULT_OFFSET = 0 # recruiter box is backwards so newest candidates will be 0 - X

  class << self
    def all_candidates
      offset = DEFAULT_OFFSET

      while(true) do
        candidate_attrs = get_candidates_attrs(limit: MAX_CANDIDATES, offset: offset)

        candidate_attrs.each do |candidate_attr|
          offset += 1 
          yield candidate_attr
        end

        break if candidate_attrs.count < MAX_CANDIDATES
      end
    end

    def candidates(limit: MAX_CANDIDATES, offset: DEFAULT_OFFSET)
      raise "Limit must be less than 100" if limit > MAX_CANDIDATES
      get_candidates_attrs(offset: offset, limit: limit).each do |candidate_attrs|
        yield candidate_attrs
      end
    end

    def candidate(recruiter_box_id:)
      get("candidates/#{recruiter_box_id}")
    end

    def candidate_interviews(recruiter_box_id:)
      get("interviews?candidate_id=#{recruiter_box_id}")
    end

    def candidate_evaluations(recruiter_box_id:)
      get("evaluations?candidate_id=#{recruiter_box_id}")
    end

    def candidate_resource(resource:, id:)
      get("#{resource}?candidate_id=#{id}")
    end


    private
    def api_key
      '920f9e34c6a2440e901ea7ded4ab0d38'
    end


    def get_candidates_attrs(offset:, limit:)
      attributes = get("candidates?offset=#{offset}&limit=#{limit}")['objects']
      raise "No candidate attrs found API error" if attributes.nil?
      attributes
    end

    def get(resource)
      uri = "https://api.recruiterbox.com/v2/#{resource}"
      auth = {:username => api_key}
      response = HTTParty.get(uri, basic_auth: auth)
      JSON.parse(response.body)
    end
  end
end

