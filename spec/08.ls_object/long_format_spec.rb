# frozen_string_literal: true

require_relative '../../08.ls_object/long_format'

RSpec.describe LongFormat do
  describe '#text' do
    example 'アイテム数0の時はtotalのみ返す' do
      long_format = LongFormat.new([])
      expect(long_format.text).to eq <<~TEXT
        total 0
      TEXT
    end

    example 'アイテム数1以上の時は詳細情報を返す' do
      Dir.chdir "#{__dir__}/sample"
      item = Item.new('sample.txt')
      long_format = LongFormat.new([item])
      expect(long_format.text).to eq <<~TEXT.chomp
        total 0
        -rw-r--r-- 1 yocajii yocajii 0 May 22 09:37 sample.txt
      TEXT
    end
  end
end
