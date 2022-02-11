# frozen_string_literal: true

require 'etc'
require 'date'

module LsLong

  def show_long_data(items)
    lstats = items.map { |v| { item: v, lstat: File.lstat(v) } }
    long_data = generate_long_data(lstats)
    table = align_long_table(long_data[:table])
    puts "total #{long_data[:blocks]}"
    print_long_table(table)
  end

  def generate_long_data(lstats)
    table = []
    blocks = 0
    lstats.map do |v|
      ftype = v[:lstat].ftype
      mode_bits = v[:lstat].mode.to_s(2)[-12, 12] # 後ろの12文字
      ftype_mode = parse_ftype(ftype) + parse_mode(mode_bits)
      nlink = v[:lstat].nlink
      user = Etc.getpwuid(v[:lstat].uid).name
      group = Etc.getgrgid(v[:lstat].gid).name
      size = v[:lstat].size
      mtime = parse_mtime(v[:lstat].mtime)
      item = add_symlink(v[:item])
      table.push([ftype_mode, nlink, user, group, size, mtime, item])
      blocks += (v[:lstat].size / 1024).truncate
    end
    { table: table, blocks: blocks }
  end

  def align_long_table(table)
    cols_data = table.transpose
    aligned_cols_data = cols_data[0..-2].map do |col_data| # 最終列は整列不要でマルチバイト文字の場合もあるため外す
      width = col_data.map { |v| v.is_a?(Integer) ? v.to_s.size : v.size }.max
      col_data.map { |v| v.is_a?(Integer) ? v.to_s.rjust(width) : v.ljust(width) }
    end
    aligned_cols_data.concat([cols_data.last]).transpose
  end

  def print_long_table(table)
    table.each do |row_data|
      row_data.map { |v| print "#{v} " }
      print "\n"
    end
  end

  def parse_ftype(ftype)
    types = {
      'file' => '-',
      'directory' => 'd',
      'characterSpecial' => 'c',
      'blockSpecial' => 'b',
      'fifo ' => 'p',
      'link' => 'l',
      'socket' => 's',
      'unknown' => '?'
    }
    types[ftype]
  end

  def parse_mode(mode_bits)
    symbols = [%w[- r], %w[- w]]
    mode_bits_array = mode_bits.chars.map(&:to_i)
    special_bits = mode_bits_array[0..2]
    read_write_bits = mode_bits_array[3..11].each_slice(3).map { |v| v[0..1] }
    execute_bits = mode_bits_array[3..11].each_slice(3).map(&:last)
    read_write_symbols = read_write_bits.map do |bits|
      bits.map.with_index { |v, i| symbols[i][v.to_i] }.join
    end
    execute_symbols = parse_execute_mode(special_bits, execute_bits)
    [read_write_symbols, execute_symbols].transpose.join
  end

  def parse_execute_mode(special_bits, execute_bits)
    owner = %w[- x S s]
    other = %w[- x T t]
    symbols = [owner, owner, other]
    shifted_special_digit = special_bits.map { |b| b << 1 }
    merged_digit = [execute_bits, shifted_special_digit].transpose.map { |v| v.inject(:+) }
    merged_digit.map.with_index { |v, i| symbols[i][v] }
  end

  def parse_mtime(mtime)
    border = Date.today.prev_month(6).to_time
    if mtime > border
      mtime.strftime('%b %e %H:%M')
    else
      mtime.strftime('%b %e  %Y')
    end
  end

  def add_symlink(item)
    File.symlink?(item) ? "#{item} -> #{File.readlink(item)}" : item
  end
end
