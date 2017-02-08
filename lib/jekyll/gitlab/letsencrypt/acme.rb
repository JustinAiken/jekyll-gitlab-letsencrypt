require 'openssl'
require 'acme-client'

module Jekyll
  module Gitlab
    module Letsencrypt
      class Acme

        delegate :email, :endpoint, :domain, to: Configuration

        attr_accessor :registration

        def register!
          Jekyll.logger.info "Registering #{email} to #{endpoint}..."
          @registration = client.register contact: "mailto:#{email}"
          @registration.agree_terms
          self
        end

        def authorized?
          authorization.status == 'valid'
        end

        def challenge
          @challenge ||= authorization.http01
        end

        def client
          @client ||= begin
            private_key = OpenSSL::PKey::RSA.new(4096)
            ::Acme::Client.new private_key: private_key, endpoint: endpoint, connection_options: { request: { open_timeout: 5, timeout: 5 } }
          end
        end

      private

        def authorization
          @authorization ||= client.authorize(domain: domain)
        end
      end
    end
  end
end
