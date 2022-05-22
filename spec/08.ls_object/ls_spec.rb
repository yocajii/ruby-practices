# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength

require_relative '../../08.ls_object/ls'

RSpec.describe Ls do
  describe '#show' do
    example 'オプションなしの時' do
      ls = Ls.new("#{__dir__}/sample", { a: false, l: false, r: false })
      expect(ls.show).to eq <<~TEXT.chomp
        123      sample.txt  サンプル
        123.txt  sbit        サンプル.txt
        sample   slink
      TEXT
    end

    example 'aオプションありの時は隠しファイルも返す' do
      ls = Ls.new("#{__dir__}/sample", { a: true, l: false, r: false })
      expect(ls.show).to eq <<~TEXT.chomp
        .        .hidden      sbit
        ..       .hidden.txt  slink
        123      sample       サンプル
        123.txt  sample.txt   サンプル.txt
      TEXT
    end

    example 'lオプションありの時はlong形式で返す' do
      ls = Ls.new("#{__dir__}/sample", { a: false, l: true, r: false })
      expect(ls.show).to eq <<~TEXT.chomp
        total 12
        drwxr-xr-x 2 yocajii yocajii 4096 May 22 14:48 123
        -rw-r--r-- 1 yocajii yocajii    0 May 22 09:37 123.txt
        drwxr-xr-x 2 yocajii yocajii 4096 May 22 09:57 sample
        -rw-r--r-- 1 yocajii yocajii    0 May 22 09:37 sample.txt
        -rwxrwxrwt 1 yocajii yocajii    0 May 22 10:03 sbit
        lrwxrwxrwx 1 yocajii yocajii    7 May 22 10:02 slink -> 123.txt
        drwxr-xr-x 2 yocajii yocajii 4096 May 22 09:58 サンプル
        -rw-r--r-- 1 yocajii yocajii    0 May 22 09:37 サンプル.txt
      TEXT
    end

    example 'rオプションありの時はファイル名の降順でソートする' do
      ls = Ls.new("#{__dir__}/sample", { a: false, l: false, r: true })
      expect(ls.show).to eq <<~TEXT.chomp
        サンプル.txt  sbit        123.txt
        サンプル      sample.txt  123
        slink         sample
      TEXT
    end
  end
end

# rubocop:enable Metrics/BlockLength
