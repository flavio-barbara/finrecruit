# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Author: Flavio Barbara  -  09-Feb-2021
# Purpose: JSON comparison of similarity
# 
# There are different possible approaches to verify the similarity between JSON structures. The one we use in this solution
# parses each JSON and build 2 vectors: one of keys and other of values. Each element of the vector is a vector that contains 
# the set of keys or values of the JSON tree structure. The vector is built by searching in depth, so a variable controls the depth. 
# The vector comparison loop is made by taking each element of the vector with more elements (considering the 2 dimensions of 
# the vector) and looking for one equal within the vector that has the same depth in the vector with fewer elements. 
# Thus, we obtain the total element (quantity of tree leaves) of the largest vector and the similarity rate between 
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

class JSONChallenge

    require 'json'

    # def self.initialize
    #     # just to work
    # end

    # Prompting for the 2 JSONs
    def self.promptMe
        while true # While the user does not inform a valid file name
            begin
                puts "Enter the first JSON file to be compared:\n"
                file2test = gets.chomp
                jsonFile1 = JSON.parse(File.read(file2test))
                puts "Enter the second JSON file to be compared:\n"
                file2test = gets.chomp
                jsonFile2 = JSON.parse(File.read(file2test))
                break
            rescue
                print(">>> ERROR: File not found or not a JSON file! Start over. \n")
            end
        end
        # compares
        compareJSONs(jsonFile1, jsonFile2, true)
    end

    def self.straightComparison(jsonFile1, jsonFile2, print)
        jsonFile1 = JSON.parse(File.read(jsonFile1))
        jsonFile2 = JSON.parse(File.read(jsonFile2))
        return compareJSONs(jsonFile1, jsonFile2, print)
    end

    # JSONs Comparison
    def self.compareJSONs(jsonFile1, jsonFile2, print)
        # First JSON Convertion
        convertedJSON = convertJSON(jsonFile1)
        vKeys1stJSON = convertedJSON[0]
        vVals1stJSON = convertedJSON[1]
        # Second JSON Convertion
        convertedJSON = convertJSON(jsonFile2)
        vKeys2ndJSON = convertedJSON[0]
        vVals2ndJSON = convertedJSON[1]
        # Verifies the similariry rate of JSONs keys
        jsonSimilarity = verify(vKeys1stJSON, vKeys2ndJSON)
        keysTotal = jsonSimilarity[0]
        keysSimilarity = jsonSimilarity[1]
        # Verifies the similariry rate of JSONs values
        jsonSimilarity = verify(vVals1stJSON, vVals2ndJSON)
        valsTotal = jsonSimilarity[0]
        valsSimilarity = jsonSimilarity[1]
        # Print or return the value of Similarity
        return printResults(keysSimilarity, keysTotal, valsSimilarity, valsTotal, print)
    end

    # converting JSON
    def self.convertJSON(jsonStructure)
        # work variables
        vKeys = []
        vValues = []
        depth = 0
        vKeys.push([])
        vValues.push([])
        # call the json to vector transformer
        json2vector(jsonStructure, depth, vKeys, vValues)
        # returns a vector of keys and a vector of values
        return [vKeys, vValues]
    end

    # json to vector transformer method
    def self.json2vector(struct, depth, vKeys, vValues)
        # controls the depth of the tree
        depth = depth + 1
        if vKeys.length < depth + 1
            vKeys.push([])
            vValues.push([])
        end
        # creates the vector of vectors recursively
        # "s" is the element in the received structure. Its class is tested (hash,string, array) and treated as appropriate
        for s in struct
            if s.class != Array
                if s.class == Hash
                    vKeys[depth].push((s.class).to_s)
                    json2vector(s, depth, vKeys, vValues)
                else
                    vKeys[depth].push(s.to_s + (s.class).to_s)
                    vValues[depth].push(s)
                end
            else
                vKeys[depth].push(s[0] + (struct[s[0]].class).to_s)
                if struct[s[0]].class == Hash or struct[s[0]].class == Array
                    json2vector(struct[s[0]], depth, vKeys, vValues)
                else
                    vValues[depth].push(struct[s[0]])
                end
            end
        end
    end

    # Similarity between 2 vectors (JSON)
    def self.verify(vector1, vector2)
        totalLeaves = 0
        totalEquals = 0
        depth = 0
        # gets the bigger vector counting the quantity of leaves
        size1 = vector_size(vector1)
        size2 = vector_size(vector2)
        # separates the bigger and smaller vectors
        if size1 > size2
            vCompareBigger = vector1
            vCompareSmaller = vector2
        else
            vCompareBigger = vector2
            vCompareSmaller = vector1
        end
        # Here is the core! Compares the similariry considering the tree's depth
        for vElementOfBigger in vCompareBigger
            for vElementB in vElementOfBigger
                totalLeaves = totalLeaves + 1
                # maybe the small vector does not have that depth, so lets test
                if vCompareSmaller[depth]
                    for vElementS in vCompareSmaller[depth]
                        if vElementB == vElementS
                            totalEquals = totalEquals + 1
                            break
                        end
                    end
                end
            end
            depth = depth + 1
        end
        # Returns quantity of leaves and how many are common in the two vectos (JSONs)
        return [totalLeaves, totalEquals]
    end

    # counts the total of "leaves" of the vector
    def self.vector_size(vector)
        size = 0
        for element in vector
            for elem2 in element
                size = size + 1
            end
        end
        return size
    end

    # calculates and gives the similariry rate
    def self.printResults(keysSimilarity, keysTotal, valsSimilarity, valsTotal, print)
        keysSimilarityRate = keysSimilarity.to_f / keysTotal.to_f
        valsSimilarityRate = valsSimilarity.to_f / valsTotal.to_f
        similarityRate = keysSimilarityRate.to_f * valsSimilarityRate.to_f
        if print
            puts "-------------------------------------------------------------------------\n"
            puts "The quantity of leaves in the bigger JSON Files is: " + keysTotal.to_s + "\n"
            puts "The KEYS similarity rate is: " + keysSimilarityRate.round(5).to_s + "  (" + keysSimilarity.to_s + "/" + keysTotal.to_s + ")\n"
            puts "The VALUES similarity rate is: " + valsSimilarityRate.round(5).to_s + "  (" + valsSimilarity.to_s + "/" + valsTotal.to_s + ")\n"
            puts "The similarity rate between these two JSON Files is: " + similarityRate.round(5).to_s + "\n"
            puts "-------------------------------------------------------------------------\n"
        else
            return similarityRate
        end
    end

end  # - - - - - end of class - - - - - 