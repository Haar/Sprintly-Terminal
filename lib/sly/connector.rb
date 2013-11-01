require 'curb'
require 'json'

class Sly::Connector

  attr :api

  def self.connect_with_defaults
    return self.new(default_details)
  end

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

  def product_overview(id)
    request = authenticated_request(@api_url+"/products/#{id}.json")
    perform_and_capture_response(request)
  end

  def items_for_product(id, status = "backlog")
    request = authenticated_request(@api_url+"/products/#{id}/items.json?status=#{status}")
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

  private

  def self.default_details
    details_file = File.join(ENV["HOME"], ".slyrc")
    if File.exists?(details_file)
      details = File.read(details_file)
      email, api_key = details.split(":").map(&:strip)
      return { email: email, api_key: api_key }
    else
      raise "Could not locate installation file at #{details_file}"
    end
  end

end
