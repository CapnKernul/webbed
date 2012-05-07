require "spec_helper"
require "addressable/uri"
require "webbed/request"
require "webbed/http_version"

module Webbed
  describe Request do
    let(:method) { "GET" }
    let(:request_uri) { "/search" }
    let(:headers) { { "Host" => "www.google.com" } }
    let(:options) { {} }
    subject { Request.new(method, request_uri, headers, options) }
    
    describe "#initialize" do
      it "sets the method" do
        subject.method.should == Method::GET
      end

      it "sets the request URI" do
        subject.request_uri.should == Addressable::URI.parse("/search")
      end

      it "sets the headers" do
        subject.headers.should == headers
      end

      context "when not provided with an entity body" do
        it "has no entity body" do
          subject.entity_body.should be_nil
        end
      end    

      context "when provided with an entity body" do
        let(:options) { { entity_body: ["foobar"] } }

        it "sets the entity body" do
          subject.entity_body.should == ["foobar"]
        end
      end

      context "when not provided with an HTTP version" do
        it "uses HTTP/1.1" do
          subject.http_version.should == HTTPVersion::ONE_POINT_ONE
        end
      end    

      context "when provided with an HTTP version" do
        let(:options) { { http_version: "HTTP/1.0" } }

        it "sets the HTTP version" do
          subject.http_version.should == HTTPVersion::ONE_POINT_OH
        end
      end

      context "when the request security is not specified" do
        it "is insecure" do
          subject.should_not be_secure
        end
      end    

      context "when the request security is specified" do
        let(:options) { { secure: true } }

        it "sets the security" do
          subject.should be_secure
        end
      end
    end

    describe "#url" do
      context "when the request URI has a host" do
        let(:request_uri) { "http://www.google.com" }
        
        it "returns the request URI" do
          subject.url.should == subject.request_uri
        end
      end

      context "when the request URI does not have a host" do
        context "when the Host header is present" do
          context "when the request is insecure" do
            it "returns the the HTTP scheme Host header as the host for the request URI" do
              subject.url.should == Addressable::URI.parse("http://www.google.com/search")
            end
          end

          context "when the request is secure" do
            let(:options) { { secure: true } }
            
            it "returns the the HTTPS scheme Host header as the host for the request URI" do
              subject.url.should == Addressable::URI.parse("https://www.google.com/search")
            end
          end
        end

        context "when the Host header is not present" do
          let(:headers) { {} }
          
          it "returns the request URI" do
            subject.url.should == subject.request_uri
          end
        end
      end
    end
  end
end
