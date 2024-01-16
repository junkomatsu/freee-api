# frozen_string_literal: true

module Freee
  module Api
    class Quotations
      # 見積書API用PATH
      PATH = '/iv/quotations'
      PATH.freeze

      # A new instance of HTTP Client.
      def initialize
        @client = Faraday.new(url: Parameter::SITE) do |faraday|
          faraday.request :json
          faraday.response :json, content_type: /\bjson$/
          faraday.adapter Faraday.default_adapter
        end
      end

      # 見積書の作成
      # https://developer.freee.co.jp/reference/iv/reference#operations-tag-Quotations
      # @param access_token [String] アクセストークン
      # @param params [Hash] 新規作成用の見積書パラメータ
      # @return [Hash] POSTレスポンスの結果
      def create_quotation(access_token, params)
        @client.authorization :Bearer, access_token
        response = @client.post do |req|
          req.url PATH
          req.body = params.to_json
        end
        case response.status
        when 401
          raise 'Unauthorized'
        end
        response
      end
    end
  end
end
