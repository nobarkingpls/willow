class AvailsController < ApplicationController
  def index
    @shows = Show.all
    @seasons = Season.all
    @movies = Movie.all

    if params[:commit] == "Export xlsx"
      case params[:avail_type]
      when "amazon"
        workbook = generate_amazon_xlsx_workbook
      when "youtube"
        workbook = generate_youtube_xlsx_workbook
      when "roku"
        workbook = generate_roku_xlsx_workbook
      end


      xlsx_data = workbook.read_string

      send_data xlsx_data,
        filename: "avails-#{params[:avail_type]}-#{Time.now.to_i}.xlsx",
        type: "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
        disposition: "attachment"
        nil
    end
  end

  private

  def generate_amazon_xlsx_workbook
    start_date = params[:start_date].presence
    end_date = params[:end_date].presence
    show_id = params[:show_id].presence
    season_id = params[:season_id].presence
    movie_id = params[:movie_id].presence

    episodes = []
    movies = []

    if show_id
      show = Show.find_by(id: show_id)
      episodes = show.seasons.flat_map(&:episodes) if show
    elsif season_id
      season = Season.find_by(id: season_id)
      episodes = season.episodes if season
    elsif movie_id
      movie = Movie.find_by(id: movie_id)
      movies = [ movie ] if movie
    elsif start_date || end_date
      range = date_range(start_date, end_date)
      episodes = Episode.where(start: range)
      movies = Movie.where(start: range)
    end

    workbook = FastExcel.open(constant_memory: true)

    ### Sheet 1: Episodes
    if episodes.any?
      sheet_episodes = workbook.add_worksheet("TV")
      sheet_episodes.append_row([ "Show", "Season", "Episode", "Title", "Start Date", "End Date" ])
      episodes.each do |episode|
        sheet_episodes.append_row([
          episode.season&.show&.title,
          episode.season&.number,
          episode.number,
          episode.title,
          # this here and above '&' is called safe navigation operator here returns nil if not present!!!
          episode.start&.strftime("%Y-%m-%dT%H:%M:%S%z"),
          episode.finish&.strftime("%Y-%m-%dT%H:%M:%S%z")
        ])
      end
    end

    ### Sheet 2: Movies
    if movies.any?
      sheet_movies = workbook.add_worksheet("Movies")
      sheet_movies.append_row([ "Title", "Start Date", "End Date" ])
      movies.each do |movie|
        sheet_movies.append_row([
          movie.title,
          movie.start&.strftime("%Y-%m-%dT%H:%M:%S%z"),
          movie.finish&.strftime("%Y-%m-%dT%H:%M:%S%z")
        ])
      end
    end

    workbook
  end

  def generate_youtube_xlsx_workbook
    start_date = params[:start_date].presence
    end_date = params[:end_date].presence
    show_id = params[:show_id].presence
    season_id = params[:season_id].presence
    movie_id = params[:movie_id].presence

    episodes = []
    movies = []

    if show_id
      show = Show.find_by(id: show_id)
      episodes = show.seasons.flat_map(&:episodes) if show
    elsif season_id
      season = Season.find_by(id: season_id)
      episodes = season.episodes if season
    elsif movie_id
      movie = Movie.find_by(id: movie_id)
      movies = [ movie ] if movie
    elsif start_date || end_date
      range = date_range(start_date, end_date)
      episodes = Episode.where(start: range)
      movies = Movie.where(start: range)
    end

    workbook = FastExcel.open(constant_memory: true)

    ### Sheet 1: Episodes
    if episodes.any?
      sheet_episodes = workbook.add_worksheet("TV")
      sheet_episodes.append_row([ "Show", "Season", "Episode", "Title", "Start Date", "End Date" ])
      episodes.each do |episode|
        sheet_episodes.append_row([
          episode.season&.show&.title,
          episode.season&.number,
          episode.number,
          episode.title,
          episode.start&.strftime("%Y-%m-%dT%H:%M:%S%z"),
          episode.finish&.strftime("%Y-%m-%dT%H:%M:%S%z")
        ])
      end
    end

    ### Sheet 2: Movies
    if movies.any?
      sheet_movies = workbook.add_worksheet("Movies")
      sheet_movies.append_row([ "Title", "Start Date", "End Date" ])
      movies.each do |movie|
        sheet_movies.append_row([
          movie.title,
          movie.start&.strftime("%Y-%m-%dT%H:%M:%S%z"),
          movie.finish&.strftime("%Y-%m-%dT%H:%M:%S%z")
        ])
      end
    end

    workbook
  end

  def generate_roku_xlsx_workbook
    start_date = params[:start_date].presence
    end_date = params[:end_date].presence
    show_id = params[:show_id].presence
    season_id = params[:season_id].presence
    movie_id = params[:movie_id].presence

    episodes = []
    movies = []

    if show_id
      show = Show.find_by(id: show_id)
      episodes = show.seasons.flat_map(&:episodes) if show
    elsif season_id
      season = Season.find_by(id: season_id)
      episodes = season.episodes if season
    elsif movie_id
      movie = Movie.find_by(id: movie_id)
      movies = [ movie ] if movie
    elsif start_date || end_date
      range = date_range(start_date, end_date)
      episodes = Episode.where(start: range)
      movies = Movie.where(start: range)
    end

    workbook = FastExcel.open(constant_memory: true)

    ### Sheet 1: Episodes
    if episodes.any?
      sheet_episodes = workbook.add_worksheet("TV")
      sheet_episodes.append_row([ "Show", "Season", "Episode", "Title", "Start Date", "End Date" ])
      episodes.each do |episode|
        sheet_episodes.append_row([
          episode.season&.show&.title,
          episode.season&.number,
          episode.number,
          episode.title,
          episode.start&.strftime("%Y-%m-%dT%H:%M:%S%z"),
          episode.finish&.strftime("%Y-%m-%dT%H:%M:%S%z")
        ])
      end
    end

    ### Sheet 2: Movies
    if movies.any?
      sheet_movies = workbook.add_worksheet("Movies")
      sheet_movies.append_row([ "Title", "Start Date", "End Date" ])
      movies.each do |movie|
        sheet_movies.append_row([
          movie.title,
          movie.start&.strftime("%Y-%m-%dT%H:%M:%S%z"),
          movie.finish&.strftime("%Y-%m-%dT%H:%M:%S%z")
        ])
      end
    end

    workbook
  end

  def date_range(start_date, end_date)
    start_date = Date.parse(start_date) rescue nil
    end_date = Date.parse(end_date) rescue nil

    if start_date && end_date
      start_date..end_date
    elsif start_date
      start_date..
    elsif end_date
      ..end_date
    else
      nil
    end
  end
end
