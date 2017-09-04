require 'spec_helper'

describe Jekyll::Gitlab::Letsencrypt::Process do
  let(:process) { described_class.new client }
  let(:client)  { Jekyll::Gitlab::Letsencrypt::Acme.new }

  describe '#process!' do
    before do
      allow(process).to receive :commit_to_gitlab!
      allow(process).to receive :wait_until_challenge_is_present
      allow(process).to receive :request_verification!
      allow(process).to receive :await_verification_confirmation
      allow(process).to receive :display_certificate
    end

    after { process.process! }

    context 'when already authorized' do
      before { allow(client).to receive(:authorized?).and_return true }

      it 'bails early' do
        expect(Jekyll).to receive_message_chain(:logger, :abort_with).with "Client is already authorized."
      end
    end

    context "when not authorized" do
      before { expect(client).to receive(:authorized?).and_return false }

      pending
    end
  end

  describe '#challenge_url' do
    subject         { process.send :challenge_url }
    let(:challenge) { double 'challenge', filename: 'foo' }
    before          { allow(client).to receive(:challenge).and_return challenge }

    context "by default" do
      it { should match /http\:/ }
    end

    context 'if protocol is overriden' do
      before { allow(Jekyll::Gitlab::Letsencrypt::Configuration).to receive(:protocol).and_return 'https' }
      it     { should match /https\:/ }
    end
  end
end
