Rails.application.routes.draw do
  # get 'pages/game'
  get 'game', to: "pages#game"
  # get 'pages/score'
  get 'score', to: "pages#score"
  # get 'pages/result'
  get 'result', to: "pages#result"
  get '/', to: "pages#game"

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
