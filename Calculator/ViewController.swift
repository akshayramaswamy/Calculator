//
//  ViewController.swift
//  Calculator
//
//  Created by Akshay Ramaswamy on 1/14/17.
//  Copyright © 2017 Akshay Ramaswamy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var display: UILabel!
    @IBOutlet weak var descriptionDisplay: UILabel!
    
    var userIsInTheMiddleOfTyping: Bool = false
    
    @IBAction func touchDigit(_ sender: UIButton) {
        let digit = sender.currentTitle!
        
        if userIsInTheMiddleOfTyping {
            if display.text!.contains(".") && digit == "."{
                return
            }
            let textCurrentlyInDisplay = display.text!
            display.text = textCurrentlyInDisplay + digit
        } else {
            if digit == "."  {
                display.text = "0" + digit
            } else {
                display.text = digit
            }
            userIsInTheMiddleOfTyping = true
        }
        
    }

    
    //computed properties
    var displayValue: Double {
        get {
            return Double(display.text!)!
        }
        set{
            //newValue ex - if we use displayValue = 5, then newValue is 5
            display.text = String(newValue)
            descriptionDisplay.text = brain.accumulatedDescription
        }
    }
    
    //brain talks to model
    private var brain = CalculatorBrain()
    
    
    @IBAction func clearCalculator(_ sender: UIButton) {
        brain = CalculatorBrain()
        displayValue = 0
        descriptionDisplay.text = " "
        userIsInTheMiddleOfTyping = false
    }
    
    @IBAction func performOperation(_ sender: UIButton) {
        if userIsInTheMiddleOfTyping{
            brain.setOperand(displayValue)
            userIsInTheMiddleOfTyping = false
        }
        //sets mathemcaticalSymbol if we can unwrap sender.currentTitle
        if let mathematicalSymbol = sender.currentTitle {
            brain.performOperation(mathematicalSymbol)
            descriptionDisplay.text = brain.accumulatedDescription
        }
        if let result = brain.result {
            displayValue = result
        }
    }

}

