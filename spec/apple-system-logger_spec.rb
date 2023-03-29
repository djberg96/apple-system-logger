# frozen_string_literal: true

require 'apple-system-logger'

RSpec.describe Apple::System::Logger do
  let(:log){ described_class.new }

  context 'version' do
    example 'version constant is set to expected value' do
      expect(described_class::VERSION).to eql('0.1.2')
    end

    example 'version constant is frozen' do
      expect(described_class::VERSION).to be_frozen
    end
  end

  context 'instance methods' do
    example 'defines a facility method' do
      expect(log).to respond_to(:facility)
    end

    example 'the default facility is nil' do
      expect(log.facility).to be_nil
    end

    example 'defines a level method' do
      expect(log).to respond_to(:level)
    end

    example 'the default level is debug' do
      expect(log.level).to eql(Apple::System::Logger::ASL_LEVEL_DEBUG)
    end

    example 'defines a progname method' do
      expect(log).to respond_to(:progname)
    end

    example 'the default progname is nil' do
      expect(log.progname).to be_nil
    end

    example 'defines a logdev method' do
      expect(log).to respond_to(:logdev)
    end

    example 'the default logdev is nil' do
      expect(log.logdev).to be_nil
    end
  end

  context 'logging methods' do
    example 'there is a << method' do
      expect(log).to respond_to(:<<)
    end

    example 'there is an add method' do
      expect(log).to respond_to(:add)
    end

    example 'there is a debug method' do
      expect(log).to respond_to(:debug)
    end

    example 'there is a debug? method that returns the expected value' do
      expect(log.debug?).to be true
    end

    example 'there is an info method' do
      expect(log).to respond_to(:info)
    end

    example 'there is a info? method that returns the expected value' do
      expect(log.info?).to be true
    end

    example 'there is a warn method' do
      expect(log).to respond_to(:warn)
    end

    example 'there is a warn? method that returns the expected value' do
      expect(log.warn?).to be true
    end

    example 'there is an error method' do
      expect(log).to respond_to(:error)
    end

    example 'there is a error? method that returns the expected value' do
      expect(log.error?).to be true
    end

    example 'there is a fatal method' do
      expect(log).to respond_to(:fatal)
    end

    example 'there is a fatal? method that returns the expected value' do
      expect(log.fatal?).to be true
    end

    example 'there is an unknown method' do
      expect(log).to respond_to(:unknown)
    end

    example 'there is a close method' do
      expect(log).to respond_to(:close)
    end

    example 'calling close on the logger instance works as expected' do
      expect(log.close).to be_nil
      expect(log.close).to be_nil
    end
  end

  context 'search' do
    example 'there is a search method' do
      expect(log).to respond_to(:search)
    end

    example 'a basic search returns the expected results' do
      result = log.search(:sender => 'bootlog', :level => 5)
      expect(result).to be_a(Array)
      expect(result.first).to be_a(Hash)
      expect(result.size).to be >= 1
    end
  end
end
