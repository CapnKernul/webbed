require 'test_helper'

class HTTPVersionTest < MiniTest::Unit::TestCase
  def test_create_with_string
    version = Webbed::HTTPVersion.new('HTTP/1.1')
    assert_equal 1, version.major
    assert_equal 1, version.minor
  end
  
  def test_create_with_float
    version = Webbed::HTTPVersion.new(2.0)
    assert_equal 2, version.major
    assert_equal 0, version.minor
  end
  
  def test_to_s
    version = Webbed::HTTPVersion.new('HTTP/2.0')
    assert_equal 'HTTP/2.0', version.to_s
    
    version = Webbed::HTTPVersion.new(2.0)
    assert_equal 'HTTP/2.0', version.to_s
  end
  
  def test_to_f
    version = Webbed::HTTPVersion.new('HTTP/2.0')
    assert_equal 2.0, version.to_f
    
    version = Webbed::HTTPVersion.new(2.0)
    assert_equal 2.0, version.to_f
  end
  
  def test_comparable
    one_point_one = Webbed::HTTPVersion.new('HTTP/1.1')
    two_point_oh = Webbed::HTTPVersion.new('HTTP/2.0')
    
    refute_equal one_point_one, two_point_oh
    assert one_point_one < two_point_oh
    assert two_point_oh > one_point_one
  end
  
  def test_constants
    assert_equal 1, Webbed::HTTPVersion::ONE_POINT_ONE.major
    assert_equal 1, Webbed::HTTPVersion::ONE_POINT_ONE.minor
    
    assert_equal 1, Webbed::HTTPVersion::ONE_POINT_OH.major
    assert_equal 0, Webbed::HTTPVersion::ONE_POINT_OH.minor
  end
end