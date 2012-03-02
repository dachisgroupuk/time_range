require 'spec_helper'

describe TimeRange do
  %w{start finish}.each do |mtd|
    it "should respond to #{mtd}" do
      TimeRange.new(Time.now - 11).should respond_to(mtd.to_sym)
    end
  end

  describe "#initialize" do

    context "start is in the past" do
      it "should create" do
        TimeRange.new(Time.now - 11).should_not be_nil
      end
    end

    context "finish is before the start" do
      it "should create" do
        expect {TimeRange.new(Time.now - 11, Time.now - 15)}.to raise_error ArgumentError
      end
    end

    context "start is in the future" do
      it "should raise" do
        expect {TimeRange.new(Time.now + 11)}.to raise_error ArgumentError
      end
    end

    context "with no parameters" do
      it "should raise" do
        expect {TimeRange.new}.to raise_error ArgumentError
      end
    end

    context "with start as now" do
      it "should create" do
        TimeRange.new(Time.now).should_not be_nil
      end
    end

    context "with start before finish" do
      it "should raise" do
        TimeRange.new(Time.now - 10, Time.now + 10).should_not be_nil
      end
    end

  end
  
  describe "#iterate" do
    context "without step" do
      it "should iterate in years" do
        res = []
        tr = TimeRange.new(Time.now, Time.now + 5.years)
        tr.iterate(){|t| res << t}
        res.count.should == 6
      end
    end
    
    context "with day step" do
      it "should iterate 365 times in a non leap year" do
        res = []
        tr = TimeRange.new(Time.new(2011, 01, 01), Time.new(2011, 12, 31))
        tr.iterate(1.day){|t| res << t}
        res.count.should == 365
      end
    end
  end
  
  describe "#length" do
    it "should return seconds" do
      time = Time.now
      tr = TimeRange.new(time, time + 1.minute)
      tr.length.should == 1.minute.to_i
    end
  end
  
  describe "#-" do
    it "should subtract an interval" do
      time = Time.now
      tr = TimeRange.new(time, time + 1.hour)
      
      interval = 1.day
      sub_tr = tr - interval
      sub_tr.start.should == tr.start - interval
      sub_tr.finish.should == tr.finish - interval
    end
  end
  
  describe "#+" do
    it "should add an interval" do
      time = Time.now
      tr = TimeRange.new(time, time + 1.hour)
      
      interval = 1.day
      sub_tr = tr + interval
      sub_tr.start.should == tr.start + interval
      sub_tr.finish.should == tr.finish + interval
    end
  end
  
  describe "#strip" do
    let(:range) { TimeRange.new(Time.parse("2010-10-10 10:10:10"), Time.parse("2011-11-11 11:11:11")) }
    
    context "with hourly granularity" do
      let(:granularity) { 1.hour }
      
      it "should strip start" do
        range.strip(granularity).start.should == Time.parse("2010-10-10 11:00:00")
      end

      it "should strip finish" do
        range.strip(granularity).finish.should == Time.parse("2011-11-11 11:00:00")
      end
    end
    
    context "with granularity 15 minutes" do
      let(:granularity) { 15.minutes }
      
      it "should strip start" do
        range.strip(granularity).start.should == Time.parse("2010-10-10 10:15:00")
      end

      it "should strip finish" do
        range.strip(granularity).finish.should == Time.parse("2011-11-11 11:00:00")
      end
    end
  end
  
  describe "#floor" do
    let(:range) { TimeRange.new(Time.parse("2010-10-10 10:10:10"), Time.parse("2011-11-11 11:11:11")) }
    
    context "with hourly granularity" do
      let(:granularity) { 1.hour }
      
      it "should round start to floor" do
        range.floor(granularity).start.should == Time.parse("2010-10-10 10:00:00")
      end

      it "should round finish to floor" do
        range.floor(granularity).finish.should == Time.parse("2011-11-11 11:00:00")
      end
    end
  end
  
  describe "#ceil" do
    let(:range) { TimeRange.new(Time.parse("2010-10-10 10:10:10"), Time.parse("2011-11-11 11:11:11")) }
    
    context "with hourly granularity" do
      let(:granularity) { 1.hour }
      
      it "should round start to ceil" do
        range.ceil(granularity).start.should == Time.parse("2010-10-10 11:00:00")
      end

      it "should round finish to ceil" do
        range.ceil(granularity).finish.should == Time.parse("2011-11-11 12:00:00")
      end
    end
  end
  
  describe "#to_s" do
    it "should return a string" do
      start = 2.days.ago
      finish = 1.day.ago
      range = TimeRange.new(start, finish)
      
      range.to_s.should == "#{start.iso8601}~#{finish.iso8601}"
    end
  end
  
  describe "#each_subrange" do
    context "with granularity 1 hour" do
      let(:granularity) { 1.hour }
      let(:subranges) do
        2.times.map do |i|
          start = Time.now + (i * granularity)
          finish = start + granularity
          TimeRange.new(start, finish)
        end
      end
      
      it "should iterate over subranges" do
        range = TimeRange.new(subranges.first.start, subranges.last.finish)
        
        results = []
        range.each_subrange(granularity) do |subrange|
          results << subrange.to_s
        end
        
        results.should == subranges.map{ |s| s.to_s }
      end
      
      context "when not fitting neatly in the range" do
        it "should iterate over subranges" do
          subranges.last.finish -= granularity / 2
          range = TimeRange.new(subranges.first.start, subranges.last.finish)
          
          results = []
          range.each_subrange(granularity) do |subrange|
            results << subrange.to_s
          end

          results.should == subranges.map{ |s| s.to_s }
        end
      end
    end
  end
  
  describe ".today" do
    it "should start at the beginning of today" do
      TimeRange.today.start.should == Time.now.utc.beginning_of_day
      TimeRange.today.finish.should == Time.now.utc.end_of_day
    end
  end

  describe ".near" do
    context "when called with a granularity of 1 minute" do
      before do
        @ts = Time.parse("12:03:25")
      end
      shared_examples_for "a timerange near 12:03" do
        it "should set start to the beginning of the specified minute" do
          TimeRange.near(@ts, 1.minute).start.should == Time.parse("12:03:00")
        end
        it "should set finish to the end of the specified minute" do
          TimeRange.near(@ts, 1.minute).finish.should == Time.parse("12:03:59")
        end
      end
      it_should_behave_like "a timerange near 12:03"
      context "when the passed time is at beginning of the minute" do
        before do
          @ts = Time.parse("12:03:00")
        end
        it_should_behave_like "a timerange near 12:03"
      end
      context "when the passed time ias at the end of the minute" do
        before do
          @ts = Time.parse("12:03:59")
        end
        it_should_behave_like "a timerange near 12:03"
      end
    end

  end
  
  describe "#to_iso8601" do
    before do
      @start = 3.hours.ago
      @finish = 2.hours.ago
    end
    subject { TimeRange.new(@start, @finish).to_iso8601 }
    
    it { subject.should be_kind_of(Iso8601TimeRange) }
    
    context "with timezone" do
      it "should not change the instance it is called on" do
        range = TimeRange.new(@start, @finish)
        range.freeze
        expect{
          range.to_iso8601
        }.not_to raise_error
      end
    end
  end
end
