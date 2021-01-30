//
//  CalculatorBrain.swift
//  calculator
//
//  Created by Shashwat on 28/01/21.
//
func changeToDouble(f:Double,s:Double)->Double{
    let res  = String(Int(f))+"."+String(Int(s))
    print(res)
    return Double(res)!
}
import Foundation
class CalculatorBrain{
    
    //MARK: final result
    internal var result=0.0
    
    //MARK: Array to keep track of operation performed
    var history = [String]()
    
    //MARK: to check if there is any binary not performed completely
    var isPartial=false
    
    //MARK: set operand equal to result
    func setOperand(operand:Double){
        result=operand
        if !history.isEmpty && history[history.count-1] == "="{
            history=[]
            
        }
        history.append(String(operand))
        
    }
    
    //MARK: enum method to define unique methods
    enum uniqueMethods{
        case unaryOperator((Double)->Double)
        case binaryOperator((Double,Double)->Double)
        case equals
        case constant(Double)
        case clearAll(Double)
    }
    
    //MARK: pending structure
    struct pendingOperation {
        var binaryOperation:(Double,Double)->Double
        var op1:Double
    }
    
    //MARK: pending instance
    var pendingInfo:pendingOperation?
    
    
    
    //MARK: dictionary containing symbol and there operations
    let operationList:Dictionary<String,uniqueMethods>=[
        "π"  :  .constant(Double.pi),
        "e"  :  .constant(3.14),
        "ln" :  .unaryOperator({return log($0)}),
        "1/x":  .unaryOperator({return 1/$0}),
        "+/-":  .unaryOperator({return -1*$0}),
        "√"  :  .unaryOperator({return sqrt($0)}),
        "tan":  .unaryOperator({return tan($0)}),
        "sin":  .unaryOperator({return sin($0)}),
        "cos":  .unaryOperator({return cos($0)}),
        "%"  :  .binaryOperator({return Double(Int($0)/Int($1))}),
        "+"  :  .binaryOperator({return $0+$1}),
        "-"  :  .binaryOperator({return $0-$1}),
        "/"  :  .binaryOperator({return $0/$1}),
        "x"  :  .binaryOperator({return $0*$1}),
        "="  :  .equals,
        "."  :  .binaryOperator({changeToDouble(f: $0, s: $1)}),
        "AC" :  .clearAll(2)
    ]
    
    //MARK: clear all reset everything to zero
    func clearAll(){
        //list=""
        result=0.0
        pendingInfo=nil
        
    }
    
    func pendingFunction(){
        if pendingInfo != nil{
            result=pendingInfo!.binaryOperation(pendingInfo!.op1,result)
            pendingInfo=nil
        }
    }
    
    //MARK: performing operation on operand
    func operation(Operator:String){
        if let symbol = operationList[Operator]{
            
            switch symbol {
            case .constant(let constant):
                result=constant
                descriptionGenerator(op: Operator)
                isPartial=false
                
            case .unaryOperator(let foo):
                result=foo(result)
                descriptionGenerator(op: Operator)
                isPartial=false
                
            case .binaryOperator(let foo):
                descriptionGenerator(op: Operator)
                isPartial=true
                pendingFunction()
                pendingInfo = pendingOperation(binaryOperation: foo, op1: result)
                
            case .equals:
                descriptionGenerator(op: Operator)
                isPartial=false
                pendingFunction()
                
            case .clearAll(_):
                isPartial=false
                history=[]
                clearAll()
                descriptionGenerator(op: Operator)
                
            }
            
        }
    }
    
    // MARK: function for description
    func descriptionGenerator(op:String){
        if op=="√" || op=="ln" || op=="tan" || op=="cos" || op=="sin" || op=="1/x" || op=="+/-"{
                if history[history.count-1]=="="{
                    history.insert("(", at: 0)
                    if op=="1/x"{
                        history.insert("1/",at: 0)
                    }else if op=="+/-"{
                        history.insert("-1x",at: 0)
                    }else{
                        history.insert(op, at: 0)
                    }
                    
                    
                    history.insert(")", at: history.count-1)
                }else{
                    if op=="1/x"{
                        history.insert("1/",at: history.count-1)
                    }else if op=="+/-"{
                        history.insert("-1x",at: history.count-1)
                    }else{
                        history.insert(op,at:history.count-1)
                    }
                    
                }
        }else if  op=="+" || op=="-" || op=="%" || op=="x" || op=="/"{
            if history[history.count-1]=="=" && !isPartial{
                history.remove(at: history.count-1)
                print(self.history)
                history.append(op)
            }else if !isPartial{
                history.append(op)
            }
           
            
        }else if op=="="{
            if history[history.count-1]=="="{
                
            }else{
                if history[history.count-1]=="+" || history[history.count-1]=="-" || history[history.count-1]=="x"{
                    history.append(String(result))
                    
                }
                history.append(op)
                
            }
        }else if op=="e" || op=="." || op=="π"{
            history.append(op)
        }
        print(self.history)
        
    }
    func descLabel()->String{
        var des=""
        print(history)
        for i in 0..<history.count{
            des=des+history[i]
        }
        return des
    }
}
