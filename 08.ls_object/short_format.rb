# frozen_string_literal: true

class ShortFormat
  COLS = 3 # 列数
  SPAN = 2 # 列間のスペース数

  def initialize(items)
    @items = items
  end

  def create_text
    return if @items.empty?

    row_size = (@items.size.to_f / COLS).ceil
    table = create_table(row_size)
    table.map { |row| row.join.strip }.join("\n")
  end

  private

  def create_table(row_size)
    horizontal_table = @items.map(&:name).each_slice(row_size).to_a
    aligned_horizontal_table = align_table(horizontal_table)
    aligned_horizontal_table.map { |item| item.values_at(0...row_size) }.transpose
  end

  def align_table(table)
    table.map do |row|
      width = row.map { |item_name| digit_size(item_name) }.max + SPAN
      row.map { |item_name| digit_ljust(width, item_name) }
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
