# frozen_string_literal: true

module Xcsize
  class Profiler
    def initialize(linkmap_path:, threshold:)
      @linkmap_path = linkmap_path
      @threshold = threshold
    end

    def profile
      Reader.linkmap(
        linkmap_path: @linkmap_path,
        threshold: @threshold
      )
    end
  end
end
