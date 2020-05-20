# frozen_string_literal: true

class YandexTranslate
  API_KEY = MedsolutionsTest::Application.credentials[:yandex_api_key]
  HOST = 'https://translate.yandex.net/api/v1.5/tr.json/translate'

  def run(language, text)
    return fake_response if Rails.env.test?

    url = URI.parse(URI.escape("#{HOST}?lang=#{language}&key=#{API_KEY}&text=#{text}")) # rubocop:disable Lint/UriEscapeUnescape
    response = post_request(url)
    serialized_response(response) if successful?(response)
  end

  private

  def post_request(url, use_ssl = true)
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = use_ssl
    request = Net::HTTP::Post.new(url)
    response = http.request(request)
    JSON.parse(CGI.unescape(response.read_body))
  end

  def serialized_response(response)
    response['text'] = response['text'].first.split('~~~')
    response
  end

  def successful?(response)
    successful_codes.include?(response['code'])
  end

  def successful_codes
    [200]
  end

  def fake_response
    { 'code' => 200, 'lang' => 'ru-en', 'text' => ["How are you?~~~I'm fine"] }
  end
end
