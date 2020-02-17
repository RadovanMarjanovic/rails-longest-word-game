require 'open-uri'

class GamesController < ApplicationController
  def new
    @letters = Array.new(10) { ('A'..'Z').to_a.sample }
    @new = @letters
  end

  def score
    @solution = params[:solution].downcase
    @grid = params[:grid].split('')

    if includes?(@solution, @grid)
      if english?(@solution)
        @answer = "Congratulations! #{@solution.capitalize} is a valid English word! "
      else
        @answer = "Sorry but #{@solution.upcase} does not seem to be an English word"
      end
    else
      @answer = "Sorry but #{@solution} can't be built out of #{@grid * ", " }."
    end
  end

  private

  def includes?(solution, grid)
    solution.chars.all? { |letter| solution.count(letter) <= grid.count(letter) }
  end

  def english?(word)
    response = open("https://wagon-dictionary.herokuapp.com/#{word}")
    json = JSON.parse(response.read)
    json['found']
  end
end
