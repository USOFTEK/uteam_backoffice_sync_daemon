require_relative "spec_helper"

describe Daemon do

  describe "#archive_db" do
    let(:dump) { "dumps/test_dump.sql" }

    after :each do
      File.delete(dump) if File.exists?(dump)
    end

    it "creates database dump and stores it in directory /dumps" do
      Daemon.archive_db "test_dump"
      expect(File.exists?(dump)).to be_truthy
    end

  end

end