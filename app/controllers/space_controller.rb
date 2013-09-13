class SpaceController < ApplicationController
  def index
    @spaces = StorageSpace.all
  end
end
