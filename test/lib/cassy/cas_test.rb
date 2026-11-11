require 'test_helper'

class Cassy::CASTest < ActiveSupport::TestCase
  describe ".base_service_url" do
    it "reduces a URL to its origin" do
      assert_equal "https://client.example.com", Cassy::CAS.base_service_url("https://client.example.com/some/page?x=1")
    end

    it "keeps non-default ports and drops default ones" do
      assert_equal "https://client.example.com:8443", Cassy::CAS.base_service_url("https://client.example.com:8443/x")
      assert_equal "https://client.example.com", Cassy::CAS.base_service_url("https://client.example.com:443/x")
      assert_equal "http://localhost:3000", Cassy::CAS.base_service_url("http://localhost:3000/x")
    end

    it "lowercases the scheme and host" do
      assert_equal "https://client-app.example.com", Cassy::CAS.base_service_url("HTTPS://Client-App.Example.COM/x")
    end

    it "keeps hyphens in the host" do
      assert_equal "https://my-app.example.com", Cassy::CAS.base_service_url("https://my-app.example.com/")
    end

    [
      "https://client.example.com@evil.example.org/x",
      "https://client.example.com:pw@evil.example.org/x",
      "//evil.example.org/x",
      "/relative/path",
      "client.example.com/app",
      "javascript://client.example.com/%0aalert(1)",
      "ftp://client.example.com/",
      "https://",
      "http://bad host/",
      "",
      nil
    ].each do |value|
      it "returns nil for #{value.inspect}" do
        assert_nil Cassy::CAS.base_service_url(value)
      end
    end
  end

  describe ".same_service_origin?" do
    it "matches URLs on the same origin" do
      assert Cassy::CAS.same_service_origin?("https://client.example.com/a", "https://client.example.com/b")
    end

    it "doesn't match different hosts, schemes or ports" do
      refute Cassy::CAS.same_service_origin?("https://client.example.com/", "https://other.example.com/")
      refute Cassy::CAS.same_service_origin?("https://client.example.com/", "http://client.example.com/")
      refute Cassy::CAS.same_service_origin?("https://client.example.com/", "https://client.example.com:8443/")
    end

    it "doesn't match look-alikes" do
      refute Cassy::CAS.same_service_origin?("https://client.example.com/", "https://client.example.com@evil.example.org/")
      refute Cassy::CAS.same_service_origin?("https://my-app.example.com/", "https://my-evil.example.org/")
    end

    it "doesn't treat two invalid URLs as matching" do
      refute Cassy::CAS.same_service_origin?("not a url", "also not a url")
      refute Cassy::CAS.same_service_origin?(nil, nil)
      refute Cassy::CAS.same_service_origin?("https://a@b.example/", "https://a@c.example/")
    end
  end
end
