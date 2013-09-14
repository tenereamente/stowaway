class SpaceController < ApplicationController
  def index
    @spaces = StorageSpace.all
  end
  def new
    @resource = StorageSpace.new
  end
end
