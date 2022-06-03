# frozen_string_literal: true

class LongFormat
  def initialize(items)
    @items = items
  end

  def create_text
    total = "total #{sum_blocks(@items)}"
    table = create_table(@items)
    details = table.map { |row| row.join(' ') }
    [total, *details].join("\n")
  end

  private

  def sum_blocks(items)
    items.map(&:blocks).sum
  end

  def create_table(items)
    stats = items.map do |item|
      [item.ftype_mode, item.nlink, item.user, item.group, item.size, format_mtime(item.mtime), format_name(item.name, item.path)]
    end
    columns = stats.transpose
    aligned_columns_without_last = columns[0...-1].map do |column_values| # 最終列(ファイル/ディレクトリ名)は整列不要でマルチバイト文字の場合もあるため外す
      width = column_values.map { |value| value.to_s.size }.max
      column_values.map { |value| value.is_a?(Integer) ? value.to_s.rjust(width) : value.ljust(width) }
    end
    aligned_columns_without_last.concat([columns.last]).compact.transpose
  end

  def format_mtime(mtime)
    border = Date.today.prev_month(6).to_time
    if mtime > border
      mtime.strftime('%b %e %H:%M')
    else
      mtime.strftime('%b %e  %Y')
    end
  end

  def format_name(name, path)
    File.symlink?(path) ? "#{name} -> #{File.readlink(path)}" : name
  end
end
