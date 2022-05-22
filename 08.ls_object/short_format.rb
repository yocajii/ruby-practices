# frozen_string_literal: true

class ShortFormat
  COLS = 3 # 列数
  SPAN = 2 # 列間のスペース数

  def initialize(items)
    @items = items
  end

  def text
    rows = (@items.size.to_f / COLS).ceil
    table = create_table(rows)
    table.map(&:join).join("\n")
  end

  private

  def create_table(rows)
    horizontal_table = slice_items(rows)
    aligned_horizontal_table = align_table(horizontal_table)
    aligned_horizontal_table.map { |item| item.values_at(0...rows) }.transpose
  end

  def slice_items(rows)
    @items.map(&:name).each_slice(rows).to_a
  end

  def align_table(table)
    table.map do |column|
      width = column.map { |item_name| digit_size(item_name) }.max + SPAN
      column.map { |item_name| digit_ljust(width, item_name) }
    end
  end

  def digit_size(text)
    text.each_char.map { |c| c.bytesize == 1 ? 1 : 2 }.inject(:+)
  end

  def digit_ljust(width, text)
    padding = ' ' * (width - digit_size(text))
    text + padding
  end
end
