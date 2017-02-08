require 'spec_helper'

describe Jekyll::Commands::Gitlab::Letsencrypt do
  describe '#init_with_program' do
    let(:prog)    { double 'prog' }
    let(:command) { double Jekyll::Command }

    it 'calls out to the class' do
      expect(prog).to receive(:command).with(:letsencrypt).and_yield command
      expect(command).to receive(:description)
      expect(command).to receive(:action).and_yield nil, nil
      expect(Jekyll::Gitlab::Letsencrypt::Process).to receive :process!

      described_class.init_with_program prog
    end
  end
end
