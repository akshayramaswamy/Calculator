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
    
    
    let maxValue = Int.max //constant that represents maximum possible value, used later when setting order of operations
    private var accumulator: Double?
    
    var resultIsPending: Bool {
        get{
            return pendingBinaryOperation != nil
        }
    }
    
    //private var so that public cannot change order precedence
    private var description: String?{
        didSet {
            if pendingBinaryOperation == nil {
                currOrder = maxValue //currOrder helps us place parathentheses in the right order in the display
            }
        }
    }
    
    /* ComputedValue: accumulatedDescription
     * This public var returns the current description with an
     * '=' if the result is no longer pending, otherwise it
     * returns the partial description with '...'
     *
     */
    var accumulatedDescription: String? {
        get {
            if !resultIsPending {
                if description != nil {
                    return description! + "="
                } else {
                    return " " //in the case where the calculator is cleared
                }
            } else {
                 let partialDescription = pendingDescription!.currDescription
                if partialDescription != description {
                    return pendingDescription!.functionDescription(partialDescription,description!) + "..."
                } else {
                    return pendingDescription!.functionDescription(partialDescription," ") + "..."
                }
            }
            
        }
    }
    
    //currOrder helps us place parathentheses in the right order in the display. Set to max Int value intially
    private var currOrder = Int.max
    
    
    private enum Operation{
        case constant(Double) //associated value - just like optional, which is also an enum
        case unaryOperation((Double)->Double, (String) -> String)
        case binaryOperation((Double,Double)->Double, (String, String) -> String, Int)
        case equals
        
    }
    
    /* Each operation has varied numnber of associated
     * values depending on what type of operation it is.
     * Constant operations only take in one associated value
     * (the constant).
     * Unary operations take in 2 asscoaited values --
     * one representing the operation taking place,
     * and a second that has the string representation for the
     * calculator display.
     * Binary operations take in 3 associated values -- one for
     * the operation, one for the string representation, and
     * third that keeps track of the order for paraentheses
     */
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
            case .unaryOperation(let function, let functionDescription):
                if accumulator != nil {
                    accumulator = function(accumulator!)
                    description = functionDescription(description!) // passes description as arg to associated function in operations
                }
            case .binaryOperation(let function, let functionDescription, let order):
                performPendingBinaryOperation()
                if order > currOrder  {
                    description = "(" + description! + ")" //sets parentheses based on order precedence
                }
                
                currOrder = order
                //sets the first operand for the calculator description to the current description
                pendingDescription = PendingDescription(currDescription: description!,functionDescription: functionDescription)
                if accumulator != nil{
                    // sets the first operand for the binary operation
                    pendingBinaryOperation = PendingBinaryOperation(function: function, firstOperand: accumulator!)
                    accumulator = nil
                }
                
            case .equals:
                performPendingBinaryOperation()
                
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
    
    /* struct: Pending Description:
     * This struct mirrors PendingBinaryOperation, in that returns the associated value string representation for a binary operation,
     * but for the description display in the calculator. The first operand is the description set aftet the first operand was entered,
     * and the second operand is the value entered by the user (passed as description)
     */
    private struct PendingDescription {
        let currDescription: String
        let functionDescription: (String, String) -> String
        func perform(with secondOperand: String) -> String{
            return functionDescription(currDescription, String(secondOperand))
            
        }
    }
    
    /* struct: Pending Binary Operation:
     * This struct returns the associated value for a binary operation. The first operand is stored when the first operand is entered,
     * and the second operand is the accumulator passed from above
     */
    private struct PendingBinaryOperation{
        let function: (Double,Double) -> Double
        let firstOperand: Double
        
        func perform(with secondOperand: Double) -> Double{
            return function(firstOperand, secondOperand)
        }
        
    }
    
    mutating func setOperand(_ operand: Double) {
        accumulator = operand
        description = String(operand)
    }
    func setOperand(variable named: String) {
        
    }
    func evaluate(using variables: Dictionary<String,Double>? = nil) -> (result: Double?, description: String){
            
    }
    
    var result: Double? {
        get{
            return accumulator
        }
    }
    
}
