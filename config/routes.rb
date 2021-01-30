Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :candidates, :users
  resources :imports
  resource :dashboard
  root to: 'dashboards#show'

  namespace "api" do
    get 'chart_weekly_candidates', to: 'charts#weekly_candidates', as: "weekly_candidates"
    get 'chart_weekly_bench', to: 'charts#weekly_bench', as: "weekly_bench"
    get 'subcontractor_percent', to: 'charts#subcontractor_percent', as: "subcontractor_percent"
    get 'percent_offers', to: 'charts#percent_offers', as: "percent_offers"
    get 'chart_weekly_staffing_needs', to: 'charts#weekly_staffing_needs', as: "weekly_staffing_needs"

  end
end
