class StashesController < ApplicationController
  def index
    @stashes = Stash.stashes
  end
end
