require 'net/http'
require 'net/https'
require 'json'
require 'banc_sabadell/version'
require 'logger'

module BancSabadell
  API_BASE = 'developers.bancsabadell.com'
  API_VERSION = 'v1.0.0'

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

  def self.api_version
    @@api_version
  end

  def self.api_port
    @@api_port
  end

  def self.request(http_method, api_url, data)
    info = Request::Info.new(http_method, api_url, data)
    Request::Base.new(info).perform
  end

  def self.logger
    @@logger
  end
end
