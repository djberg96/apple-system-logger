require 'apple-system-logger'

RSpec.describe Apple::System::Logger do
  let(:log){ described_class.new }

  context "instance methods" do
    example "defines a facility method" do
      expect(log).to respond_to(:facility)
    end

    example "the default facility is nil" do
      expect(log.facility).to be_nil
    end

    example "defines a level method" do
      expect(log).to respond_to(:level)
    end

    example "the default level is debug" do
      expect(log.level).to eql(Apple::System::Logger::ASL_LEVEL_DEBUG)
    end

    example "defines a progname method" do
      expect(log).to respond_to(:progname)
    end

    example "the default progname is nil" do
      expect(log.progname).to be_nil
    end
  end
end
