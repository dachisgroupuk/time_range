require 'time'
require 'active_support'
require 'active_support/all'
require_relative 'time_range/iso8601'

class TimeRange
  VERSION = '0.1'
  USAGE = <<-END
    Usage:
    You must supply start.
    You may supply end.
    Start must be before end.
    Start must be in the past.
    Start and finish must be times.
  END

  @@default_range = 30 * 24 * 3600

  attr_accessor :start, :finish
  
  def initialize(start, finish=Time.now)
    raise ArgumentError.new(USAGE) if start > finish
    return nil unless start && finish
    @start = start
    @finish = finish
  end
  
  def iterate(step = 1.year, &block)
    current = @start
    collect = [];
    begin
      collect.push(block_given? ? yield(current) : current)
    end while (current += step) <= @finish
    return collect
  end
  
  def each_subrange(step = 1.year, &block)
    iterate(step) do |current_start|
      current_finish = [current_start + step, @finish].min
      yield(::TimeRange.new(current_start, current_finish)) if current_start.to_i < current_finish.to_i
    end
  end
  
  def ==(other)
    return true if self.equal?(other)
    start == other.start && finish == other.finish
  end
  
  def eql?(other)
    return false unless other.instance_of?(self.class)
    return true if self.equal?(other)
    start == other.start && finish == other.finish
  end
  
  def -(interval)
    ::TimeRange.new(@start - interval, @finish - interval)
  end
  
  def +(interval)
    ::TimeRange.new(@start + interval, @finish + interval)
  end
  
  def hash
    start.hash ^ finish.hash
  end
  
  def to_iso8601
    Iso8601.new(self)
  end
  
  def length
    return finish - start
  end
  
  def strip(granularity)
    ::TimeRange.new(ceil_time(@start, granularity), floor_time(@finish, granularity))
  end
  
  def floor(granularity)
    ::TimeRange.new(floor_time(@start, granularity), floor_time(@finish, granularity))
  end
  
  def ceil(granularity)
    ::TimeRange.new(ceil_time(@start, granularity), ceil_time(@finish, granularity))
  end
  
  def to_s
    to_iso8601.to_s
  end

  def self.default
    range_finish = Time.now.utc
    range_start = (range_finish - @@default_range).beginning_of_day
    new(range_start, range_finish)
  end

  def self.default=(default_range)
    @@default_range = default_range
  end
  
  def self.today
    time = Time.now.utc
    day_for(time)
  end

  def self.day_for(timestamp)
    new(timestamp.beginning_of_day, timestamp.end_of_day)
  end

  def self.near(timestamp, granularity=1.hour)
    new(floor_time(timestamp, granularity), floor_time(timestamp + granularity, granularity) -1 )
  end
  
  
  private
  
  # See http://stackoverflow.com/questions/449271/how-to-round-a-time-down-to-the-nearest-15-minutes-in-ruby/449322#449322
  def floor_time(time, seconds=60)
    self.class.floor_time(time, seconds)
  end
  def self.floor_time(time, seconds = 60)
    Time.at((time.to_f / seconds).floor * seconds)
  end
  
  def ceil_time(time, seconds = 60)
    self.class.ceil_time(time, seconds)
  end
  def self.ceil_time(time, seconds = 60)
    Time.at((time.to_f / seconds).ceil * seconds)
  end
end
