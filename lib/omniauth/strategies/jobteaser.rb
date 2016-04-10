require 'omniauth/strategies/oauth2'
require 'omniauth/jobteaser/access_token'

module OmniAuth
  module Strategies
    class Jobteaser < OmniAuth::Strategies::OAuth2

      option :name, 'jobteaser'

      option :client_options, site: 'https://www.jobteaser.com'

      info do
        user_info
      end

      extra do
        {
          token: Omniauth::Jobteaser::AccessToken.dump(access_token)
        }
      end

      def user_info
        @_user_info ||= JSON.parse(access_token.get('/fr/api/users/me').body)
      end

    end
  end
end
