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
    private var accumulator: Double?
    
    private enum Operation{
        case constant(Double) //assciated value - just like optional, which is also an enum
        case unaryOperation((Double)->Double)
        case binaryOperation((Double,Double)->Double)
        case equals
        
    }
    
    private var operations: Dictionary<String, Operation> = [
    "π": Operation.constant(Double.pi),
    "e": Operation.constant(M_E),
    "√": Operation.unaryOperation(sqrt),
    "cos": Operation.unaryOperation(cos),
    "±": Operation.unaryOperation({-$0}),
    "x": Operation.binaryOperation({$0 * $1}),
    "+": Operation.binaryOperation({$0 + $1}),
    "-": Operation.binaryOperation({$0 - $1}),
    "÷": Operation.binaryOperation({$0 / $1}),
    "sin": Operation.unaryOperation(sin),
    "tan": Operation.unaryOperation(tan),
    "x²": Operation.unaryOperation({pow($0, 2)}),
    "x³": Operation.unaryOperation({pow($0, 3)}),
    "xʸ": Operation.binaryOperation(pow),
    "=": Operation.equals
    ]
    mutating func performOperation (_ symbol: String){
        if let operation = operations[symbol]{
            switch operation{
            case .constant(let value):
                accumulator = value
            case .unaryOperation(let function):
                if accumulator != nil {
                    accumulator = function(accumulator!)
                }
            case .binaryOperation(let function):
                if accumulator != nil{
                    pendingBinaryOperation = PendingBinaryOperation(function: function, firstOperand: accumulator!)
                    accumulator = nil
                }
                
            case .equals:
                performPendingBinaryOperation()
                
            }
            
            
        }
    }
    
    private mutating func performPendingBinaryOperation(){
        if pendingBinaryOperation != nil && accumulator != nil {
            accumulator = pendingBinaryOperation!.perform(with: accumulator!)
            pendingBinaryOperation = nil
            
        }
    }
    private var pendingBinaryOperation: PendingBinaryOperation?
    private struct PendingBinaryOperation{
        let function: (Double,Double) -> Double
        let firstOperand: Double
        
        func perform(with secondOperand: Double) -> Double{
            return function(firstOperand, secondOperand)
        }
        
    }
    
    mutating func setOperand(_ operand: Double) {
        accumulator = operand
    }
    
    var result: Double? {
        get{
           return accumulator
        }
    }
    
}
