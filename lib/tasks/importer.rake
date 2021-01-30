namespace :importer do
  desc "Import Candidate CSV"
  task import_candidate_csv: :environment do
    ARGV.each { |a| task a.to_sym do ; end }

    file = File.open(ARGV[1])
    RecruiterBoxCsvParser.parse_candidates(file) do |attributes|
      CandidateImporter.create_or_update_from_csv!(attributes)
    end
  end

  desc "Import Interview CSV"
  task import_interview_csv: :environment do
    ARGV.each { |a| task a.to_sym do ; end }

    file = File.open(ARGV[1])
    RecruiterBoxCsvParser.parse_interviews(file) do |attributes|
      CandidateImporter.create_or_update_interview_from_csv!(attributes)
    end
  end

  desc "Import/Update Most Recent 100 Candidates"
  task import_candidates: :environment do
    RecruiterBoxService.candidates(limit: 100) do |candidate_attributes|
      CandidateImporter.create_from_attributes!(candidate_attributes)
    end
  end

  desc "Import/Update All Candidates — use to populate database for the first time"
  task import_all_candidates: :environment do
    RecruiterBoxService.all_candidates do |candidate_attributes|
      CandidateImporter.create_from_attributes!(candidate_attributes)
    end
  end

  desc "Populate 10 most recent candidates' details from recruiterbox"
  task populate_candidates: :environment do
    #update to not to DQ'ed candidates
    Candidate.unpopulated.order(start_date_epoch: :desc).limit(10).each do |candidate|
      puts "Updating: #{candidate.name}"
      attrs = RecruiterBoxService.candidate(recruiterbox_id: candidate.recruiterbox_id)
      CandidateImporter.update_from_attributes!(candidate, attrs)
    end
  end
  
  desc "Updates 10 most recent candidates' details"
  task update_consultants: :environment do
    #update to not to DQ'ed candidates
    Candidate.in_consultant_opening.order(start_date_epoch: :desc).active.each do |candidate|
      puts "Updating: #{candidate.name}"
      attrs = RecruiterBoxService.candidate(recruiterbox_id: candidate.recruiterbox_id)
      CandidateImporter.update_from_attributes!(candidate, attrs)
    end

    Candidate.in_subcontractor_opening.order(start_date_epoch: :desc).active.each do |candidate|
      puts "Updating: #{candidate.name}"
      attrs = RecruiterBoxService.candidate(recruiterbox_id: candidate.recruiterbox_id)
      CandidateImporter.update_from_attributes!(candidate, attrs)
    end
  end

  desc "Populate Active Candidates Interviews"
  task populate_interviews: :environment do
    Candidate.in_consultant_opening.active.each do |candidate|
      puts "Updating interviews for: #{candidate.name}"
      interview_attributes = RecruiterBoxService.interviews(candidate_id: candidate.recruiterbox_id)
      InterviewImporter.create_or_update!(interview_attributes)
    end

    Candidate.in_subcontractor_opening.order(start_date_epoch: :desc).active.each do |candidate|
      puts "Updating interviews for: #{candidate.name}"
      interview_attributes = RecruiterBoxService.interviews(candidate_id: candidate.recruiterbox_id)
      InterviewImporter.create_or_update!(interview_attributes)
    end
  end

  desc "rePopulate candidate from recruiterbox"
  task repopulate_active_candidates: :environment do
    #update to not to DQ'ed candidates
    Candidate.last_12_months.each do |candidate|
      puts "Updating: #{candidate.name}"
      sleep 1 
      attrs = RecruiterBoxService.candidate(recruiterbox_id: candidate.recruiterbox_id)
      CandidateImporter.update_from_attributes!(candidate, attrs)
    end
  end
end
