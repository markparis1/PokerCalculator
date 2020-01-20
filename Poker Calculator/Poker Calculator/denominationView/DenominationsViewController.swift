//
//  DenominationsViewController.swift
//  Poker Calculator
//
//  Created by Mark Paris on 9/12/19.
//  Copyright © 2019 Mark Paris. All rights reserved.
//

import UIKit

class DenominationsViewController: UIViewController {
    
    //Logo
    @IBOutlet weak var logo: UIImageView!
    
    //Labels containing 1st, 2nd, 3rd, etc.
    @IBOutlet var colorLabels: [UILabel]!
    
    //Amount of chips per color TextFields
    @IBOutlet var chipsAvailablePerDenominationFields: [UITextField]!
    
    //Return to ChipViewController
    @IBAction func returnToChipData(_ sender: Any) {
        performSegue(withIdentifier: "denominationsToChipData", sender: self)
    }
    
    //Error message label
    @IBOutlet weak var errorLabel: UILabel!
    
    //checks if any fields are empty
    @IBAction func calculate(_ sender: UIButton) {
        errorLabel.text = ""
        for index in 0...chipsAvailablePerDenominationFields.count-1{
            if chipsAvailablePerDenominationFields[index].tag <= chipData!.colors{
                if chipsAvailablePerDenominationFields[index].text == ""{
                    errorLabel.text = "Please fill in all fields"
                }
            }
        }
        if errorLabel.text == ""{
            performSegue(withIdentifier: "denominationsToChipData", sender: self)
        }
    }
    
    
    //Data from ViewController
    var chipData: ChipData?
    
    //Add user entered data to array of Ints
    func addChipsPerDenom() -> DenominationsData{
        var chipDenoms: [Int] = []
        //loop through textfield array
        for i in 0...chipsAvailablePerDenominationFields.count-1{
            //ensure correct order
            if chipsAvailablePerDenominationFields[i].tag <= chipData!.colors{
                chipDenoms.append(Int(chipsAvailablePerDenominationFields[i].text!) ?? 0)}
        }
        
        let denominationsData = DenominationsData(chipsPerDenomination: chipDenoms)
        
        return denominationsData
    }
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //segue to ChipDataViewController
        if segue.identifier == "denominationsToChipData"{
            let chipDataViewController = segue.destination as! ChipDataViewController
            //Send all user entered data
            chipDataViewController.denominationsData = addChipsPerDenom()
            chipDataViewController.chipData = chipData
        }
       
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        removeUnnecessaryColors()
        
        logo.image = UIImage(named: "PokerCalculatorLogo")
    }
    
    //Remove Labels and textfields unneccessary based on the user entered denominations in ViewController
    private func removeUnnecessaryColors(){
        for index in 0...colorLabels.count-1{
            if colorLabels[index].tag > chipData!.colors {
                colorLabels[index].text = ""
                
            }
        }
        for index in 0...chipsAvailablePerDenominationFields.count-1{
            if chipsAvailablePerDenominationFields[index].tag > chipData!.colors{
                chipsAvailablePerDenominationFields[index].isHidden = true
            }
        }
    }
    
    //If user touches outside of textfield lower keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}
