# frozen_string_literal: true

require 'spec_helper'

describe 'nfs_exports' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      it { is_expected.to compile }
      it { is_expected.to contain_exec('exportfs -ra').with({'path' => ['/sbin','/usr/sbin'], 'refreshonly' => true}) }
    end
  end
  context 'change some options' do
    let(:params) { {
      'exportfs' => 'exportfs -ar',
      'exportfs_path' => ['/sbin','/opt/sbin'],
    }}
    it { is_expected.to contain_exec('exportfs -ar').with({'path' => ['/sbin','/opt/sbin'], 'refreshonly' => true}) }
  end
  context 'specify a single export' do
    let(:params) { { 'exports' => {
      '/data' => [
        { 'client' => '-', 'options' => 'ro' },
        { 'client' => 'testvm'},
        { 'client' => 'testvm2', 'options' => 'rw'},
      ]}}
    }
    it do
      is_expected.to contain_nfs_exports__export('/data').with(
        { 'clients' => [
            { 'client' => '-', 'options' => 'ro' },
            { 'client' => 'testvm'},
            { 'client' => 'testvm2', 'options' => 'rw'},
          ]
        }
      )
    end
  end
  context 'specify a multiple exports' do
    let(:params) { { 'exports' => {
      '/data' => [
        { 'client' => '-', 'options' => 'ro' },
        { 'client' => 'testvm'},
        { 'client' => 'testvm2', 'options' => 'rw'},
      ],
      '/data2' => [ { 'client' => 'client1' }, { 'client' => 'client2' }]}}
    }
    it do
      is_expected.to contain_nfs_exports__export('/data').with(
        { 'clients' => [
            { 'client' => '-', 'options' => 'ro' },
            { 'client' => 'testvm'},
            { 'client' => 'testvm2', 'options' => 'rw'},
          ]
        }
      )
      is_expected.to contain_nfs_exports__export('/data2').with(
        { 'clients' => [ { 'client' => 'client1' }, { 'client' => 'client2' }]}
      )
    end
  end
end
