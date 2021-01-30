class CandidatesController < ApplicationController
  def index
    #update_all_the_things if params[:refresh]
    #update_candidates

    @candidates = Candidate.in_consultant_opening.active.order(start_date_epoch: :desc).map do |candidate|
      Candidates::IndexPresenter.new(candidate)
    end

    @subcontractors = Candidate.in_subcontractor_opening.active.order(start_date_epoch: :desc).map do |candidate|
      Candidates::IndexPresenter.new(candidate)
    end
  end

  def show
    candidate = Candidate.find(params[:id])
    render 'show', locals: {candidate: candidate}
  end

  private

  def update_candidates
    RecruiterBoxService.candidates(limit: 100) do |candidate_attributes|
      CandidateImporter.create_from_attributes!(candidate_attributes)
    end
  end
  
  def update_all_the_things
    RecruiterBoxService.candidates(limit: 100) do |candidate_attributes|
      CandidateImporter.create_from_attributes!(candidate_attributes)
    end

    Candidate.unpopulated.order(start_date_epoch: :desc).limit(10).each do |candidate|
      puts "Updating: #{candidate.name}"
      attrs = RecruiterBoxService.candidate(recruiterbox_id: candidate.recruiterbox_id)
      CandidateImporter.update_from_attributes!(candidate, attrs)
    end

    Candidate.in_consultant_opening.order(start_date_epoch: :desc).active.each do |candidate|
      attrs = RecruiterBoxService.candidate(recruiterbox_id: candidate.recruiterbox_id)
      CandidateImporter.update_from_attributes!(candidate, attrs)
    end

    Candidate.in_subcontractor_opening.order(start_date_epoch: :desc).active.each do |candidate|
      attrs = RecruiterBoxService.candidate(recruiterbox_id: candidate.recruiterbox_id)
      CandidateImporter.update_from_attributes!(candidate, attrs)
    end

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
end
