//
//  ViewController.swift
//  Calculator
//
//  Created by Akshay Ramaswamy on 1/14/17.
//  Copyright © 2017 Akshay Ramaswamy. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController {
    
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

        }
    }
    
    //brain talks to model
    private var brain = CalculatorBrain()
    
    /* function: useM()
     * This function uses the variable M and updates the display
     */
    @IBAction func useM(_ sender: UIButton) {
        brain.setOperand(variable: sender.currentTitle!)
        if let result = brain.evaluate(using: variableDictionary).result {
            displayValue = result
        }
    }
    
    /* function: undo()
     *  If user is not in the middle of typing, we call brain.undo from
     * calculator brain to delete item from array and undo last operation
     * entered then update the display. 
     * Otherwise, if the user is in the middle of typing we just
     * delete the last number they typed in.
     *
     */
    
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

            display.text = digit
            if display.text == "" {
                displayValue = 0.0
                userIsInTheMiddleOfTyping = false
            }
        }
    }
    
    /* function: useM()
     * This function sets the variable M and updates the display
     */
    @IBAction func createM(_ sender: UIButton) {
        variableDictionary["M"] = displayValue
        mValue.text = String(displayValue)
        userIsInTheMiddleOfTyping = false
        if let result = brain.evaluate(using: variableDictionary).result {
            displayValue = result
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
    
    @IBOutlet weak var graphDisplay: UILabel!
    @IBAction func graphEquation(_ sender: UIButton) {
        graphDisplay.text = "Equation Graphed: y = " + String(brain.evaluate().description.characters.dropLast())
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var destinationController = segue.destination
        if let navController = destinationController as? UINavigationController {
            destinationController = navController.visibleViewController ?? destinationController
        }
        
        if let graphViewController = destinationController as? GraphViewController {
            graphViewController.convertToY = brain.evaluate
            
        }
    }
    
}

