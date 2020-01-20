//
//  ChipDataViewController.swift
//  Poker Calculator
//
//  Created by Mark Paris on 9/1/19.
//  Copyright © 2019 Mark Paris. All rights reserved.
//

import Foundation
import UIKit

class ChipDataViewController: UIViewController {

    //Display for output
    @IBOutlet weak var displayOtherData: UILabel!
    
    //displays each players dollar value of their stack based on the Dollar value of their chips
    @IBOutlet weak var displayTotalDollarValueOfStack: UILabel!
    
    //Displays recommended Dollar denominations to use in the cash game
    @IBOutlet var denomLabelArray: [UILabel]!
    
    //1st Color, 2nd Color, etc.
    @IBOutlet var colorLabels: [UILabel]!
    
    //Recommended chips per each denomination to use, User may change these after the recommended values are given
    @IBOutlet var chipsPerDenominationViews: [UITextField]!
    
    //New Calculation, Return to ViewController
    @IBAction func returnToHome(_ sender: Any) {
        performSegue(withIdentifier: "chipDataToHome", sender: self)
    }
    
    //Back button, Return to DenominationsViewController
    @IBAction func returnToDenominations(_ sender: Any) {
        performSegue(withIdentifier: "chipDataToDenominations", sender: self)
    }
    
    //User Data entered previously
    var denominationsData: DenominationsData?
    var chipData: ChipData?
    
    //Model
    lazy var calculator = Calculator(chipData: chipData!, denominationsData: denominationsData!)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Remove color rows based on user entered denominations
        removeUnnecessaryColors()
        
        //display output of small blind, big blind, and the chips each player receives
        displayOtherData.numberOfLines = 0
        displayOtherData.text = "Small Blind: $\(chipData!.smallBlind)\nBig Blind: $\((chipData!.smallBlind)*2)\nChips Per Player : \((calculator.chipsPerPlayer))"
        
        //Send data to Calculator
        calculator = Calculator(chipData: chipData!, denominationsData: denominationsData!)
        
        //Display dollar value of recommended chip denominations
        displayChipDenominations()
        
        //Display recommended chip per denomination amounts
        displayDefaultChipAmounts(chipsPerDenom: calculator.calculateChipsPerDenom())
        
        //Update displays as user changes chips per denomination
        userChangedAmountOfChips(self)
    }
    
    //Display recommended chip per denomination amounts
    func displayDefaultChipAmounts(chipsPerDenom: [Int]){
        for index in 0...chipsPerDenom.count-1{
            chipsPerDenominationViews[index].text = "\(chipsPerDenom[index])"
        }
    }
    
    //Display dollar value of recommended chip denominations
    func displayChipDenominations(){
        
        for index in 0...calculator.chipDenominations.count-1{
            denomLabelArray[index].text = "$\(calculator.chipDenominations[index])"
        }
        
    }
    
    //Remove color rows based on user entered denominations
    private func removeUnnecessaryColors(){
        //loop through colorLabels, may be out of order
        for index in 0...colorLabels.count-1{
            //ColorLabels taged in order 1 through 7
            if colorLabels[index].tag > chipData!.colors{
                //remove unnecessary label
                colorLabels[index].text = ""
                
                for i in 0...chipsPerDenominationViews.count-1{
                    if chipsPerDenominationViews[i].tag == colorLabels[index].tag{
                        //Hide unnecessary chips per each denomination textField
                        chipsPerDenominationViews[index].isHidden = true
                    }
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //Return to DenominationsViewController, Back button
        if segue.identifier == "chipDataToDenominations"{
            let denominationsViewController = segue.destination as! DenominationsViewController
            denominationsViewController.chipData = self.chipData
        }else{
            
        }
        
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        for index in 0...chipsPerDenominationViews.count-1{
            if chipsPerDenominationViews[index].tag <= chipData!.colors{
                if chipsPerDenominationViews[index].text == "" {
                    return false
                }
            }
        }
        return true
    }
    
    //Update displays as user changes chips per denomination
    @IBAction func userChangedAmountOfChips(_ sender: Any) {
       
        displayTotalDollarValueOfStack.text = "\(calculator.calculateStack(denominations: calculator.chipDenominations, chips: createArrayOfChipsUserEntered()))"
    }
    
    //Create Int array of user entered chips per denomination
    func createArrayOfChipsUserEntered() -> [Int]{
        var intArrayOfChips: [Int] = []
        for index in 0...chipsPerDenominationViews.count-1{
            if let chip = Int(chipsPerDenominationViews[index].text!){
                intArrayOfChips.append(chip)
            }
            
        }
        return intArrayOfChips
    }
    
    //If user touches outside of textfield lower keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
}
