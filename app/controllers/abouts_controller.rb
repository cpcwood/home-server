class AboutsController < ApplicationController
  def index
    @about = About.first
  end
end