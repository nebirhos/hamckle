require 'simplecov'
require 'coveralls'

SimpleCov.start
Coveralls.wear!

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'hamckle'

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  # Thanks Thor and GitHub friends for this!
  def capture_with_inputs(stream, *args)
    begin
      # override STDOUT
      stream = stream.to_s
      eval "$#{stream} = StringIO.new"
      # override STDIN
      $stdin = StringIO.new
      $stdin.puts(args.shift) until args.empty?
      $stdin.rewind
      yield
      result = eval("$#{stream}").string
    ensure
      eval("$#{stream} = #{stream.upcase}")
      $stdin = STDIN
    end
    result
  end
end
