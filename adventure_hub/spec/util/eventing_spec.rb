require 'spec_helper'

describe AdventureHub::Util::Eventing do

  class EventingTester
    include AdventureHub::Util::Eventing
    attr_reader :pings
    attr_reader :pongs

    def ping(*args)
      @pings ||= []
      @pings << args
    end

    def send_ping(*args)
      emit(:ping, *args)
    end

  end

  subject{ EventingTester.new }


  describe "listener addition" do

    it "should successfully accept a new handler by calling 'on'" do
      subject.on :foo, Object.new, :some_method
    end

    it "should successfully accept a new handler by calling 'once'" do
      subject.once :foo, Object.new, :some_method
    end
  end

  describe "listener removal" do
    it "should return false when removing an unregistered listener" do
      subject.remove_listener(:foo, Object.new, :some_method).should == false
    end

    it "should return true when removing a valid listener" do
      object = Object.new
      subject.on :foo, object, :some_method
      subject.remove_listener(:foo, object, :some_method).should == true
    end
  end

  describe "event emission" do
    before(:each) do
      @many_receiver = EventingTester.new
      @once_receiver = EventingTester.new
      subject.on(:ping,   @many_receiver, :ping)
      subject.once(:ping, @once_receiver, :ping)
      subject.send_ping("foo")
      subject.send_ping("bar")

    end

    it "should make a method call on all receivers" do
      @many_receiver.pings.should == [["foo"], ["bar"]]
    end

    it "shold remove any 'once' listeners after the event is emitted" do
      @once_receiver.pings.should == [["foo"]]
    end
  end
end