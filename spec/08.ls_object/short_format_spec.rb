# frozen_string_literal: true

require_relative '../../08.ls_object/short_format'

RSpec.describe ShortFormat do
  describe '#create_text' do
    item = Item.new(File.expand_path('../sample/sample.txt', __FILE__))
    short_format = ShortFormat.new([item, item, item, item, item])

    example '所定の列数で整列した表を返す' do
      expect(short_format.create_text).to eq <<~TEXT.chomp
        sample.txt  sample.txt  sample.txt
        sample.txt  sample.txt
      TEXT
    end
  end
end
