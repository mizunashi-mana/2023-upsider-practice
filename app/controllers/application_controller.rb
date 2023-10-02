class ApplicationController < ActionController::API
  include SessionActions
  include UserAuthorityActions
end
