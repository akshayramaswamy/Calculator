//
//  ViewController.swift
//  Calculator
//
//  Created by Akshay Ramaswamy on 1/14/17.
//  Copyright © 2017 Akshay Ramaswamy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var mValue: UILabel!
    @IBOutlet weak var display: UILabel!
    @IBOutlet weak var descriptionDisplay: UILabel!
    
    var userIsInTheMiddleOfTyping: Bool = false
    var variableDictionary = Dictionary<String, Double>()
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
            
            //descriptionDisplay.text = brain.evaluate(using: variableDictionary).description
        }
    }
    
    //brain talks to model
    private var brain = CalculatorBrain()
    @IBAction func useM(_ sender: UIButton) {
        
        brain.setOperand(variable: sender.currentTitle!)
        if let result = brain.evaluate(using: variableDictionary).result {
            displayValue = result
        }
        //descriptionDisplay.text = brain.evaluate().description
    }
    @IBAction func undo(_ sender: UIButton) {
        if !userIsInTheMiddleOfTyping {
            brain.undo()
            if let result = brain.evaluate(using: variableDictionary).result {
                displayValue = result
            }
            descriptionDisplay.text = brain.evaluate(using: variableDictionary).description
        } else {
            var digit = display.text!
            digit.remove(at: digit.index(before: digit.endIndex))
            //var digit = display.text!
            //digit.remove(at: digit.endIndex)
            display.text = digit
            if display.text == "" {
                displayValue = 0.0
                userIsInTheMiddleOfTyping = false
            }
        }
    }
    
    @IBAction func createM(_ sender: UIButton) {
        variableDictionary["M"] = displayValue
        //print (variableDictionary["M"])
        //descriptionDisplay.text = brain.evaluate(using: variableDictionary).description
        mValue.text = String(displayValue)
        userIsInTheMiddleOfTyping = false
        if let result = brain.evaluate(using: variableDictionary).result {
            
            displayValue = result
            //descriptionDisplay.text = brain.evaluate(using: variableDictionary).description
        }
        
    }

    
    @IBAction func clearCalculator(_ sender: UIButton) {
        brain = CalculatorBrain()
        displayValue = 0
        descriptionDisplay.text = " "
        mValue.text = " "
        variableDictionary = [:]
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
            descriptionDisplay.text = brain.evaluate(using: variableDictionary).description
        }
        if let result = brain.evaluate(using: variableDictionary).result {
            displayValue = result
            descriptionDisplay.text = brain.evaluate(using: variableDictionary).description
        }
    }

}

