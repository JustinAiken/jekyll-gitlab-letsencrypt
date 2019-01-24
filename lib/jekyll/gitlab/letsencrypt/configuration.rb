require "active_support/core_ext/object/blank"

module Jekyll
  module Gitlab
    module Letsencrypt
      class Configuration

        DEFAULT_FILENAME        = 'letsencrypt_challenge.html'
        DEFAULT_ENDPOINT        = 'https://acme-v01.api.letsencrypt.org/'
        DEFAULT_BRANCH          = 'master'
        DEFAULT_LAYOUT          = 'null'
        DEFAULT_INITIAL_DELAY   = 120
        DEFAULT_DELAY_TIME      = 15
        DEFAULT_SCHEME          = 'http'
        DEFAULT_GITLAB_URL      = 'https://gitlab.com'
        DEFAULT_COMMIT_MESSAGE  = "Automated Let's Encrypt renewal"

        REQUIRED_KEYS = %w{gitlab_repo email domain}

        class << self

          def valid?
            REQUIRED_KEYS.all? { |key| jekyll_config.has_key? key } && personal_access_token
          end

          def endpoint
            jekyll_config['endpoint'] || DEFAULT_ENDPOINT
          end

          def gitlab_url
            jekyll_config['gitlab_url'] || DEFAULT_GITLAB_URL
          end

          def gitlab_repo
            jekyll_config['gitlab_repo']
          end

          def base_path
            jekyll_config['base_path'] || ''
          end

          def pretty_url?
            !!jekyll_config['pretty_url']
          end

          def append_str
            jekyll_config['append_str'] || ''
          end

          def layout
            jekyll_config['layout'] || DEFAULT_LAYOUT
          end

          def personal_access_token
            jekyll_config['personal_access_token'].presence || ENV['GITLAB_TOKEN'].presence
          end

          def email
            jekyll_config['email']
          end

          def domain
            jekyll_config['domain']
          end

          def branch
            jekyll_config['branch'] || DEFAULT_BRANCH
          end

          def filename
            jekyll_config['filename'] || DEFAULT_FILENAME
          end

          def initial_delay
            jekyll_config['initial_delay'] || DEFAULT_INITIAL_DELAY
          end

          def delay_time
            jekyll_config['delay_time'] || DEFAULT_DELAY_TIME
          end

          def scheme
            jekyll_config['scheme'] || DEFAULT_SCHEME
          end

          def reset!
            @jekyll_config = nil
          end

          def jekyll_config
            @jekyll_config ||= (Jekyll.configuration({})['gitlab-letsencrypt'] || {})
          end

          def commit_message
            jekyll_config['commit_message'] || DEFAULT_COMMIT_MESSAGE
          end
        end
      end
    end
  end
end
