class AboutsController < ApplicationController
  def show
    @about = About.first
  end
end