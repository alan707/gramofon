class ApplicationController < ActionController::Base
 protect_from_forgery :except => :update	
end
