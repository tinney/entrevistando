require 'httparty'

class RecruiterBoxService
  MAX_CANDIDATES = 100
  DEFAULT_OFFSET = 0 # recruiter box is backwards so newest candidates will be 0 - X

  class << self
    def all_candidates
      offset = DEFAULT_OFFSET

      while(true) do
        sleep(4)
        candidate_attrs = get_candidates_attrs(limit: MAX_CANDIDATES, offset: offset)

        candidate_attrs.each do |candidate_attr|
          offset += 1 
          yield candidate_attr
        end

        break if candidate_attrs.count < MAX_CANDIDATES
      end
    end

    def candidates(limit: MAX_CANDIDATES, offset: DEFAULT_OFFSET)
      raise "Limit must be 100 or less" if limit > MAX_CANDIDATES
      get_candidates_attrs(offset: offset, limit: limit).each do |candidate_attrs|
        yield candidate_attrs
      end
    end

    def candidate(recruiterbox_id:)
      get("candidates/#{recruiterbox_id}")
    end

    def interviews(candidate_id: nil)
      attributes = candidate_id.nil? ? get("interviews") : get("interviews?candidate_id=#{candidate_id}")
      raise "No interviews found API error" if attributes.nil?
      attributes['objects']
    end

    def interview(id:)
      get("interviews/#{id}")
    end

    def candidate_evaluations(recruiterbox_id:)
      get("evaluations?candidate_id=#{recruiterbox_id}")
    end

    def candidate_resource(resource:, id:)
      get("#{resource}?candidate_id=#{id}")
    end


    private
    def api_key
      ENV.fetch("RECRUITERBOX_API_KEY")
    end

    def get_candidates_attrs(offset:, limit:)
      attributes = get("candidates?offset=#{offset}&limit=#{limit}")['objects']
      raise "No candidate attrs found API error" if attributes.nil?
      attributes
    end

    def get_interview_attrs()
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

