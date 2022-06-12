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
    horizontal_table = @items.each_slice(row_size)
    aligned_horizontal_table = align_table(horizontal_table)
    aligned_horizontal_table.map { |item| item.values_at(0...row_size) }.transpose
  end

  def align_table(table)
    table.map do |row|
      width = row.map(&:digit_size).max + SPAN
      row.map { |item| digit_ljust(width, item) }
    end
  end

  def digit_ljust(width, item)
    padding = ' ' * (width - item.digit_size)
    item.name + padding
  end
end
