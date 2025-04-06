# README

todos:
add validation rules for everything
add slim select or something like that and see if it can pass a comma seperated string of values to hash, and also display them back
picture uploads - done for movies
movie xml export - sort of done
zip picture and xml together
check box to zip multiple together

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...

should i need to have seperate start and end dates for each country, here is a useful way of accomplishing an update method for nested attribute which could im guessing run 

if request.format.json?

for example

# RAILS METHOD
# RAILS QUERY 1: find the specific rights record based on the movie id and the rights _name_
# under the hood sql query: SELECT * FROM rights WHERE movie.id = 5 AND rights.name = "CA"
# RAILS QUERY 2: update the specific rights record for the specific movie with the id we found in our first query
# under the hood sql query: UPDATE rights where id = 24 SET start = "" and end = "" 

# SQL METHOD
# SQL QUERY 1: you don't have the id, use the name, try and find it, and then update if you find it in a single query

class RightsController < ApplicationController
  def update_right
    movie = Movie.find(params[:movie_id]) # Find the movie by ID

    # Extract the rights data from the request
    rights_data = params.require(:right).permit(:name, :start, :end)

    # Find the right by name and movie
    right = movie.rights.find_by(name: rights_data[:name])

    if right.nil?
      render json: { error: "Right with name '#{rights_data[:name]}' not found for movie ID #{movie.id}" }, status: :not_found
      return
    end

    # Update the fields (start and end)
    if right.update(rights_data)
      render json: { message: 'Right updated successfully', right: right }, status: :ok
    else
      render json: { errors: right.errors.full_messages }, status: :unprocessable_entity
    end
  end
end