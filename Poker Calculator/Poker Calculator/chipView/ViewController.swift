//
//  ViewController.swift
//  Poker Calculator
//
//  Created by Mark Paris on 7/12/19.
//  Copyright © 2019 Mark Paris. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //Logo
    @IBOutlet weak var logo: UIImageView!
    
    //Textfields
    @IBOutlet weak var totalPlayers: UITextField!
    
    @IBOutlet weak var buyIn: UITextField!
    
    @IBOutlet weak var denominations: UITextField!
    
    @IBOutlet weak var smallBlind: UITextField!
    
    //Error Message Display
    @IBOutlet weak var display: UILabel!
    
    //Convert Textfield text to Ints or Doubles
    var totalPlayersTemp:Int{
        return Int(totalPlayers.text!) ?? 0
    }
    
    var buyInTemp: Double{
        return Double(buyIn.text!) ?? 0
    }
    
    var denominationsInt:Int{
        return Int(denominations.text!) ?? 0
    }
    
    var smallBlindDouble: Double{
        return Double(smallBlind.text!) ?? 0
    }
    
    //Model
    lazy var chipData: ChipData = ChipData.init(numberOfPlayers: totalPlayersTemp, buyIn: buyInTemp, colors: denominationsInt, smallBlind: smallBlindDouble)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Load Logo
        logo.image = UIImage(named: "PokerCalculatorLogo")
    }
    
    
    @IBAction func calculateButton(_ sender: UIButton) {
        
        //Check for errors in input
        if totalPlayersTemp == 0 || buyInTemp == 0 || denominationsInt == 0 || smallBlindDouble == 0{
            display.text = "Please enter a value for all fields"
        }else if denominationsInt > 7{
            display.text = "Please enter a denomination of 7 or under"
        //Segue
        }else{
            performSegue(withIdentifier: "chipDataToDenominations", sender: self)
            
        }
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //Send data to DenominationsViewController
        let denominationsViewController = segue.destination as! DenominationsViewController
        denominationsViewController.chipData = self.chipData
    }
  
    //If user touches outside of textfield lower keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
}

