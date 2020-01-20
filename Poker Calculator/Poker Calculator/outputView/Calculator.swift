//
//  Calculator.swift
//  Poker Calculator
//
//  Created by Mark Paris on 7/12/19.
//  Copyright © 2019 Mark Paris. All rights reserved.
//

import Foundation

class Calculator{
    
    //Data
    var denominationsData: DenominationsData
    var chipData: ChipData
    
    //calculate total chips
    var totalChipsAvailableTemp: Int{
        var sum = 0
        for chips in denominationsData.chipsPerDenomination{
            sum += chips
        }
        return sum
    }
    
    //calculate chips available per player
    var chipsPerPlayer: Int {
        var sum = 0
        let chipsPerDenom = calculateChipsPerDenom()
        for i in chipsPerDenom{
            sum += i
        }
        
        return sum
    }
    
    //constant for what percentage of chips per player should be of the lowest denomination
    let firstDenominationGoalSumAsPercentageOfChipsPerPlayer = 0.5
    
    //array of chip values in dollars
    let possibleChipValues = [0.01, 0.05, 0.25, 1.00, 5.00, 25.00, 100.00, 500.00, 1000.00, 5000.00, 10000.00]
    
    //initialize Calculator
    init(chipData: ChipData, denominationsData: DenominationsData){
        self.chipData = chipData
        self.denominationsData = denominationsData
    }
    
    //calculate denominations of each chip
    var chipDenominations: [Double]{
        
        var smallBlindIndexInPossibleChipValues = 0
        for index in 0...possibleChipValues.count-1{
            if possibleChipValues[index] == chipData.smallBlind{
                smallBlindIndexInPossibleChipValues = index
                break
            }else if possibleChipValues[index] > chipData.smallBlind{
                smallBlindIndexInPossibleChipValues = index - 1
                break
            }
        }
        var denominationsArray:[Double] = []
        
        for index in 0...chipData.colors-1{
            denominationsArray.append(possibleChipValues[smallBlindIndexInPossibleChipValues + index])
        }
        
        return denominationsArray
    }
    
    //calculate the dollar value of each players chips
    func calculateStack(denominations: [Double], chips chipsPerDenomination: [Int]) -> Double{
        var sum = 0.0
        for index in 0...chipsPerDenomination.count-1{
            sum += denominations[index] * Double(chipsPerDenomination[index])
        }
        
        
        return sum
    }
    
    //create a default array of chips per denomination
    private func populateDefaultChipsPerDenomArray() -> [Int]{
        var populatedArray:[Int] = []
        for index in 0...chipData.colors-1{
            populatedArray.append(denominationsData.chipsPerDenomination[index]/chipData.numberOfPlayers)
        }
        return populatedArray
    }
    
    //calculate final chips per denom
    func calculateChipsPerDenom() -> [Int]{
        var chipsPerDenom = populateDefaultChipsPerDenomArray()
        var stack:Double{
            var sum = 0.0
            for index in 0...chipsPerDenom.count-1{
                sum += chipDenominations[index] * Double(chipsPerDenom[index])
            }
            return sum
        }
        
        
        var differenceIndex = 0
        guard stack > chipData.buyIn else{return []}
        for index in (0...chipsPerDenom.count-1).reversed(){
            guard stack > chipData.buyIn else{break}
            for _ in 0...(chipsPerDenom[index]-1){
                guard stack > chipData.buyIn + chipDenominations[index] else{break}
                chipsPerDenom[index] -= 1
                differenceIndex = index
                print(chipsPerDenom)
                
            }
            
        }
        
        var difference = round(100*(stack - chipData.buyIn))/100
        for index in 0...differenceIndex{
            if stack == chipData.buyIn{break}
            
            for _ in 0...chipsPerDenom[index]{
                if difference.truncatingRemainder(dividingBy: chipDenominations[index]) == 0 && difference != 0{
                    chipsPerDenom[index] -= 1
                    difference -= chipDenominations[index]
                    print(chipsPerDenom)
                }
            }
            
        }
       
        
        
        
        
        
        
        return chipsPerDenom
        
        
        
    }
}




