class NewsController < ApplicationController
  def index
    news = News.all
    render json: NewsBlueprint.render(news)
  end

  def show
    news = News.find(params[:id])
    render json: NewsBlueprint.render(news, view: :extended)
  end
end
