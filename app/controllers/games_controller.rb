class GamesController < ApplicationController
  def new
    source = ("A".."Z").to_a
  @letters = []
  10.times { @letters << source[rand(source.size)].to_s }
  end

  def score
    raise
  end
end
