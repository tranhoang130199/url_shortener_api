class UrlsController < ApplicationController
  # POST /encode
  def encode
    original_url = params[:original_url]

    if original_url.blank?
      return render json: { error: 'Original URL is required' }, status: :bad_request
    end

    url = Url.new(original_url: original_url)

    if url.valid?
      url = Url.find_or_create_by(original_url: original_url)

      render json: { short_url: "#{request.base_url}/#{url.short_code}" }, status: :ok
    else
      render json: { error: 'Invalid URL format' }, status: :unprocessable_entity
    end
  end

  # POST /decode
  def decode
    short_code_or_url = params[:short_url]

    if short_code_or_url.blank?
      return render json: { error: 'Short URL is required' }, status: :bad_request
    end

    # Extract short_code if a full URL is provided
    short_code = extract_and_validate_short_code(short_code_or_url)

    if short_code.blank?
      return render json: { error: 'Invalid short URL' }, status: :unprocessable_entity
    end

    # Find URL by short_code
    url = Url.find_by(short_code: short_code)
    if url
      render json: { original_url: url.original_url }, status: :ok
    else
      render json: { error: 'Short code not found' }, status: :not_found
    end
  end

  private

  def extract_and_validate_short_code(short_code_or_url)
    uri = URI.parse(short_code_or_url) rescue nil
    if uri&.host.present?
      allowed_base = URI.parse(ENV['BASE_URL'] || '')
      return nil unless uri.host == allowed_base.host && uri.port == allowed_base.port

      uri.path.split('/').last
    else
      short_code_or_url
    end
  end
end
