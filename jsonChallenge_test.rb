require 'minitest/autorun'
require_relative './jsonChallenge.rb'

class JSONChallengeTest < Minitest::Test

	def self.test_json_comparison
		comparison = JSONChallenge.new
    	assert_equal 1, comparison.straightComparison('BreweriesSample1.json', 'BreweriesSample2.json', false)
  	end

end