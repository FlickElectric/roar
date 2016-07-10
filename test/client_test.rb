require 'test_helper'
require 'roar/client'

class ClientTest < MiniTest::Spec
  representer_for([Roar::Representer]) do
    property :name
    property :band
  end

  let(:song) { Object.new.extend(rpr).extend(Roar::Client) }

  it "adds accessors" do
    song.name = "Social Suicide"
    song.band = "Bad Religion"
    assert_equal "Social Suicide", song.name
    assert_equal "Bad Religion", song.band
  end

  describe "links" do
    representer_for([Roar::JSON, Roar::Hypermedia]) do
      property :name
      link(:self) { "/songs/1" }
    end

    it "renders links" do
      song.name = "Silenced"
      song.to_json.must_equal %({\"name\":\"Silenced\",\"links\":[{\"rel\":\"self\",\"href\":\"/songs/1\"}]})
    end

    # since this is considered dangerous, we test the mutuable options.
    it "renders links by default" do
      song.to_hash(options = {})
      options.must_equal({:links=>true})
    end
  end
end
