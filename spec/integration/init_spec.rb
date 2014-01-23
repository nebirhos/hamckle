require 'spec_helper'
require 'fileutils'

describe Hamckle::Cli do
  config = "./tmp/test.yml"

  describe "exec 'hamckle init -c #{config}'" do
    def execute_with!(*answers)
      capture_with_inputs(:stdout, *answers) do
        described_class.start(%w[init -c ./tmp/test.yml])
      end
    end

    let(:host) { "myhost" }
    let(:user) { "tito@traves.com" }
    let(:token) { "abc123" }

    before do
      FileUtils.rm_rf(File.dirname(config))
      @output = execute_with!(host, user, token)
    end

    context "configuration file does not exist" do
      it "creates a configuration file" do
        expect(File.exists?(config)).to be_true
      end

      it "sets given hostname" do
        expect(File.read(config)).to match("account_host: #{host}")
      end

      it "sets given username" do
        expect(File.read(config)).to match("username: #{user}")
      end

      it "sets given token" do
        expect(File.read(config)).to match("token: #{token}")
      end

      it "says the file was successfully created" do
        expect(@output).to match(/file created/)
      end
    end

    context "configuration file does exist" do
      let(:new_host) { "adifferenthost" }

      it "asks permission to overwrite the file" do
        new_output = execute_with!('n')
        expect(new_output).to match(/Overwrite.*\?/)
      end

      context "if I answer NO" do
        it "does NOT overwrite the file" do
          execute_with!('n', new_host)
          expect(File.read(config)).to match("account_host: #{host}")
        end
      end

      context "if I answer YES" do
        it "DOES overwrite the file" do
          execute_with!('y', new_host)
          expect(File.read(config)).to match("account_host: #{new_host}")
        end
      end

    end
  end

end
