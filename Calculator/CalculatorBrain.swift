//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Akshay Ramaswamy on 1/14/17.
//  Copyright © 2017 Akshay Ramaswamy. All rights reserved.
//

//no UI kit b/c no view here (this is the model)
import Foundation



struct CalculatorBrain {
    //struct instead of class 
    //classes have inheritance, structs do not
    //classes live in the heap, structs are not (copied by value)
    
    //internal var
    let maxValue = Int.max
    private var accumulator: Double?
    private var resultIsPending = false
    
    
    var description: String?{
        didSet {
            if pendingBinaryOperation == nil {
                currOrder = maxValue
            }
        }
    }
    var accumulatedDescription:String?
    //var accumulatedDescription: String {
      //  get {
       //     if pendingBinaryOperation == nil {
       //         return description
       //     } else {
       //         return pendingDescription!.functionDescription(String(pendingDescription!.firstOperand), String(pendingDescription!.firstOperand) != description ? /description : "")
       //     }
       // }
    //}

    private var currOrder = Int.max
    
    private enum Operation{
        case constant(Double) //assciated value - just like optional, which is also an enum
        case unaryOperation((Double)->Double, (String) -> String)
        case binaryOperation((Double,Double)->Double, (String, String) -> String, Int)
        case equals
        
    }
    
    private var operations: Dictionary<String, Operation> = [
    "π": Operation.constant(Double.pi),
    "e": Operation.constant(M_E),
    "√": Operation.unaryOperation(sqrt, { "√(\($0))"} ),
    "cos": Operation.unaryOperation(cos, {"cos(\($0))"}),
    "±": Operation.unaryOperation({-$0}, {"-(\($0))"}),
    "x": Operation.binaryOperation({$0 * $1}, { "\($0) x \($1)"}, 1),
    "+": Operation.binaryOperation({$0 + $1}, { "\($0) + \($1)"}, 1),
    "-": Operation.binaryOperation({$0 - $1}, { "\($0) - \($1)"}, 0),
    "÷": Operation.binaryOperation({$0 / $1}, { "\($0) ÷ \($1)"}, 0),
    "sin": Operation.unaryOperation(sin, {"sin(\($0))"}),
    "tan": Operation.unaryOperation(tan, {"tan(\($0))"}),
    "x²": Operation.unaryOperation({pow($0, 2)}, {"(\($0))²"}),
    "x³": Operation.unaryOperation({pow($0, 3)}, {"(\($0))³"}),
    "xʸ": Operation.binaryOperation(pow, { "\($0) ^ \($1)"}, 2),
    "=": Operation.equals
    ]
    mutating func performOperation (_ symbol: String){
        if let operation = operations[symbol]{
            switch operation{
            case .constant(let value):
                
                accumulator = value
                description = symbol
                //performPendingDescription()
                
            case .unaryOperation(let function, let functionDescription):
                
                if accumulator != nil {
                    accumulator = function(accumulator!)
                    
                    
                }
                description = functionDescription(description!)
                //performPendingDescription()
            case .binaryOperation(let function, let functionDescription, let order):
                performPendingBinaryOperation()
                //performPendingDescription()
                if order > currOrder  {
                    description = "(" + description! + ")"
                }
                //description = functionDescription(description)
                currOrder = order
                pendingDescription = PendingDescription(currDescription: description!,functionDescription: functionDescription)
                if accumulator != nil{
                    pendingBinaryOperation = PendingBinaryOperation(function: function, firstOperand: accumulator!)
                    
                    
                    
                    accumulator = nil
                }
                
            case .equals:
                performPendingBinaryOperation()
                //performPendingDescription()
                
            }
            
            
        }
    }

    
    private mutating func performPendingBinaryOperation(){
        if pendingDescription != nil {
            description = pendingDescription!.perform(with: description!)
            pendingDescription = nil
            
        }
        if pendingBinaryOperation != nil && accumulator != nil {
            accumulator = pendingBinaryOperation!.perform(with: accumulator!)
          
            pendingBinaryOperation = nil
            
            
        }
        

    }
    private var pendingBinaryOperation: PendingBinaryOperation?
    private var pendingDescription: PendingDescription?
    
     private struct PendingDescription {
        let currDescription: String
        //let firstOperand: Double
        let functionDescription: (String, String) -> String
        func perform(with secondOperand: String) -> String{
            //description = functionDescription(firstOperand, secondOperand)

                return functionDescription(currDescription, String(secondOperand))
            

        }
    }
    private struct PendingBinaryOperation{
        let function: (Double,Double) -> Double
        let firstOperand: Double
 
        func perform(with secondOperand: Double) -> Double{
            //description = functionDescription(firstOperand, secondOperand)
            return function(firstOperand, secondOperand)
        }
        
    }
    
    mutating func setOperand(_ operand: Double) {
        accumulator = operand
        description = String(operand)
    }
    
    var result: Double? {
        get{
           return accumulator
        }
    }
    
}
