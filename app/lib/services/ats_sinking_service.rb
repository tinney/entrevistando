class Services::AtsSinkingService
  def sync_candidates
    inactive_ids = Candidate.inactive.pluck(:recruiterbox_id)
    active_candidate_ids = Candidate.active.pluck(:recruiterbox_id)

    candidate_rb_ids = []
    RecruiterBoxService.candidates(limit: 20) do |candidate_attributes|
      candidate_rb_ids << candidate_attributes["id"]
    end

    ids_for_import = (active_candidate_ids + candidate_rb_ids) - inactive_ids



    puts "=" * 100
    puts "=" * 100
    puts "=" * 100
    puts "=" * 100
    puts "Importing Candidates"

    puts "Total #{ids_for_import.count}"
    puts "Active #{active_candidate_ids.count}"
    puts "RB #{candidate_rb_ids.count}"
    puts "Together #{(active_candidate_ids + candidate_rb_ids).uniq.count}"
    puts "Inactive #{inactive_ids.count}"

    return

    candidate_rb_ids.each do |id|
      candidate_attributes = RecruiterBoxService.candidate(recruiterbox_id: id)

      if CandidateImporter.needs_import?(candidate_attributes)
        candidate = CandidateImporter.create_or_update_from_attributes!(candidate_attributes)
        interviews = RecruiterBoxService.interviews(candidate_id: id)
        InterviewImporter.create_or_update_all!(interviews)

        sleep(1)
      else
        puts "Skipping candidate #{candidate_attributes['first_name']} #{candidate_attributes['last_name']}"
      end
    end
  end
end