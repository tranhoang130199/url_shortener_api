require 'rails_helper'

RSpec.describe Url, type: :model do
  let(:valid_url) { 'https://example.com' }
  let(:invalid_url) { 'invalid-url' }

  describe 'validations' do
    it 'is valid with a valid URL' do
      url = Url.new(original_url: valid_url)
      expect(url).to be_valid
    end

    it 'is not valid with an invalid URL' do
      url = Url.new(original_url: invalid_url)
      expect(url).to_not be_valid
    end

    it 'is not valid without an original_url' do
      url = Url.new(original_url: nil)
      expect(url).to_not be_valid
    end
  end

  describe '#generate_short_code' do
    it 'generates a unique short code' do
      url = Url.create!(original_url: valid_url)
      expect(url.short_code).to be_present
      expect(url.short_code.length).to eq(6)
    end
  end
end
