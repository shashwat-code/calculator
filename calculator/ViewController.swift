//
//  ViewController.swift
//  calculator
//
//  Created by Shashwat on 28/01/21.
//

import UIKit
class ViewController: UIViewController {

   
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var answer: UILabel!
    var inMiddle = false
    @IBAction func numpad(_ sender: UIButton) {
        
        let num = sender.currentTitle!
        if inMiddle{
            answer.text=answer.text!+num
        }else{
            answer.text=num
        }
        inMiddle=true
    }
    
    var display: Double{
        get{
            return Double(answer.text!)!
        }
        set{
            answer.text = String(newValue)
        }
    }
    
    var brain=CalculatorBrain()
    @IBAction func performOperation(_ sender: UIButton) {
        
        if inMiddle{
            brain.setOperand(operand: display)
            print("perform operation inmiddle")
            desc.text = brain.descLabel()
            inMiddle=false
        }
        
        if let symbol = sender.currentTitle{
            brain.operation(Operator:symbol)
        }
        
        desc.text = brain.descLabel()
        display = brain.result
        
    }
}


