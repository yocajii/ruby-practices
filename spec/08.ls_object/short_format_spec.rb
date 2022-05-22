# frozen_string_literal: true

require_relative '../../08.ls_object/short_format'

RSpec.describe ShortFormat do
  describe '#text' do
    Dir.chdir "#{__dir__}/sample"
    item = Item.new('sample.txt')
    long_format = ShortFormat.new([item, item, item, item, item])

    example '所定の列数で整列した表を返す' do
      expect(long_format.text).to eq <<~TEXT.chomp
        sample.txt  sample.txt  sample.txt
        sample.txt  sample.txt
      TEXT
    end
  end
end
