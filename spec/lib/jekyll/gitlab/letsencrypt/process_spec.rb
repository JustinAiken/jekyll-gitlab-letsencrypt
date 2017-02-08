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
end
