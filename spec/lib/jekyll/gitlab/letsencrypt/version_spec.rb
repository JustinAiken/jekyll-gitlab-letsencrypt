require 'spec_helper'

describe Jekyll::Gitlab::Letsencrypt do
  it 'has a version number' do
    expect(Jekyll::Gitlab::Letsencrypt::VERSION).not_to be nil
  end
end
