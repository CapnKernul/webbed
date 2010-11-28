require 'spec_helper'

shared_examples_for '200 OK Status Code' do
  it "should set #status_code" do
    subject.status_code.should == 200
  end
  
  it "should set #default_reason_phrase" do
    subject.default_reason_phrase.should == 'OK'
  end
end

describe Webbed::StatusCode do
  before do
    @continue = Webbed::StatusCode.new 100
    @ok = Webbed::StatusCode.new 200
    @multiple_choices = Webbed::StatusCode.new 300
    @bad_request = Webbed::StatusCode.new 400
    @internal_server_error = Webbed::StatusCode.new 500
    @unknown = Webbed::StatusCode.new 600
  end
  
  context "when created with a String" do
    subject { Webbed::StatusCode.new '200' }
    it_should_behave_like '200 OK Status Code'
  end
  
  context "when created with a Fixnum" do
    subject { @ok }
    it_should_behave_like '200 OK Status Code'
  end
  
  context "when two identical status codes are created" do
    it "should cache them so they are exactly equal" do
      @ok.should equal(Webbed::StatusCode.new(200))
    end
  end
  
  context "when it is an informational status code" do
    subject { @continue }
    it { should be_informational }
    it { should_not be_a_success }
    it { should_not be_a_redirection }
    it { should_not be_a_client_error }
    it { should_not be_a_server_error }
    it { should_not be_unknown }
    it { should_not be_an_error }
  end
  
  context "when it is a success status code" do
    subject { @ok }
    it { should_not be_informational }
    it { should be_a_success }
    it { should_not be_a_redirection }
    it { should_not be_a_client_error }
    it { should_not be_a_server_error }
    it { should_not be_unknown }
    it { should_not be_an_error }
  end
  
  context "when it is a redirect status code" do
    subject { @multiple_choices }
    it { should_not be_informational }
    it { should_not be_a_success }
    it { should be_a_redirection }
    it { should_not be_a_client_error }
    it { should_not be_a_server_error }
    it { should_not be_unknown }
    it { should_not be_an_error }
  end
  
  context "when it is a client error status code" do
    subject { @bad_request }
    it { should_not be_informational }
    it { should_not be_a_success }
    it { should_not be_a_redirection }
    it { should be_a_client_error }
    it { should_not be_a_server_error }
    it { should_not be_unknown }
    it { should be_an_error }
  end
  
  context "when it is a server error status code" do
    subject { @internal_server_error }
    it { should_not be_informational }
    it { should_not be_a_success }
    it { should_not be_a_redirection }
    it { should_not be_a_client_error }
    it { should be_a_server_error }
    it { should_not be_unknown }
    it { should be_an_error }
  end
  
  context "when it is an unknown status code" do
    subject { @unknown }
    it { should_not be_informational }
    it { should_not be_a_success }
    it { should_not be_a_redirection }
    it { should_not be_a_client_error }
    it { should_not be_a_server_error }
    it { should be_unknown }
    it { should_not be_an_error }
  end
  
  describe "#<=>" do
    it "should be less than a bigger status code" do
      @ok.should < 900
    end
    
    it "should equal the same status code" do
      @ok.should == 200
    end
    
    it "should be greater than a smaller status code" do
      @ok.should > 199
    end
  end
  
  describe "#to_i" do
    it "should convert to a Fixnum" do
      @ok.to_i.should == 200
    end
  end
  
  describe "#to_s" do
    it "should convert to a String" do
      @ok.to_s.should == '200'
    end
  end
end