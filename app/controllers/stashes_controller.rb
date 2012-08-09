class StashesController < ApplicationController
  def index
    @stashes = Stash.stashes
  end

  def delete_stash
    resp = Stash.delete_stash(params[:key])
    respond_to do |format|
      format.json { render :json => resp.to_s }
    end
  end

  def delete_all_stashes
    resp = Stash.delete_all_stashes
    respond_to do |format|
      format.json { render :json => resp.to_s }
    end
  end
end
