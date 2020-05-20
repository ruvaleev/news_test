# frozen_string_literal: true

class NewsController < ApplicationController
  def index
    news = News.all
    render json: NewsBlueprint.render(news)
  end

  def show
    news = News.find(params[:id])
    translated_news = news.translated(params[:lang])
    render json: { regular: NewsBlueprint.render(news, view: :extended),
                   translated: NewsBlueprint.render(translated_news, view: :extended) }
  end
end
