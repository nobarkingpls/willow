class FeedsController < ApplicationController
  def xml_feed
    @movies = Movie.all
    @shows = Show.includes(seasons: :episodes).all

    respond_to do |format|
      format.xml
    end
  end

  def content_feed
    @movies = Movie.all
    @shows = Show.includes(seasons: :episodes).all

    respond_to do |format|
      format.xml
    end
  end

  def avail_feed
    @movies = Movie.all
    @episodes = Episode.where.not(start: nil, finish: nil)

    respond_to do |format|
      format.xml
    end
  end
end
