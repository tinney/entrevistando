namespace :importer do
  desc "Import/Update Most Recent 100 Candidates"
  task import_candidates: :environment do
    RecruiterBoxService.candidates(limit: 100) do |candidate_attributes|
      CandidateImporter.create_from_attributes!(candidate_attributes)
    end
  end

  desc "Import/Update All Candidates — use to populate database for the first time"
  task import_candidates: :environment do
    RecruiterBoxService.all_candidates do |candidate_attributes|
      CandidateImporter.create_from_attributes!(candidate_attributes)
    end
  end

  desc "Populate candidate from recruiterbox"
  task populate_candiates: :environment do
    #update to not to DQ'ed candidates
    Candidate.unpopulated.limit(100).each do |candidate|
      puts "Updating: #{candidate.name}"
      attrs = RecruiterBoxService.candidate(recruiter_box_id: candidate.recruiter_box_id)
      CandidateImporter.update_from_attributes!(candidate, attrs)
    end
  end

  desc "rePopulate candidate from recruiterbox"
  task repopulate_active_candiates: :environment do
    #update to not to DQ'ed candidates
    Candidate.active.limit(100).each do |candidate|
      puts "Updating: #{candidate.name}"
      attrs = RecruiterBoxService.candidate(recruiter_box_id: candidate.recruiter_box_id)
      CandidateImporter.update_from_attributes!(candidate, attrs)
    end
  end
end
