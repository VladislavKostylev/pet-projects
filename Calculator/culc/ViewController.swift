//
//  ViewController.swift
//  culc
//
//  Created by Владислав on 10.11.2023.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        resultCalculate.text! = "Start to work!"
            // Do any additional setup after loading the view.
    
    }
    @IBOutlet weak var resultCalculate: UILabel!
    
    var isNewValue = true
    var newValue: Double = 0
    var result: Double = 0
    var operation: MathOperation? = nil
    var previousOperation: MathOperation? = nil
    
    
    @IBAction func onZero(_ sender: Any) {
        addDigit(digit: "0")
    }
    @IBAction func onOne(_ sender: Any) {
        addDigit(digit: "1")
    }
    @IBAction func onTwo(_ sender: Any) {
        addDigit(digit: "2")
    }
    @IBAction func onThree(_ sender: Any) {
        addDigit(digit: "3")
    }
    @IBAction func onFour(_ sender: Any) {
        addDigit(digit: "4")
    }
    @IBAction func onFive(_ sender: Any) {
        addDigit(digit: "5")
    }
    @IBAction func onSix(_ sender: Any) {
        addDigit(digit: "6")
    }
    @IBAction func onSeven(_ sender: Any) {
        addDigit(digit: "7")
    }
    @IBAction func onEight(_ sender: Any) {
        addDigit(digit: "8")
    }
    @IBAction func onNine(_ sender: Any) {
        addDigit(digit: "9")
    }
    
    private func addDigit(digit: String) {
        if isNewValue {
            resultCalculate.text = ""
            isNewValue = false
        }
        var digits = resultCalculate.text
        digits?.append(digit)
        resultCalculate.text = digits
    }
    private func getInteger() -> Double {
        return Double(resultCalculate.text ?? "0") ?? 0
    }

    @IBAction func onPlus(_ sender: Any) {
        operation = .sum
        previousOperation = nil
        isNewValue = true
        result = getInteger()
    }
    @IBAction func onSubtraction(_ sender: Any) {
        operation = .subtraction
        previousOperation = nil
        isNewValue = true
        result = getInteger()
    }
    @IBAction func onMultiplication(_ sender: Any) {
        operation = .multiplication
        previousOperation = nil
        isNewValue = true
        result = getInteger()
    }
    @IBAction func onDivision(_ sender: Any) {
        operation = .division
        previousOperation = nil
        isNewValue = true
        result = getInteger()
    }
    @IBAction func onEqual(_ sender: Any) {
        culculate()
    }
    @IBAction func onReset(_ sender: Any) {
        resultCalculate.text! = "Start to work!"
        isNewValue = true
        result = 0
        operation = nil
        previousOperation = nil
    }
    
    private func culculate() {
        guard let operation = operation else {
            return
        }
        if previousOperation != operation {
            newValue = getInteger()
        }
        result = operation.makeOperation(first: result, second: newValue)
        previousOperation = operation
        if (String(result)).count > 20 {
            resultCalculate.text! = "The number is too long. Start again!"
            isNewValue = true
            result = 0
            previousOperation = nil
        } else if result == Double(Int(result)) {
            resultCalculate.text! = "\(Int(result))"
        } else {
            resultCalculate.text! = "\(result)"
        }
        isNewValue = true
    }
    
    enum MathOperation {
        case sum, subtraction, multiplication, division
        func makeOperation(first: Double, second: Double) -> Double {
            switch self {
            case .sum:
                return (first + second)
            case .subtraction:
                return (first - second)
            case .multiplication:
                return (first * second)
            case .division:
                guard second != 0 else {
                    return 0
                }
                return (first / second)
                
            }
        }
        
    }
}
