require 'active_support'
require 'active_support/core_ext/module/delegation'

require 'jekyll/gitlab/letsencrypt/version'
require 'jekyll/gitlab/letsencrypt/configuration'
require 'jekyll/gitlab/letsencrypt/acme'
require 'jekyll/gitlab/letsencrypt/process'
require 'jekyll/gitlab/letsencrypt/gitlab_client'

module Jekyll
  module Gitlab
    module Letsencrypt
    end
  end
end

require 'jekyll/commands/gitlab/letsencrypt'
