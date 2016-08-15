require 'open-uri'
require 'json'

class PagesController < ApplicationController
  def game
    # @start_time = Time.now
    session[:start] = Time.now
    @grid = generate_grid(9).join(" ")
  end

  def score
    end_time = Time.now
    @answer = params[:answer]
    @grid = params[:grid]
    @start_time = Time.parse params[:start_time]
    @time_taken = @start_time - end_time
    # time_taken = session[:start] - end_time
    @translation = get_translation(@answer)
    byebug
    if included?(@answer, @grid)
      @Included_answer == "Well done you found a word"
    else
      @Included_answer == "Sorry your word does not exist"
    end
    # score_and_message(@answer, translation, @grid, time_taken)
  end

  def result
  end

  private

  def generate_grid(grid_size)
    Array.new(grid_size) { ('A'..'Z').to_a[rand(26)] }
  end

  def included?(guess, grid)
    the_grid = @grid.clone
    guess.chars.each do |letter|
      the_grid.delete_at(the_grid.index(letter)) if the_grid.include?(letter)
    end
    if grid.size == guess.size + the_grid.size
      true
    else
      false
    end
  end

  def compute_score(answer, time_taken)
    (time_taken > 60.0) ? 0 : @answer.size * (1.0 - time_taken / 60.0)
  end

  def run_game(answer, grid, start_time, end_time)
    result = { time: end_time - start_time }
    result[:translation] = get_translation(@answer)
    result[:score], result[:message] = score_and_message(
      @answer, result[:translation], @grid, result[:time])
    result
  end

  def get_translation(word)
    response = open("http://api.wordreference.com/0.8/80143/json/enfr/#{word.downcase}")
    json = JSON.parse(response.read.to_s)
    if json['term0']
      json['term0']['PrincipalTranslations']['0']['FirstTranslation']['term']
    else
      nil
    end
  end
end


