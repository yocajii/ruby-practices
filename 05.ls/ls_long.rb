# frozen_string_literal: true

require 'etc'
require 'date'

module LsLong
  BLOCK_SIZE = 1024 # 1ブロックのサイズ
  MODE_BITS_LENGTH = 12 # File::Stat#modeのうちファイルタイプ+パーミッションを示す文字数
  SP_BITS_RANGE = (0..2).freeze # MODE_BITS_LENGTHのうちスペシャルビットを表す範囲
  RWX_BITS_RANGE = (3..11).freeze # MODE_BITS_LENGTHのうちパーミッションを表す範囲

  def show_long_data(items)
    lstats = items.map { |v| { item: v, lstat: File.lstat(v) } }
    long_data = generate_long_data(lstats)
    puts "total #{long_data[:blocks]}"
    return if items.size.zero?

    table = align_long_table(long_data[:table])
    table.each { |row| puts row.join(' ') }
  end

  def generate_long_data(lstats)
    blocks = 0
    table = lstats.map do |v|
      ftype = v[:lstat].ftype
      mode_bits = v[:lstat].mode.to_s(2).match(/.{#{MODE_BITS_LENGTH}}$/).to_s
      ftype_mode = parse_ftype(ftype) + parse_mode(mode_bits)
      nlink = v[:lstat].nlink
      user = Etc.getpwuid(v[:lstat].uid).name
      group = Etc.getgrgid(v[:lstat].gid).name
      size = v[:lstat].size
      mtime = parse_mtime(v[:lstat].mtime)
      item = add_symlink(v[:item])
      blocks += (v[:lstat].size / BLOCK_SIZE).truncate
      [ftype_mode, nlink, user, group, size, mtime, item]
    end
    { table: table, blocks: blocks }
  end

  def align_long_table(table)
    cols_data = table.transpose
    aligned_cols_data = cols_data[0...-1].map do |col_data| # 最終列は整列不要でマルチバイト文字の場合もあるため外す
      width = col_data.map { |v| v.is_a?(Integer) ? v.to_s.size : v.size }.max
      col_data.map { |v| v.is_a?(Integer) ? v.to_s.rjust(width) : v.ljust(width) }
    end
    aligned_cols_data.concat([cols_data.last]).transpose || []
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
    special_bits = mode_bits_array[SP_BITS_RANGE]
    rwx_bits = mode_bits_array[RWX_BITS_RANGE].each_slice(3)
    read_write_bits = rwx_bits.map { |v| v[0..1] }
    execute_bits = rwx_bits.map(&:last)
    read_write_symbols = read_write_bits.map do |bits|
      bits.map.with_index { |b, i| symbols[i][b.to_i] }.join
    end
    execute_symbols = parse_execute_mode(special_bits, execute_bits)
    [read_write_symbols, execute_symbols].transpose.join
  end

  def parse_execute_mode(special_bits, execute_bits)
    owner = %w[- x S s]
    other = %w[- x T t]
    symbols = [owner, owner, other]
    shifted_special_digits = special_bits.map { |b| b << 1 }
    merged_digits = [execute_bits, shifted_special_digits].transpose.map { |d| d.inject(:+) }
    merged_digits.map.with_index { |d, i| symbols[i][d] }
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
