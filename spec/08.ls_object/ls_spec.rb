# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength

require_relative '../../08.ls_object/ls'

RSpec.describe Ls do
  describe '#show' do
    example 'オプションなしの時はshort形式で返す' do
      ls = Ls.new(File.expand_path('../sample', __FILE__), { a: false, l: false, r: false })
      expect(ls.show).to eq <<~TEXT.chomp
        123      sample      サンプル
        123.txt  sample.txt  サンプル.txt
        new      sbit
        old      slink
      TEXT
    end

    example 'aオプションありの時は隠しファイルも返す' do
      ls = Ls.new(File.expand_path('../sample', __FILE__), { a: true, l: false, r: false })
      expect(ls.show).to eq <<~TEXT.chomp
        .        .hidden.txt  sbit
        ..       new          slink
        123      old          サンプル
        123.txt  sample       サンプル.txt
        .hidden  sample.txt
      TEXT
    end

    example 'rオプションありの時はファイル名の降順でソートする' do
      ls = Ls.new(File.expand_path('../sample', __FILE__), { a: false, l: false, r: true })
      expect(ls.show).to eq <<~TEXT.chomp
        サンプル.txt  sample.txt  123.txt
        サンプル      sample      123
        slink         old
        sbit          new
      TEXT
    end

    example 'lオプションありの時はlong形式で返す' do
      ls = Ls.new(File.expand_path('../sample', __FILE__), { a: false, l: true, r: false })
      expect(ls.show).to eq <<~TEXT.chomp
        total 20
        drwxr-xr-x 2 yocajii yocajii 4096 Jun  2 12:00 123
        -rw-r--r-- 1 yocajii yocajii    0 May 22 09:37 123.txt
        drwxr-xr-x 2 yocajii yocajii 4096 Jun  2 18:14 new
        drwxr-xr-x 2 yocajii yocajii 4096 Jun  2 18:06 old
        drwxr-xr-x 2 yocajii yocajii 4096 Jun  2 18:12 sample
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
      expect(ls.show).to eq 'total 0'
    end

    context 'lオプションの最終更新日時' do
      example '半年以上前の場合は月日年の書式で返す' do
        ls = Ls.new(File.expand_path('../sample/old', __FILE__), { a: false, l: true, r: false })
        expect(ls.show).to eq <<~TEXT.chomp
          total 0
          -rw-r--r-- 1 yocajii yocajii 0 Nov 11  2021 old.txt
        TEXT
      end

      example '半年以内の場合は月日時刻の書式で返す' do
        ls = Ls.new(File.expand_path('../sample/new', __FILE__), { a: false, l: true, r: false })
        expect(ls.show).to eq <<~TEXT.chomp
          total 0
          -rw-r--r-- 1 yocajii yocajii 0 Jun  2 18:14 new.txt
        TEXT
      end
    end
  end
end

# rubocop:enable Metrics/BlockLength
