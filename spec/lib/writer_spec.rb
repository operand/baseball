require 'spec_helper'

describe Writer do

  let(:null_io) { File.open(File::NULL, 'w') }

  describe "#initialize" do
    it "raises an ArgumentError when not given an IO instance" do
      expect{
        Writer.new(nil, Calculator.new, [:foo])
      }.to raise_error(ArgumentError)
    end

    it "raises an ArgumentError when not given a Calculator instance" do
      expect{
        Writer.new(null_io, nil, [:foo])
      }.to raise_error(ArgumentError)
    end

    it "raises an ArgumentError when not given an Array for calculations" do
      expect{
        Writer.new(null_io, Calculator.new, nil)
      }.to raise_error(ArgumentError)
    end

    it "raises an ArgumentError when given an empty Array for calculations" do
      expect{
        Writer.new(null_io, Calculator.new, [])
      }.to raise_error(ArgumentError)
    end

    it "doesn't raise an Exception when the arguments are kosher" do
      expect{
        Writer.new(null_io, Calculator.new, [:foo])
      }.not_to raise_error
    end
  end

  describe "#output" do
    it "calls each calculation on the calculator" do
      calculator = Calculator.new
      expect(calculator).to receive(:foo)
      expect(calculator).to receive(:bar)
      expect(calculator).to receive(:baz)
      writer = Writer.new(null_io, calculator, [:foo, :bar, :baz])
      writer.output
    end

    it "formats and writes the calculators results to the output stream" do
      calculator = Calculator.new
      allow(calculator).to receive(:foo).and_return(:foo_response)
      allow(calculator).to receive(:bar).and_return(:bar_response)
      allow(calculator).to receive(:baz).and_return(:baz_response)
      expect(null_io).to receive(:write).with("Foo:\n#{:foo_response.awesome_inspect}\n\n")
      expect(null_io).to receive(:write).with("Bar:\n#{:bar_response.awesome_inspect}\n\n")
      expect(null_io).to receive(:write).with("Baz:\n#{:baz_response.awesome_inspect}\n\n")
      writer = Writer.new(null_io, calculator, [:foo, :bar, :baz])
      writer.output
    end
  end
end
