class SearchController < ApplicationController
  def search
    @result = SearchService.call(params[:query], params[:scope])
  end
end
