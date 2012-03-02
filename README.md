TimeRange
=========
A gem to take the pain out of dealing with time ranges.

### Usage
This is how you could create a new time range starting 2 days ago and ending at the present time:

    TimeRange.new(2.days.ago)

This is how you could create range between two specific points in time:

    TimeRange.new(Time.parse("2011-11-11 11:11:11"), Time.parse("2012-12-12 12:12:12"))

### Iterating
The class provides two methods to iterate over a time range. Both accept a time step as a parameter.

The `iterate` method yields a Time instance:

    range = TimeRange.new(Time.parse("2011-11-11 20:00:00"), Time.parse("2011-11-11 22:00:00"))
    range.iterate(45.minutes) do |current|
      puts current
    end
    # will print
    # 2011-11-11 20:00:00 +0000
    # 2011-11-11 20:45:00 +0000
    # 2011-11-11 21:30:00 +0000

The `each_subrange` method yields a TimeRange instance:

    range = TimeRange.new(Time.parse("2011-11-11 20:00:00"), Time.parse("2011-11-11 22:00:00"))
    range.each_subrange(45.minutes) do |current|
      puts current
    end
    # will print
    # 2011-11-11T20:00:00Z~2011-11-11T20:45:00Z
    # 2011-11-11T20:45:00Z~2011-11-11T21:30:00Z
    # 2011-11-11T21:30:00Z~2011-11-11T22:00:00Z

### Rounding
The class provides methods to round the range. All the methods accept a rounding granularity.

Some examples:

    range = TimeRange.new(Time.parse("2011-11-11 11:11:11"), Time.parse("2012-12-12 12:34:56"))
    
    range.floor(30.minutes) # will return 2011-11-11T11:00:00Z~2012-12-12T12:30:00Z
    
    range.ceil(30.minutes) # will return 2011-11-11T11:30:00Z~2012-12-12T13:00:00Z
    
    range.strip(30.minutes) # will return 2011-11-11T11:30:00Z~2012-12-12T12:30:00Z

### ISO 8601
Time ranges can be converted to a format compatible with the ISO 8601 specification.

The method `to_iso8601` returns an instance of `TimeRange::Iso8601`. This class has got `start` and `finish` attributes (which are strings, as opposed to the same attributes being `Time` instances in the `TimeRange` class), but no methods.
