namespace :importer do
  desc "Daily Importer"
  task daily_import: :environment do
    # Import 100 most recenet candidates
    RecruiterBoxService.candidates do |candidate_attributes|
      CandidateImporter.create_from_attributes!(candidate_attributes)
    end

    Candidate.unpopulated.order(start_date_epoch: :desc).each_slice(30) do |candidates|
      puts "Updating 30 Candidates"
      candidates.each do |candidate|
        attrs = RecruiterBoxService.candidate(recruiterbox_id: candidate.recruiterbox_id)
        CandidateImporter.update_from_attributes!(candidate, attrs)
      end
      puts "Phew, that's a lot resting."
      sleep(60)
    end

    Candidate.active.each do |candidate|
      puts "Updating interviews for: #{candidate.name}"
      interview_attributes = RecruiterBoxService.interviews(candidate_id: candidate.recruiterbox_id)
      InterviewImporter.create_or_update_all!(interview_attributes)
    end
  end

  desc "Import All Candidates (reseed database from Recruiterbox)"
  task import_candidates: :environment do
    RecruiterBoxService.all_candidates do |candidate_attributes|
      CandidateImporter.create_from_attributes!(candidate_attributes)
    end
  end

  desc "Import 30 most recent candidates' details from recruiterbox"
  task populate_candidates: :environment do
    #update to not to DQ'ed candidates
    Candidate.unpopulated.order(start_date_epoch: :desc).limit(30).each do |candidate|
      puts "Updating: #{candidate.name}"
      attrs = RecruiterBoxService.candidate(recruiterbox_id: candidate.recruiterbox_id)
      CandidateImporter.update_from_attributes!(candidate, attrs)
    end
  end

  desc "Populate All candidate details (long running)"
  task populate_all_candidates: :environment do
    #update to not to DQ'ed candidates
    Candidate.unpopulated.order(start_date_epoch: :desc).each_slice(30) do |candidates|
      puts "Updating 30"
      candidates.each do |candidate|
        puts "Updating: #{candidate.name}"
        attrs = RecruiterBoxService.candidate(recruiterbox_id: candidate.recruiterbox_id)
        CandidateImporter.update_from_attributes!(candidate, attrs)
      end
      puts "Phew, that's a lot resting."
      sleep(60)
    end
  end

  desc "Import Interview CSV — Import a download from the ATS"
  task import_interview_csv: :environment do
    ARGV.each { |a| task a.to_sym do ; end }

    file = File.open(ARGV[1])
    RecruiterBoxCsvParser.parse_interviews(file) do |attributes|
      CandidateImporter.create_or_update_interview_from_csv!(attributes)
    end
  end

  desc "Populate Active Candidates Interviews"
  task populate_interviews: :environment do
    Candidate.active.each do |candidate|
      puts "Updating interviews for: #{candidate.name}"
      interview_attributes = RecruiterBoxService.interviews(candidate_id: candidate.recruiterbox_id)
      InterviewImporter.create_or_update_all!(interview_attributes)
    end
  end


  # desc "Import Candidate CSV"
  # task import_candidate_csv: :environment do
  #   ARGV.each { |a| task a.to_sym do ; end }

  #   file = File.open(ARGV[1])
  #   RecruiterBoxCsvParser.parse_candidates(file) do |attributes|
  #     CandidateImporter.create_or_update_from_csv!(attributes)
  #   end
  # end



  # desc "Import/Update All Candidates — use to populate database for the first time"
  # task import_all_candidates: :environment do
  #   RecruiterBoxService.all_candidates do |candidate_attributes|
  #     CandidateImporter.create_from_attributes!(candidate_attributes)
  #   end
  # end

  # desc "Populate 10 most recent candidates' details from recruiterbox"
  # task populate_candidates: :environment do
  #   #update to not to DQ'ed candidates
  #   Candidate.unpopulated.order(start_date_epoch: :desc).limit(10).each do |candidate|
  #     puts "Updating: #{candidate.name}"
  #     attrs = RecruiterBoxService.candidate(recruiterbox_id: candidate.recruiterbox_id)
  #     CandidateImporter.update_from_attributes!(candidate, attrs)
  #   end
  # end
  
  # desc "Updates 10 most recent candidates' details"
  # task update_consultants: :environment do
  #   #update to not to DQ'ed candidates
  #   Candidate.in_consultant_opening.order(start_date_epoch: :desc).active.each do |candidate|
  #     puts "Updating: #{candidate.name}"
  #     attrs = RecruiterBoxService.candidate(recruiterbox_id: candidate.recruiterbox_id)
  #     CandidateImporter.update_from_attributes!(candidate, attrs)
  #   end

  #   Candidate.in_subcontractor_opening.order(start_date_epoch: :desc).active.each do |candidate|
  #     puts "Updating: #{candidate.name}"
  #     attrs = RecruiterBoxService.candidate(recruiterbox_id: candidate.recruiterbox_id)
  #     CandidateImporter.update_from_attributes!(candidate, attrs)
  #   end
  # end

  # desc "rePopulate candidate from recruiterbox"
  # task repopulate_active_candidates: :environment do
  #   #update to not to DQ'ed candidates
  #   Candidate.last_12_months.each do |candidate|
  #     puts "Updating: #{candidate.name}"
  #     sleep 1 
  #     attrs = RecruiterBoxService.candidate(recruiterbox_id: candidate.recruiterbox_id)
  #     CandidateImporter.update_from_attributes!(candidate, attrs)
  #   end
  # end
end
