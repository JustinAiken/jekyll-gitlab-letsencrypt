require 'spec_helper'

describe Jekyll::Gitlab::Letsencrypt::GitlabClient do
  let(:gitlab_commiter) { described_class.new  }
  let(:content)         { '<CONTENT>' }

  let(:filename)              { 'test_file.html' }
  let(:personal_access_token) { 'SECRET_TOKEN' }
  let(:gitlab_repo)           { 'gitlab_user/gitlab_repo' }
  let(:branch)                { 'test_branch' }

  before do
    allow(Jekyll::Gitlab::Letsencrypt::Configuration).to receive(:filename).and_return              filename
    allow(Jekyll::Gitlab::Letsencrypt::Configuration).to receive(:personal_access_token).and_return personal_access_token
    allow(Jekyll::Gitlab::Letsencrypt::Configuration).to receive(:gitlab_repo).and_return           gitlab_repo
    allow(Jekyll::Gitlab::Letsencrypt::Configuration).to receive(:branch).and_return                branch
  end

  it 'creates the branch and shit' do
    VCR.use_cassette 'gitlab_commit' do
      expect(Jekyll.logger).to receive(:info).with "Creating branch test_branch.."
      expect(Jekyll.logger).to receive(:info).with "Commiting challenge file as test_file.html"
      expect(Jekyll.logger).to receive(:info).with "Done Commiting! Check https://gitlab.com/gitlab_user/gitlab_repo/commits/test_branch"
      gitlab_commiter.commit! content
    end
  end
end
