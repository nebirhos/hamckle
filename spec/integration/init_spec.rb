require 'spec_helper'
require 'fileutils'
require 'yaml'

describe Hamckle::Cli do
  config = "./tmp/test.yml"

  describe "exec 'hamckle init -c #{config}'" do
    def execute_with!(*answers)
      capture_with_inputs(:stdout, *answers) do
        described_class.start(%w[init -c ./tmp/test.yml])
      end
    end

    let(:account_host) { "myhost" }
    let(:username) { "tito@traves.com" }
    let(:token) { "abc123" }

    before do
      FileUtils.rm_rf(File.dirname(config))
      @output = execute_with!(account_host, username, token)
    end

    context "configuration file does not exist" do
      it "creates a configuration file" do
        expect(File.exists?(config)).to be_true
      end

      %w(account_host username token).each do |field|
        it "sets given #{field}" do
          settings = YAML.load_file(config)
          expect(settings['freckle'][field]).to eq eval(field)
        end
      end

      it "says the file was successfully created" do
        expect(@output).to match(/file created/)
      end
    end

    context "configuration file does exist" do
      let(:new_account_host) { "adifferenthost" }
      let(:new_username) { "thomas@turbato.it" }
      let(:new_token) { "xyz789" }

      it "asks permission to overwrite the file" do
        new_output = execute_with!('n')
        expect(new_output).to match(/Overwrite.*\?/)
      end

      context "if I answer NO" do
        %w(account_host username token).each do |field|
          it "does NOT overwrite #{field}" do
            execute_with!('n', new_account_host, new_username, new_token)
            settings = YAML.load_file(config)
            expect(settings['freckle'][field]).to eq eval(field)
          end
        end
      end

      context "if I answer YES" do
        %w(account_host username token).each do |field|
          it "DOES overwrite #{field}" do
            execute_with!('y', new_account_host, new_username, new_token)
            settings = YAML.load_file(config)
            expect(settings['freckle'][field]).to eq eval("new_#{field}")
          end
        end
      end
    end
  end

end
