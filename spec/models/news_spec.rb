# frozen_string_literal: true

require 'rails_helper'

RSpec.describe News, type: :model do
  describe '#translated' do
    let(:news) { create(:news) }
    let(:language) { FFaker::Locale.code }
    let(:yandex_service_double) { instance_double(YandexTranslate) }

    before(mocked: true) do
      allow(YandexTranslate).to receive(:new).and_return(yandex_service_double)
      allow(yandex_service_double).to receive(:run).and_return(nil)
    end

    context 'when YandexTranslate service responses is successful' do
      it 'returns hash with :id, :title, :text and :created_at keys' do
        translated_news = news.translated(language)
        %i[id title text created_at].each do |response_key|
          expect(translated_news.key?(response_key)).to be_truthy
        end
      end
    end

    context 'when YandexTranslate service responses is unsuccessful', mocked: true do
      it 'returns nil' do
        expect(news.translated(language)).to be nil
      end
    end

    context 'when we have translation in Redis' do
      let(:redis_key) do
        Base64.encode64({ id: news.id, updated_at: news.updated_at, custom_string: language }.to_s)
      end
      let(:previous_translation) { FFaker::Lorem.sentence }

      before { $redis.set(redis_key, previous_translation) } # rubocop:disable Style/GlobalVars

      it 'returns saved value' do
        expect(news.translated(language)).to eq previous_translation
      end

      it "doesn't run YandexTranslate service", mocked: true do
        news.translated(language)
        expect(yandex_service_double).not_to have_received(:run)
      end
    end
  end
end
