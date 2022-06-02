# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength

require_relative '../../08.ls_object/ls'

RSpec.describe Ls do
  describe '#show' do
    example 'オプションなしの時はshort形式で返す' do
      ls = Ls.new(File.expand_path('../sample', __FILE__), { a: false, l: false, r: false })
      expect(ls.show).to eq <<~TEXT.chomp
        123      sample.txt  サンプル
        123.txt  sbit        サンプル.txt
        sample   slink
      TEXT
    end

    example 'aオプションありの時は隠しファイルも返す' do
      ls = Ls.new(File.expand_path('../sample', __FILE__), { a: true, l: false, r: false })
      expect(ls.show).to eq <<~TEXT.chomp
        .        .hidden      sbit
        ..       .hidden.txt  slink
        123      sample       サンプル
        123.txt  sample.txt   サンプル.txt
      TEXT
    end

    example 'rオプションありの時はファイル名の降順でソートする' do
      ls = Ls.new(File.expand_path('../sample', __FILE__), { a: false, l: false, r: true })
      expect(ls.show).to eq <<~TEXT.chomp
        サンプル.txt  sbit        123.txt
        サンプル      sample.txt  123
        slink         sample
      TEXT
    end

    example 'lオプションありの時はlong形式で返す' do
      ls = Ls.new(File.expand_path('../sample', __FILE__), { a: false, l: true, r: false })
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

    example 'オプションなしでアイテム数0の時は何も出力しない' do
      ls = Ls.new(File.expand_path('../sample/123', __FILE__), { a: false, l: false, r: false })
      expect(ls.show).to eq nil
    end

    example 'lオプションありでアイテム数0の時はtotalのみ返す' do
      ls = Ls.new(File.expand_path('../sample/123', __FILE__), { a: false, l: true, r: false })
      expect(ls.show).to eq <<~TEXT
        total 0
      TEXT
    end
  end
end

# rubocop:enable Metrics/BlockLength
