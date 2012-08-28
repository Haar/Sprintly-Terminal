require 'net/http'
require 'uri'
require 'curb'
require 'json'

class SprintlyConnector

  attr :api

  def initialize(user_details = {}, api_url = "https://sprint.ly/api")
    @api_url = api_url
    @user_details = user_details
  end

  def authenticate!
    request = authenticated_request("https://sprint.ly/api/products.json")
    request.perform
    JSON(request.body_str)
  end

  def products
    request = authenticated_request(@api_url+"/products.json")
    perform_and_capture_response(request)
  end

  private

  def authenticated_request(url)
    request = Curl::Easy.new(url)
    request.http_auth_types = :basic
    request.username = @user_details[:email]
    request.password = @user_details[:api_key]
    request
  end

  def perform_and_capture_response(request)
    request.perform
    JSON(request.body_str)
  end

end
