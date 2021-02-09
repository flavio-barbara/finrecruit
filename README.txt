To test the ruby code copy the jsonChallenge.rb file along with the json files in the same directory.
run from the linux command line:

ruby -r "./jsonChallenge.rb" -e "JSONChallenge.promptMe"

To be prompted to inform the 2 json files to be compared

OR

run ruby -r "./jsonChallenge.rb" -e "JSONChallenge.straightComparison('name-of-file-1.json','name-of-file-2.json', true)"

example: ruby -r "./jsonChallenge.rb" -e "JSONChallenge.straightComparison('BreweriesSample1.json','BreweriesSample2.json')"
