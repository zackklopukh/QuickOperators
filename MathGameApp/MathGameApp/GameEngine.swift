import UIKit

import Foundation

// 1 - easy. 2 - medium, 3 - Hard
var difficulty = 1
// Placeholders for which a [Bool] will have true or false at those locations
// for whtether or not those operators are active
let basicOperations = ["Addition", "Subtraction", "Multiplication", "Division"]

struct Game {
    var difficulty: Int
    let operations: [Bool]
    
    //Return an array containing 4 Ints, 3 fake answers 1 real in a random order
    //Return an Int thats signifies the index of the correct answer
    //Return a string that is the prompt
    func CreateQuestion() -> ([Int], Int, String) {
        var indexInGame: Int
        
        //Make sure the operation is one that is selected
        repeat {
            indexInGame = Int.random(in: 0...3)
        } while operations[indexInGame] == false
        
        //Randomly chose selected operation
        switch indexInGame {
        case 0:
            return CreateAddition()
        case 1:
            return CreateSubtraction()
        case 2:
            return CreateMultiplication()
        case 3:
            return CreateDivision()
        default:
            print("Error")
        }
        return([],0,"")
    }
    
    //Creates addition problem
    private func CreateAddition() -> ([Int], Int, String) {
        var possibleAnswers: [Int] = []
        var correctIndex: Int = 0
        var num1: Int = 0
        var num2: Int = 0
        var num3: Int = 0
        
        switch difficulty{
            //Difficulty easy, 1<a<25, 1<b<25, a+b
        case 1:
            num1 = Int.random(in: 1...15)
            num2 = Int.random(in: 1...15)
            
            for _ in 1...3 {
                var randomNum: Int
                repeat {
                    randomNum = Int.random(in: max(1, (num1+num2 - 10))...(num1+num2 + 10))
                } while randomNum == num1+num2 || possibleAnswers.contains(randomNum)
                possibleAnswers.append(randomNum)
            }
            
            correctIndex = Int.random(in: (0...3))
            possibleAnswers.insert(num1+num2, at: correctIndex)
            
        case 2:
            //medium 20<a<99 20<b<99 a+b
            num1 = Int.random(in: 20...99)
            num2 = Int.random(in: 20...99)
            
            for _ in 1...3 {
                var randomNum: Int
                repeat {
                    randomNum = Int.random(in: max(1, (num1+num2 - 10))...(num1+num2 + 10))
                } while randomNum == num1+num2 || possibleAnswers.contains(randomNum)
                possibleAnswers.append(randomNum)
            }
            
            correctIndex = Int.random(in: (0...3))
            possibleAnswers.insert(num1+num2, at: correctIndex)
            
        case 3:
            //hard 20<a<99 20<b<99 20<c<99 a+b+C
            num1 = Int.random(in: 20...99)
            num2 = Int.random(in: 20...99)
            num3 = Int.random(in: 20...99)
            
            for _ in 1...3 {
                var randomNum: Int
                repeat {
                    randomNum = Int.random(in: max(1, (num1+num2+num3 - 10))...(num1+num2+num3 + 10))
                } while randomNum == num1+num2 || possibleAnswers.contains(randomNum)
                possibleAnswers.append(randomNum)
            }
            
            correctIndex = Int.random(in: (0...3))
            possibleAnswers.insert(num1+num2+num3, at: correctIndex)
            
            return (possibleAnswers, correctIndex, "\(num1)+\(num2)+\(num3)=")
            
        default:
            print("Error")
        }
            //print("\(possibleAnswers)   \([correctIndex, num1, num2])")
            return (possibleAnswers, correctIndex, "\(num1)+\(num2)=")
    }
    
    //Generate subtraction problem
    private func CreateSubtraction() -> ([Int], Int, String) {
        var possibleAnswers: [Int] = []
        var correctIndex: Int = 0
        var num1: Int = 0
        var num2: Int = 0
        
        switch difficulty {
        case 1:
            //easy 1<a<20  1<b<a a-b
            num1 = Int.random(in: 1...20)
            num2 = Int.random(in: 1...num1)
            
            for _ in 1...3 {
                var randomNum: Int
                repeat {
                    randomNum = Int.random(in: max(1, (num1-num2 - 5))...(num1-num2 + 5))
                } while randomNum == num1-num2 || possibleAnswers.contains(randomNum)
                possibleAnswers.append(randomNum)
            }
            
            correctIndex = Int.random(in: (0...3))
            possibleAnswers.insert(num1-num2, at: correctIndex)
            
        case 2:
            num1 = Int.random(in: 10...100)
            num2 = Int.random(in: 10...100)
            
            for _ in 1...3 {
                var randomNum: Int
                repeat {
                    randomNum = Int.random(in: (num1-num2 - 10)...(num1-num2 + 10))
                } while randomNum == num1-num2 || possibleAnswers.contains(randomNum)
                possibleAnswers.append(randomNum)
            }
            
            correctIndex = Int.random(in: (0...3))
            possibleAnswers.insert(num1-num2, at: correctIndex)
            
        case 3:
            
            num1 = Int.random(in: 100...999)
            num2 = Int.random(in: 100...999)
            
            for _ in 1...3 {
                var randomNum: Int
                repeat {
                    randomNum = Int.random(in: (num1-num2 - 20)...(num1-num2 + 20))
                } while randomNum == num1-num2 || possibleAnswers.contains(randomNum)
                possibleAnswers.append(randomNum)
            }
            
            correctIndex = Int.random(in: (0...3))
            possibleAnswers.insert(num1-num2, at: correctIndex)
            
        default:
            print("Invalid selection")
        }
        
        //print("\(possibleAnswers)   \([correctIndex, num1, num2])")
        return (possibleAnswers, correctIndex, "\(num1)-\(num2)=")
    }
    
    private func CreateMultiplication() -> ([Int], Int, String) {
        var possibleAnswers: [Int] = []
        var correctIndex: Int = 0
        var num1: Int = 0
        var num2: Int = 0
        
        switch difficulty{
        case 1:
            num1 = Int.random(in: 1...12)
            num2 = Int.random(in: 1...12)
            
            for _ in 1...3 {
                var randomNum: Int
                repeat {
                    randomNum = Int.random(in: max(1, (num1*num2 - 10))...(num1*num2 + 10))
                } while randomNum == num1*num2 || possibleAnswers.contains(randomNum)
                possibleAnswers.append(randomNum)
            }
            
            correctIndex = Int.random(in: (0...3))
            possibleAnswers.insert(num1*num2, at: correctIndex)
            
        case 2:
            num1 = Int.random(in: 2...12)
            num2 = Int.random(in: 12...30)
            
            for _ in 1...3 {
                var randomNum: Int
                repeat {
                    randomNum = Int.random(in: max(1, (num1*num2 - 15))...(num1*num2 + 15))
                } while randomNum == num1*num2 || possibleAnswers.contains(randomNum)
                possibleAnswers.append(randomNum)
            }
            
            correctIndex = Int.random(in: (0...3))
            possibleAnswers.insert(num1*num2, at: correctIndex)
            
        case 3:
            num1 = Int.random(in: 12...50)
            num2 = Int.random(in: 25...99)
            
            for _ in 1...3 {
                var randomNum: Int
                repeat {
                    randomNum = Int.random(in: max(1, (num1*num2 - 200))...(num1*num2 + 200))
                } while randomNum == num1*num2 || possibleAnswers.contains(randomNum)
                possibleAnswers.append(randomNum)
            }
            
            correctIndex = Int.random(in: (0...3))
            possibleAnswers.insert(num1*num2, at: correctIndex)
            
        default:
            print("Error")
        }
            //print("\(possibleAnswers)   \([correctIndex, num1, num2])")
            return (possibleAnswers, correctIndex, "\(num1)*\(num2)=")
    }
    
    private func CreateDivision() -> ([Int], Int, String) {
        var possibleAnswers: [Int] = []
        var correctIndex: Int = 0
        var denominator: Int = 0
        var ans: Int = 0
        
        switch difficulty{
        case 1:
            denominator = Int.random(in: 2...9)
            ans = Int.random(in: 1...7)
            
            for _ in 1...3 {
                var randomNum: Int
                repeat {
                    randomNum = Int.random(in: max(1, (ans - 3))...(ans + 3))
                } while randomNum == ans || possibleAnswers.contains(randomNum)
                possibleAnswers.append(randomNum)
            }
            
            correctIndex = Int.random(in: (0...3))
            possibleAnswers.insert(ans, at: correctIndex)
            
        case 2:
            denominator = Int.random(in: 2...12)
            ans = Int.random(in: 5...30)
            
            for _ in 1...3 {
                var randomNum: Int
                repeat {
                    randomNum = Int.random(in: max(1, (ans - 3))...(ans + 3))
                } while randomNum == ans || possibleAnswers.contains(randomNum)
                possibleAnswers.append(randomNum)
            }
            
            correctIndex = Int.random(in: (0...3))
            possibleAnswers.insert(ans, at: correctIndex)
            
        case 3:
            let hardDenominators = [3,4,6,7,8,9,11,13,14,16,17,18,19,21,22,23,24,26,27,28,29]
            denominator = hardDenominators[Int.random(in: 0..<hardDenominators.count)]
            ans = Int.random(in: 4...50)
            
            for _ in 1...3 {
                var randomNum: Int
                repeat {
                    randomNum = Int.random(in: max(1, (ans - 3))...(ans + 3))
                } while randomNum == ans || possibleAnswers.contains(randomNum)
                possibleAnswers.append(randomNum)
            }
            
            correctIndex = Int.random(in: (0...3))
            possibleAnswers.insert(ans, at: correctIndex)
            
        default:
            print("Error")
        }
            //print("\(possibleAnswers)   \([correctIndex, denominator*ans, denominator])")
            return (possibleAnswers, correctIndex, "\(denominator*ans)/\(denominator)=")
    }
}

