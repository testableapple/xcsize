# frozen_string_literal: true

module Xcsize
  class CLI
    def self.run
      program :name, 'xcsize'
      program :version, Xcsize::VERSION
      program :description, 'Measure iOS and macOS app and framework sizes using linkmaps'

      command :profile do |c|
        c.syntax = 'xcsize profile [options]'
        c.description = 'Profile iOS and macOS binary using linkmap file'
        c.option('-l', '--linkmap STRING', String, 'Set linkmap path')
        c.option('-m', '--threshold INTEGER', Integer, 'Set minimum size threshold in bytes')
        c.action do |_, options|
          profiler = Xcsize::Profiler.new(
            linkmap_path: options.linkmap,
            threshold: options.threshold
          )
          profiler.profile
        end
      end

      command :compare do |c|
        c.syntax = 'xcsize compare [options]'
        c.description = 'Compare two iOS and macOS binaries using linkmap files'
        c.option('-o', '--old-linkmap STRING', String, 'Set old linkmap path')
        c.option('-n', '--new-linkmap STRING', String, 'Set new linkmap path')
        c.option('-m', '--threshold INTEGER', Integer, 'Set minimum size difference threshold in bytes')
        c.action do |_, options|
          comparator = Xcsize::Comparator.new(
            old_linkmap_path: options.old_linkmap,
            new_linkmap_path: options.new_linkmap,
            threshold: options.threshold
          )
          comparator.compare
        end
      end
    end
  end
end
