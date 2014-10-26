class Writer

  def initialize(stream, calculator, calculations)
    unless stream.is_a? IO
      raise ArgumentError, "you must provide an IO instance (ex: $stdout)"
    end
    unless calculator.is_a? Calculator
      raise ArgumentError, "you must provide a Calculator instance"
    end
    unless calculations.is_a?(Array) && calculations.present?
      raise ArgumentError, "you must provide an Array of calculations to output"
    end
    @stream = stream
    @calculator = calculator
    @calculations = calculations
  end

  # Responsible for outputting to @stream the results of each calculation from
  # the calculator.
  def output
    @calculations.each do |calculation|
      result = @calculator.send(calculation)
      @stream.write "#{calculation.to_s.titleize}:\n#{result.awesome_inspect}\n\n"
    end
  end

end
