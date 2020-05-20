# frozen_string_literal: true

class News < ApplicationRecord
  TIME_OF_CACHE_STORE = 3600

  def translated(language)
    $redis.get(redis_key(language)) || request_translation(language) # rubocop:disable Style/GlobalVars
  end

  private

  def redis_key(custom_string)
    Base64.encode64({ id: id, updated_at: updated_at, custom_string: custom_string }.to_s)
  end

  def request_translation(language)
    text_for_translate = [title, text].join('~~~')
    response = YandexTranslate.new.run(language, text_for_translate)
    return if response.nil?

    serialized_response =
      { id: id, title: response['text'].first, text: response['text'].last, created_at: created_at }
    $redis.set(redis_key(language), serialized_response, ex: TIME_OF_CACHE_STORE) # rubocop:disable Style/GlobalVars
    serialized_response
  end
end
