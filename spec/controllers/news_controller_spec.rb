# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NewsController, type: :controller do
  describe 'GET #new' do
    subject(:send_request) { get :show, params: { id: news, lang: language } }

    let(:news) { create(:news) }
    let(:language) { FFaker::Locale.code }

    before do
      allow(News).to receive(:find).with(news.id.to_s).and_return(news)
      allow(news).to receive(:translated).with(language).and_return(news)
      send_request
    end

    it 'translates news into provided languade' do
      expect(news).to have_received(:translated).with(language).once
    end
  end
end
