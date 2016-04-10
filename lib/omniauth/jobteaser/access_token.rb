module Omniauth
  module Jobteaser
    class AccessToken

      def self.load(dump)
        # Symbolize keys
        dump = dump.inject ({}) { |acc, (k,v)| acc[k.to_sym] = v; acc }

        client = ::OAuth2::Client.new(
          dump[:client_id],
          dump[:client_secret],
          dump[:client_options]
        )
        client.site = dump[:site]

        ::OAuth2::AccessToken.from_hash(
          client,
          dump[:access_token].dup
        )
      end

      def self.dump(token)
        {
          client_id: token.client.id,
          client_secret: token.client.secret,
          client_options: token.client.options,
          site: token.client.site,
          access_token: token.to_hash.dup
        }
      end

    end
  end
end
