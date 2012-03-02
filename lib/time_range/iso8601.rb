class TimeRange
  class Iso8601
    def initialize(time_range)
      raise ArgumentError.new("A TimeRange argument is needed") unless time_range.is_a?(TimeRange)
      @time_range = time_range
    end
    
    def start
      @time_range.start.utc.iso8601
    end
    
    def finish
      @time_range.finish.utc.iso8601
    end
    
    def to_s
      "#{start}~#{finish}"
    end
  end
end
