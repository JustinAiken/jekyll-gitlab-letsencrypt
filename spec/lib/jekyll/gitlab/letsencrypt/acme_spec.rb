require 'spec_helper'

describe Jekyll::Gitlab::Letsencrypt::Acme do
  let(:acme)     { described_class.new }

  let(:email)    { 'example@example.com' }
  let(:domain)   { 'example.com' }
  let(:endpoint) { 'https://acme-v01.api.letsencrypt.org/' }

  before do
    allow(Jekyll::Gitlab::Letsencrypt::Configuration).to receive(:email).and_return    email
    allow(Jekyll::Gitlab::Letsencrypt::Configuration).to receive(:domain).and_return   domain
    allow(Jekyll::Gitlab::Letsencrypt::Configuration).to receive(:endpoint).and_return endpoint
  end

  describe '#register!' do
    it 'logs, registers, and returns itself' do
      VCR.use_cassette 'authorization' do
        expect(Jekyll.logger).to receive(:info).with 'Registering example@example.com to https://acme-v01.api.letsencrypt.org/...'
        expect(acme.register!).to eq acme
      end
    end
  end

  describe '#authorized?' do
    pending
  end

  describe '#challenge' do
    pending
  end

  describe '#client' do
    it 'returns a new ACME client' do
      expect(acme.client.endpoint).to eq endpoint
    end
  end
end
