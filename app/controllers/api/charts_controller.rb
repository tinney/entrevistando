 class Api::ChartsController < Api::ApiController
  def weekly_candidates
    render json: Charts.weekly_candidates
  end

  def weekly_subcontractors
    render json: Charts.weekly_subcontractors
  end

  def weekly_staffing_needs
    render json: Charts.weekly_staffing_needs
  end
  
  def subcontractor_percent
    render json: Charts.subcontractor_percent
  end

  def percent_offers
    render json: Charts.percent_offers
  end
 end