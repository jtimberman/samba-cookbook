require 'spec_helper'

describe 'Default recipe on Ubuntu 16.04' do
  let(:runner) { ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04', step_into: ['samba_server']) }

  it 'converges successfully' do
    expect { :chef_run }.to_not raise_error
  end
end

describe 'samba::client' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '16.04').converge(described_recipe)
  end

  it 'converges successfully' do
    expect { chef_run }.to_not raise_error
  end
end
