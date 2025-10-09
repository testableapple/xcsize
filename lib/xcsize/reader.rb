# frozen_string_literal: true

module Xcsize
  class Reader
    IGNORED_PATTERNS = [
      /libclang_rt/i,
      /libsystem/i,
      /libobjc/i,
      /libswift/i,
      /linker synthesized/i
    ]

    def self.linkmap(linkmap_path:, threshold:)
      threshold ||= 0
      data = parse_linkmap(linkmap_path)
      filtered_keys = data.keys.reject { |f| IGNORED_PATTERNS.any? { |r| f =~ r } }
      total = total_size(data)

      col1_width = filtered_keys.map(&:length).max || 40
      col1_width = [col1_width, 15].max

      puts "\n📊 Binary Size Report\n\n"
      border(col1_width + 15)
      puts "Total size: #{format_size(total)}"
      border(col1_width + 15)
      puts "\n"
      puts format("%-#{col1_width}s %12s", 'Object File', 'Size')
      border(col1_width + 15)

      details = {}
      filtered_keys
        .select { |file| data[file] >= threshold }
        .sort_by { |file| data[file] }
        .reverse_each do |file|
          printf "%-#{col1_width}s %12d\n", file, data[file]
          details[file] = data[file]
        end

      { total_size: total, details: details }
    end

    def self.linkmaps(old_linkmap_path:, new_linkmap_path:, threshold:)
      threshold ||= 0
      old_data = parse_linkmap(old_linkmap_path)
      new_data = parse_linkmap(new_linkmap_path)

      all_keys = (old_data.keys + new_data.keys).uniq
      filtered_keys = all_keys.reject { |f| IGNORED_PATTERNS.any? { |r| f =~ r } }

      old_total = total_size(old_data)
      new_total = total_size(new_data)
      diff_total = new_total - old_total

      col1_width = filtered_keys.map(&:length).max || 40
      col1_width = [col1_width, 15].max

      puts "\n📊 Binary Size Comparison\n\n"
      border(col1_width + 50)
      puts "Old binary size:  #{format_size(old_total)}"
      puts "New binary size: #{format_size(new_total)}"
      puts "Difference:       #{'+' if diff_total.positive?}#{format_size(diff_total)}"
      border(col1_width + 50)
      puts "\n"
      puts format("%-#{col1_width}s %12s %12s %12s", 'Object File', 'Old Size', 'New Size', 'Diff')
      border(col1_width + 50)

      details = {}
      filtered_keys
        .select { |file| ((new_data[file] || 0) - (old_data[file] || 0)).abs >= threshold }
        .sort_by { |file| ((new_data[file] || 0) - (old_data[file] || 0)).abs }
        .reverse_each do |file|
          o = old_data[file] || 0
          n = new_data[file] || 0
          diff = n - o
          diff_str = if diff.zero?
                       '+0'
                     else
                       (diff.positive? ? "+#{diff}" : diff.to_s)
                     end
          printf "%-#{col1_width}s %12d %12d %12s\n", file, o, n, diff_str
          details[file] = diff_str
        end

      {
        old_total_size: old_total,
        new_total_size: new_total,
        difference: diff_total,
        details: details
      }
    end

    def self.parse_linkmap(path)
      raise "Linkmap file not found: #{path}" unless File.exist?(path)

      files = {}
      in_objects = false
      in_symbols = false
      id_to_path = {}

      File.foreach(path, chomp: true) do |line|
        if line.start_with?('# Object files:')
          in_objects = true
          next
        elsif line.start_with?('# Sections:')
          in_objects = false
        elsif line.start_with?('# Symbols:')
          in_symbols = true
          next
        end

        if in_objects && line =~ /\[\s*(\d+)\]\s*(.*)/
          id = Regexp.last_match(1)
          full_path = Regexp.last_match(2)
          short_name = File.basename(full_path)
          id_to_path[id] = short_name
          files[short_name] = 0
        end

        if in_symbols && line =~ /^0x[0-9A-Fa-f]+\s+0x?([0-9A-Fa-f]+)\s+\[\s*(\d+)\]/
          size = Regexp.last_match(1).to_i(16)
          id = Regexp.last_match(2)
          files[id_to_path[id]] ||= 0
          files[id_to_path[id]] += size
        end
      end

      files
    end

    def self.total_size(files)
      files.values.compact.sum
    end

    def self.format_size(bytes)
      kb = bytes / 1024.0
      mb = kb / 1024.0
      "#{bytes} bytes (#{kb.round(2)} KB / #{mb.round(2)} MB)"
    end

    def self.border(width)
      puts '-' * width
    end
  end
end
