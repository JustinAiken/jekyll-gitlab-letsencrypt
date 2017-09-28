require 'spec_helper'

describe Jekyll::Gitlab::Letsencrypt::Configuration do

  before { allow(Jekyll).to receive(:configuration).with({}).and_return config }

  let(:config)        { {'gitlab-letsencrypt' => plugin_config} }
  let(:plugin_config) { {} }

  describe '#valid?' do
    subject { described_class }

    context "when missing the config section" do
      let(:plugin_config) { nil }
      it { should_not be_valid }
    end

    context "when missing required keys" do
      let(:plugin_config) { {'gitlab_repo' => "yay"} }
      it { should_not be_valid }
    end

    context "when all required keys are present" do
      let(:plugin_config) do
        {
          'personal_access_token' => "secret",
          'gitlab_repo'           => 'yay',
          'email'                 => 'foo@foo.com',
          'domain'                => 'foo.com'
        }
      end

      it { should be_valid }
    end
  end

  describe '#personal_access_token' do
    subject { described_class.personal_access_token }

    context 'in the env var' do
      before { stub_const 'ENV', {'GITLAB_TOKEN' => 'from_the_env'} }
      it     { should eq 'from_the_env'}
    end

    context "from the jeykll config" do
      let(:plugin_config) { {'personal_access_token' => 'from_config'} }
      it                  { should eq 'from_config'}
    end
  end

  describe '#endpoint' do
    subject { described_class.endpoint }
    context "with no endpoint" do
      it { should eq 'https://acme-v01.api.letsencrypt.org/'}
    end

    context "with an endpoint" do
      let(:plugin_config) { {'endpoint' => "https://foo/"} }
      it { should eq 'https://foo/'}
    end
  end
end
