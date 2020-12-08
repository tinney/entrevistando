class CandidatesController < ApplicationController
  def index
    @candidates = Candidate.in_consultant_openings.active
  end

  def show
    candidate = Candidate.find(params[:id])
    render 'show', locals: {candidate: candidate}
  end
end
