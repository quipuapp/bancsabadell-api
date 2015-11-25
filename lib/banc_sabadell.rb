require 'net/http'
require 'net/https'
require 'json'
require 'banc_sabadell/version'
require 'logger'

module BancSabadell
  API_BASE = 'oauth.bancsabadell.com'
  API_SANDBOX_BASE = 'developers.bancsabadell.com'
  API_VERSION = 'v1.0.0'
  API_THROTTLE_LIMIT = 5 # secs between requests

  @@api_key = nil
  @@api_base = API_BASE
  @@api_version = API_VERSION
  @@api_port = Net::HTTP.https_default_port
  @@logger = Logger.new(STDOUT)

  autoload :Base, 'banc_sabadell/base'
  autoload :Product, 'banc_sabadell/product'
  autoload :CreditCardAccount, 'banc_sabadell/credit_card_account'
  autoload :BankAccount, 'banc_sabadell/bank_account'
  autoload :AccountTransaction, 'banc_sabadell/account_transaction'

  module Operations
    autoload :All, 'banc_sabadell/operations/all'
    autoload :Query, 'banc_sabadell/operations/query'
  end

  module Request
    autoload :Base, 'banc_sabadell/request/base'
    autoload :Connection, 'banc_sabadell/request/connection'
    autoload :Helpers, 'banc_sabadell/request/helpers'
    autoload :Info, 'banc_sabadell/request/info'
    autoload :Validator, 'banc_sabadell/request/validator'
  end

  class BancSabadellError < StandardError; end
  class AuthenticationError < BancSabadellError; end
  class APIError < BancSabadellError; end

  def self.api_key
    @@api_key
  end

  def self.api_key=(api_key)
    @@api_key = api_key
  end

  def self.api_base
    @@api_base
  end

  def self.sandbox!
    @@api_base = API_SANDBOX_BASE
  end

  def self.unsandbox!
    @@api_base = API_BASE
  end

  def self.api_version
    @@api_version
  end

  def self.api_port
    @@api_port
  end

  def self.request(http_method, api_url, data)
    info = Request::Info.new(http_method, api_url, data)
    Request::Base.new(info)
  end

  def self.perform(req)
    req.perform
  end

  def self.obtain_refresh_token_data(client_id, client_secret, refresh_token)
    https = Net::HTTP.new(BancSabadell.api_base, BancSabadell.api_port)
    https.use_ssl = true
    https.verify_mode = OpenSSL::SSL::VERIFY_NONE # TODO: remove it

    https_request = Net::HTTP::Post.new('/AuthServerBS/oauth/token')
    https_request.set_form_data(grant_type: 'refresh_token', refresh_token: refresh_token)
    https_request['Authorization'] = "Basic #{Base64.encode64("#{client_id}:#{client_secret}").delete("\n")}"

    response = https.request(https_request)

    if response.code.to_s[0] == '4'
      raise AuthenticationError.new(begin JSON.parse(response.body)['error_description'] rescue '' end)
    end

    begin
      data = JSON.parse(response.body)
    rescue
      raise APIError
    else
      data
    end
  end

  def self.logger
    @@logger
  end
end
