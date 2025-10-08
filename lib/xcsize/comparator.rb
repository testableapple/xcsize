# frozen_string_literal: true

module Xcsize
  class Comparator
    def initialize(old_linkmap_path:, new_linkmap_path:, threshold:)
      @old_linkmap_path = old_linkmap_path
      @new_linkmap_path = new_linkmap_path
      @threshold = threshold
    end

    def compare
      Reader.linkmaps(
        old_linkmap_path: @old_linkmap_path,
        new_linkmap_path: @new_linkmap_path,
        threshold: @threshold
      )
    end
  end
end
