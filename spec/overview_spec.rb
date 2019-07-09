# coding: us-ascii

require_relative 'spec_helper'

describe Net::MACAddress do
  describe '.parse' do
    subject { described_class.parse address }

    context 'with valid address' do
      let!(:address) { '04-A3-43-5F-43-23' }
      
      it { is_expected.to be_an_instance_of(Net::MACAddress) }
    end

    context 'with invalid address' do
      let!(:address) { '04-A3-43-5F-43-23-' }
      
      it { expect { subject }.to raise_error(Net::MACAddress::MalformedDataError) }
    end
  end

  describe '.valid?' do
    subject { described_class.valid? address }

    context 'with valid address' do
      let!(:address) { '04-A3-43-5F-43-23' }
      
      it { is_expected.to eq(true) }
    end

    context 'with invalid address' do
      let!(:address) { '04-A3-43-5F-43-23-' }
      
      it { is_expected.to eq(false) }
    end
  end

  describe '#==' do
    it do
      expect(described_class.parse('04-A3-43-5F-43-23') == described_class.parse('04-A3-43-5F-43-23')).to eq(true)
      expect(described_class.parse('04-A3-43-5F-43-23') == described_class.parse('04-A3-43-5F-43-24')).to eq(false)
    end
  end
end
