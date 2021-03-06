require 'test_helper'

module WebbedTest
  class LanguageRangeTest < TestCase
    test '#range' do
      star = Webbed::LanguageRange.new('*')
      assert_equal '*', star.range
      
      star_with_q = Webbed::LanguageRange.new('*;q=0.5')
      assert_equal '*', star_with_q.range
      
      other = Webbed::LanguageRange.new('en-gb')
      assert_equal 'en-gb', other.range
      
      other_with_q = Webbed::LanguageRange.new('en-gb;q=0.99')
      assert_equal 'en-gb', other_with_q.range
    end
    
    test '#star?' do
      star = Webbed::LanguageRange.new('*')
      assert star.star?
      
      other = Webbed::LanguageRange.new('en-gb')
      refute other.star?
    end
    
    test '#to_s' do
      star = Webbed::LanguageRange.new('*')
      assert_equal '*', star.to_s
      
      other = Webbed::LanguageRange.new('en-gb;q=0.99')
      assert_equal 'en-gb; q=0.99', other.to_s
    end
    
    test '#primary_tag' do
      star = Webbed::LanguageRange.new('*')
      assert_equal '*', star.primary_tag
      
      other = Webbed::LanguageRange.new('en-gb')
      assert_equal 'en', other.primary_tag
    end
    
    test '#subtags' do
      star = Webbed::LanguageRange.new('*')
      assert_equal [], star.subtags
      
      other = Webbed::LanguageRange.new('en-gb')
      assert_equal ['gb'], other.subtags
    end
    
    test '#include?' do
      star = Webbed::LanguageRange.new('*')
      assert star.include?(Webbed::LanguageTag.new('en'))
      assert star.include?(Webbed::LanguageTag.new('en-gb'))
      assert star.include?(Webbed::LanguageTag.new('x-pig-latin'))
      
      en = Webbed::LanguageRange.new('en')
      assert en.include?(Webbed::LanguageTag.new('en'))
      assert en.include?(Webbed::LanguageTag.new('en-us'))
      assert en.include?(Webbed::LanguageTag.new('en-gb'))
      refute en.include?(Webbed::LanguageTag.new('x-pig-latin'))
      
      en_gb = Webbed::LanguageRange.new('en-gb; q=0.5')
      refute en_gb.include?(Webbed::LanguageTag.new('en'))
      refute en_gb.include?(Webbed::LanguageTag.new('en-us'))
      assert en_gb.include?(Webbed::LanguageTag.new('en-gb'))
      refute en_gb.include?(Webbed::LanguageTag.new('x-pig-latin'))
      
      x_pig_latin = Webbed::LanguageRange.new('x-pig-latin')
      refute x_pig_latin.include?(Webbed::LanguageTag.new('en'))
      refute x_pig_latin.include?(Webbed::LanguageTag.new('en-us'))
      refute x_pig_latin.include?(Webbed::LanguageTag.new('en-gb'))
      assert x_pig_latin.include?(Webbed::LanguageTag.new('x-pig-latin'))
    end
    
    test '#precedence' do
      star = Webbed::LanguageRange.new('*')
      assert_equal 0, star.precedence
      
      en = Webbed::LanguageRange.new('en')
      assert_equal 2, en.precedence
      
      en_gb = Webbed::LanguageRange.new('en-gb')
      assert_equal 5, en_gb.precedence
    end
    
    test '#quality' do
      star = Webbed::LanguageRange.new('*')
      assert_equal 1, star.quality
      
      star.quality = 0.3
      assert_equal 0.3, star.quality
      assert_equal '*; q=0.3', star.to_s
      
      star_with_q = Webbed::LanguageRange.new('*; q=0.5')
      assert_equal 0.5, star_with_q.quality
      
      other = Webbed::LanguageRange.new('en-gb')
      assert_equal 1, other.quality
      
      other_with_q = Webbed::LanguageRange.new('en-gb; q=0.99')
      assert_equal 0.99, other_with_q.quality
    end
  end
end