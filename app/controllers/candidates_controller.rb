class CandidatesController < ApplicationController
  def index
    update_candidates_from_import if refresh?

    @candidates = Candidate.in_consultant_opening.active.order(start_date_epoch: :desc).map do |candidate|
      Candidates::IndexPresenter.new(candidate)
    end

    @devops_candidates = Candidate.in_devops_opening.active.order(start_date_epoch: :desc).map do |candidate|
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

  def refresh?
    return true
    params[:refresh].present?
  end
  
  def update_candidates_from_import
    Services::AtsSinkingService.new.sync_candidates
  end
end
