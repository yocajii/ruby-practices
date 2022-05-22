# frozen_string_literal: true

class LongFormat
  def initialize(items)
    @items = items
  end

  def text
    text = ''
    text += "total #{sum_blocks}\n"
    return if @items.size.zero?

    table = create_table
    text += table.map { |row| row.join(' ') }.join("\n")
    text
  end

  private

  def sum_blocks
    @items.map(&:blocks).sum
  end

  def create_table
    stats = @items.map { |item| [item.ftype_mode, item.nlink, item.user, item.group, item.size, item.mtime, item.long_name] }
    columns = stats.transpose
    aligned_columns = columns[0...-1].map do |column| # 最終列は整列不要でマルチバイト文字の場合もあるため外す
      width = column.map { |v| v.is_a?(Integer) ? v.to_s.size : v.size }.max
      column.map { |v| v.is_a?(Integer) ? v.to_s.rjust(width) : v.ljust(width) }
    end
    aligned_columns.concat([columns.last]).transpose || []
  end
end
