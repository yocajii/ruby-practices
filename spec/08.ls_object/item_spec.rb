# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength

require_relative '../../08.ls_object/item'

RSpec.describe Item do
  before do
    @item = Item.new(File.expand_path('../sample/123', __FILE__))
  end

  describe '#blocks' do
    example 'ブロック数を返す' do
      expect(@item.blocks).to eq 4
    end
  end

  describe '#ftype_mode' do
    example 'ファイルタイプとパーミッションを返す' do
      expect(@item.ftype_mode).to eq 'drwxr-xr-x'
    end
  end

  describe '#nlink' do
    example 'ハードリンクの数を返す' do
      expect(@item.nlink).to eq 2
    end
  end

  describe '#user' do
    example 'オーナーのユーザー名を返す' do
      expect(@item.user).to eq 'yocajii'
    end
  end

  describe '#group' do
    example 'オーナーのグループ名を返す' do
      expect(@item.group).to eq 'yocajii'
    end
  end

  describe '#size' do
    example 'ファイルサイズのバイト数を返す' do
      expect(@item.size).to eq 4096
    end
  end

  describe '#mtime' do
    example '最終更新時刻を返す' do
      expect(@item.mtime).to eq Time.local(2022, 6, 2, 12, 00)
    end
  end

  describe '#digit_size' do
    example 'ファイル名の文字数を半角に換算して返す' do
      item = Item.new(File.expand_path('../sample/サンプル.txt', __FILE__))
      expect(item.digit_size).to eq 12
    end
  end
end

# rubocop:enable Metrics/BlockLength
