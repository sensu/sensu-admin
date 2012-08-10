class ChecksController < ApplicationController
  def index
    @checks = Check.all
  end
end
