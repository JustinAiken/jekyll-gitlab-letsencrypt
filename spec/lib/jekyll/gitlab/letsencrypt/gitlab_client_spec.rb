require 'spec_helper'

describe Jekyll::Gitlab::Letsencrypt::GitlabClient do
  let(:gitlab_client) { described_class.new  }
  let(:content)       { '<CONTENT>' }

  let(:filename)              { 'test_file.html' }
  let(:personal_access_token) { 'SECRET_TOKEN' }
  let(:gitlab_url)            { 'https://gitlab.com'}
  let(:gitlab_repo)           { 'gitlab_user/gitlab_repo' }
  let(:branch)                { 'test_branch' }
  let(:domain)                { 'example.com' }

  before do
    allow(Jekyll::Gitlab::Letsencrypt::Configuration).to receive(:filename).and_return              filename
    allow(Jekyll::Gitlab::Letsencrypt::Configuration).to receive(:personal_access_token).and_return personal_access_token
    allow(Jekyll::Gitlab::Letsencrypt::Configuration).to receive(:gitlab_repo).and_return           gitlab_repo
    allow(Jekyll::Gitlab::Letsencrypt::Configuration).to receive(:branch).and_return                branch
    allow(Jekyll::Gitlab::Letsencrypt::Configuration).to receive(:domain).and_return                domain
  end

  describe "#commit!" do
    it 'creates the branch and shit' do
      VCR.use_cassette 'gitlab_commit' do
        expect(Jekyll.logger).to receive(:info).with "Creating branch test_branch.."
        expect(Jekyll.logger).to receive(:info).with "Commiting challenge file as test_file.html"
        expect(Jekyll.logger).to receive(:info).with "Done Commiting! Check https://gitlab.com/gitlab_user/gitlab_repo/commits/test_branch"
        gitlab_client.commit! content
      end
    end
  end

  describe "#update_certificate!" do
    let(:mock_connection) { double Faraday::Connection, put: response }

    before do
      expect(Jekyll.logger).to receive(:info).with "Updating domain example.com pages setting with new certificates.."
      allow(gitlab_client).to receive(:connection).and_return mock_connection
    end

    context "successful" do
      let(:response) { double Faraday::Response, success?: true }

      it "returns true" do
        expect(gitlab_client.update_certificate! :foo, :bar).to eq true
      end
    end

    context "unsuccessful" do
      let(:response) { double Faraday::Response, success?: false }

      it "returns false" do
        expect(gitlab_client.update_certificate! :foo, :bar).to eq false
      end
    end
  end
end
