# frozen_string_literal: true

require 'spec_helper'

describe 'nfs_exports::export' do
  let(:title) { '/namevar' }
  let(:params) do
    {}
  end

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile }
    end
  end
  context 'export /data to testvm' do
    let(:title) { '/data' }
    let(:params) { { 'clients' => [{ 'client' => 'testvm' }]}}
    it do
      is_expected.to contain_file_line('update export entry for /data in /etc/exports').with(
        {'line' => '/data testvm', 'path' => '/etc/exports' })
    end
  end
  context 'export /data to testvm testvm2 with defaults and options' do
    let(:title) { '/data' }
    let(:params) { { 'clients' => [
      { 'client' => '-', 'options' => 'ro' },
      { 'client' => 'testvm'},
      { 'client' => 'testvm2', 'options' => 'rw'},
      ]}}
    it do
      is_expected.to contain_file_line('update export entry for /data in /etc/exports').with(
        {'line' => '/data -ro testvm testvm2(rw)', 'path' => '/etc/exports' })
    end
  end
end
