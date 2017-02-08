require 'faraday'

module Jekyll
  module Gitlab
    module Letsencrypt
      class Commiter

        attr_accessor :content

        delegate :filename, :personal_access_token, :gitlab_repo, :branch, to: Configuration

        def initialize(content)
          @content = content
        end

        def commit!
          create_branch! unless branch_exists?
          commit_file!
        end

        def create_branch!
          Jekyll.logger.info "Creating branch #{branch}.."
          connection.post do |req|
            req.url  "projects/#{repo_id}/repository/branches"
            req.body = {
              branch_name:  branch,
              ref:          'master'
            }.to_json
          end
        end

        def commit_file!
          Jekyll.logger.info "Commiting challenge file as #{filename}"
          connection.run_request(request_method, nil, nil, nil) do |req|
            req.url        "projects/#{repo_id}/repository/files"
            req.body = {
              file_path:      filename,
              commit_message: "Automated Let's Encrypt renewal",
              branch_name:    branch,
              content:        content
            }.to_json
          end
          Jekyll.logger.info "Done Commiting! Check https://gitlab.com/#{gitlab_repo}/commits/#{branch}"
        end

      private

        def branch_exists?
          response = connection.get "projects/#{repo_id}/repository/branches"
          JSON.parse(response.body).any? { |json| json['name'] == branch }
        end

        def request_method
          response = connection.get "projects/#{repo_id}/repository/files?ref=#{branch}&file_path=#{filename}"
          response.status == 404 ? :post : :put
        end

        def repo_id
          @repo_id ||= begin
            repo_name = gitlab_repo.gsub "/", "%2f"
            response  = connection.get "projects/#{repo_name}"
            JSON.parse(response.body)['id']
          end
        end

        def connection
          @connection ||= Faraday.new(url: 'https://gitlab.com/api/v3/') do |faraday|
            faraday.adapter Faraday.default_adapter
            faraday.headers['Content-Type']  = 'application/json'
            faraday.headers['PRIVATE-TOKEN'] = personal_access_token
          end
        end
      end
    end
  end
end
