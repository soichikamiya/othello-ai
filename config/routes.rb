Rails.application.routes.draw do
  # get 'othellos/reception'
  post 'othellos/reception'
  
  root 'application#hello'
end
