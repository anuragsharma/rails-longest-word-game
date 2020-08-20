require 'json'
require 'open-uri'
class GamesController < ApplicationController
  def new
    source = ("A".."Z").to_a
  @letters = []
  10.times { @letters << source[rand(source.size)].to_s }
  end

  def score
    attempt = params[:word]
    grid = params[:grid].split(" ")
    start_time = params[:start_time].to_datetime
    end_time = Time.now
    time_diff = end_time - start_time

    @result = run_game(attempt, grid, start_time, end_time)


  end


    def run_game(attempt, grid, start_time, end_time)
    # TODO: runs the game and return detailed hash of result
    response = JSON.parse(open("https://wagon-dictionary.herokuapp.com/#{attempt}").read)
    result = { score: 0, time: end_time - start_time, message: "not in the grid or not an english word" }



    if response['found'] && present_in_grid(grid, attempt)
      result[:score] = calculate_score(attempt, grid, response, result[:time])
      result[:message] = "The word is valid according to the grid and is an English word"
    end

    if present_in_grid(grid, attempt) && response['found'] == false
        result[:message] = "Sorry the word  #{attempt} valid according to the grid, but is not a valid English word"
    end

    return result
  end

  def calculate_score(attempt, grid, response, time)
    score = (1000 + attempt.length) / time
    return score
  end

  def present_in_grid(grid, attempt)
    attempt.upcase.each_char do |char|
      if grid.include? char
        grid.delete_at(grid.index(char))
      else
        return false
      end
    end
    return true
  end

end


