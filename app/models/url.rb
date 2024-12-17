class Url < ApplicationRecord
  validates :original_url, presence: true, format: { with: URI::DEFAULT_PARSER.make_regexp, message: 'Invalid URL format' }

  before_create :generate_short_code

  private

  # Generate a unique short_code
  def generate_short_code
    self.short_code ||= loop do
      code = SecureRandom.alphanumeric(6)
      break code unless Url.exists?(short_code: code)
    end
  end
end
