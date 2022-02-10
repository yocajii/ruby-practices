module LsShort

  COLS = 3 # 列数
  SPAN = 2 # 列間のスペース数

  def generate_table(items)
    rows = (items.size.to_f / COLS).ceil
    horizontal_table = items.each_slice(rows).to_a
    aligned_horizontal_table = horizontal_table.map do |col_data|
      width = col_data.map { |item| digit_size(item) }.max + SPAN
      col_data.map { |item| digit_ljust(width, item) }
    end
    aligned_horizontal_table.map { |item| item.values_at(0...rows) }.transpose
  end

  def print_table(table)
    table.each do |row_data|
      row_data.compact.each { |item| print item }
      print "\n"
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
