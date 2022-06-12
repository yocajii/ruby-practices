# frozen_string_literal: true

require_relative '../../08.ls_object/long_format'

RSpec.describe LongFormat do
  describe '#create_text' do
    example 'アイテム数1以上の時は詳細情報を返す' do
      item = Item.new(File.expand_path('../sample/sample.txt', __FILE__))
      long_format = LongFormat.new([item])
      expect(long_format.create_text).to eq <<~TEXT.chomp
        total 0
        -rw-r--r-- 1 yocajii yocajii 0 May 22 09:37 sample.txt
      TEXT
    end
  end
end
