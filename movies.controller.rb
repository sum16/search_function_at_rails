class MoviesController < ApplicationController
  def index
    @movies = Movie.all
  end

  def search_movie
    @search_movies = Movie.search(movie_search_params) #モデルにsearchメソッドを記述
    render :index
    # redirect_toにすると@search_moviesに値を保持できない
  end

  def movie_search_params
    params.fetch(:search, {}).permit(:keyword, :is_showing)
  end
end

# fetchメソッド
# params.fetch(:search, {})は、params[:search]が空の場合{}をparams[:search]が空でない場合、params[:search]を返す