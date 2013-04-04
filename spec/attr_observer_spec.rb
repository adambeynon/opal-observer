require 'spec_helper'

class ObserverTest
  include AttrObserver

  attr_accessor :foo, :bar
end

describe AttrObserver do
  let(:obj) { ObserverTest.new }

  describe "#add_observer" do
    it "should allow handlers to be registered to observe a given attribute" do
      count = 0

      obj.add_observer(:foo) { count += 1 }

      obj.foo = 100
      count.should eq(1)

      obj.foo = 201
      count.should eq(2)
    end

    it "allows more than one handler to be added per attribute" do
      out = []
      obj.add_observer(:foo) { out << :first }
      obj.add_observer(:foo) { out << :second }

      obj.foo = 42
      out.should eq([:first, :second])

      obj.foo = 3.142
      out.should eq([:first, :second, :first, :second])
    end

    it "passes the new attribute value to the handler" do
      val = nil
      obj.add_observer(:foo) { |h| h.should eq(val) }
      obj.foo = (val = 42)
      obj.foo = (val = 3.142)
    end

    it "allows handlers to be added for different attributes" do
      out = []
      obj.add_observer(:foo) { out << :foo }
      obj.add_observer(:bar) { out << :bar }

      obj.foo = 200
      out.should eq([:foo])

      obj.bar = 300
      out.should eq([:foo, :bar])

      obj.bar = 929292
      out.should eq([:foo, :bar, :bar])
    end

    it "passes the new and old values to block" do
      obj.foo = 200
      result = []

      obj.add_observer(:foo) { |new, old| result << [new, old] }

      obj.foo = 500
      result.should eq([[500, 200]])

      obj.foo = 314
      result.should eq([[500, 200], [314, 500]])
    end

    it "does not create a setter unless one was originally defined" do
      obj.respond_to?(:blah).should be_false
      obj.add_observer(:blah) { raise "do not call" }
      obj.respond_to?(:blah).should be_false
    end

    it "returns the passed in block" do
      p = proc {}
      obj.add_observer(:foo, &p).should eq(p)
    end
  end

  describe "#remove_observer" do
    it "has no action if no observer setup for attribute" do
      obj.remove_observer(:foo, proc {})
    end

    it "has no action if the handler doesn't exist for the observed attribute" do
      p = proc {}
      obj.add_observer(:foo) {}
      obj.remove_observer(:foo, p)
    end

    it "removes an existing handler for a given attribute" do
      count = 0
      handler = obj.add_observer(:foo) { count += 1 }

      obj.foo = 42
      count.should eq(1)

      obj.remove_observer :foo, handler
      obj.foo = 10000000
      count.should eq(1)
    end
  end
end
