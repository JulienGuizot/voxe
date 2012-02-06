class Web::ApplicationController < ApplicationController
  
  def index
    @options = {}
  end
  
  private
    def set_election
      @only_published_candidacies = true
      @election = Election.first conditions: {namespace: params[:namespace]}
      # returns 404 if election does not exist
      return not_found unless @election
    end
  
end
