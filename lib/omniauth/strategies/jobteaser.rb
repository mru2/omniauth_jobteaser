require 'omniauth/strategies/oauth2'

module OmniAuth
  module Strategies
    class Jobteaser < OmniAuth::Strategies::OAuth2

      option :name, 'jobteaser'

      option :client_options, site: 'https://www.jobteaser.com'

      def raw_info
        binding.pry
      end

    end
  end
end
