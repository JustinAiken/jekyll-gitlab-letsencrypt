require 'faraday'

module Jekyll
  module Gitlab
    module Letsencrypt
      class GitlabClient

        attr_accessor :content

        delegate :filename, :personal_access_token, :gitlab_url, :gitlab_repo, :branch, :domain, to: Configuration

        def commit!(content)
          @content = content
          create_branch! unless branch_exists?
          commit_file!
        end

        def update_certificate!(certificate, key)
          Jekyll.logger.info "Updating domain #{domain} pages setting with new certificates.."
          response = connection.put do |req|
            req.url "projects/#{repo_id}/pages/domains/#{domain}"
            req.body = {
              certificate:  certificate,
              key:          key
            }.to_json
          end
          response.success?
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
          enc_filename = filename.gsub "/", "%2f"
          connection.run_request(request_method_for_commit, nil, nil, nil) do |req|
            req.url        "projects/#{repo_id}/repository/files/#{enc_filename}"
            req.body = {
              commit_message: "Automated Let's Encrypt renewal",
              branch_name:    branch,
              content:        content
            }.to_json
          end
          Jekyll.logger.info "Done Commiting! Check #{gitlab_url}/#{gitlab_repo}/commits/#{branch}"
        end

      private

        def branch_exists?
          response = connection.get "projects/#{repo_id}/repository/branches"
          JSON.parse(response.body).any? { |json| json['name'] == branch }
        end

        def request_method_for_commit
          enc_filename = filename.gsub "/", "%2f"
          response = connection.get "projects/#{repo_id}/repository/files/#{enc_filename}?ref=#{branch}"
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
          @connection ||= Faraday.new(url: "#{gitlab_url}/api/v4/") do |faraday|
            faraday.adapter Faraday.default_adapter
            faraday.headers['Content-Type']  = 'application/json'
            faraday.headers['PRIVATE-TOKEN'] = personal_access_token
          end
        end
      end
    end
  end
end
