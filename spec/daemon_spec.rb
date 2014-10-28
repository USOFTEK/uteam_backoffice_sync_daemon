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

  describe "#connect_to_dbs" do

    it "proves that both dbs are connected and data is ready to be accessed" do
      expect(Daemon.current_conn).not_to be nil
      expect(User.all.count).to be > 0
      Daemon.current_conn.query("SELECT COUNT(*) AS c FROM `current_db_test`.`users`;") do |result|
        expect(result["c"]).to be > 0
      end
    end

    #it ""

  end

end