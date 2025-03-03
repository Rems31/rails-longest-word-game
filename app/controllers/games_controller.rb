require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = Array.new(10) { ('A'..'Z').to_a.sample }.join(' ')
  end

  def score
    attempt = params[:word]
    grid = params[:letters]

    if included?(attempt.upcase, grid)
      if english_word?(attempt)
        # score = compute_score(attempt, time_taken)
        @sentence = "Congratulations! #{attempt} is a valid English word!"
      else
        @sentence = "Sorry but #{attempt} does not to be a valid <english word..."
      end
    else
      @sentence = "Sorry but #{attempt} can't be built out of #{grid}"
    end
  end

  private

  def english_word?(attempt)
    url = "https://dictionary.lewagon.com/#{attempt}"
    response = URI.open(url).read
    json = JSON.parse(response)
    json['found']
  end

  def included?(attempt, grid)
    attempt.chars.all? { |letter| attempt.count(letter) <= grid.count(letter) }
  end
end
