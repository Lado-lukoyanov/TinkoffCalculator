//
//  ViewController.swift
//  TinkoffCalculator
//
//  Created by Владимир  Лукоянов on 13.02.2024.
//

import UIKit

enum CalculationError: Error {
    case dividedByZero
    case rangeOverflow

}

enum Operation: String {
    case add = "+"
    case substract = "-"
    case multiple = "x"
    case divide = "/"
    
    func calculate(_ number1: Double, _ number2: Double) throws -> Double {
        switch self {
        case .add:
            return number1 + number2
        case .substract:
            return number1 - number2
        case .multiple:
            return number1 * number2
        case .divide:
            if number2 == 0 {
                throw CalculationError.dividedByZero
            }
            return number1 / number2
        }
    }
}

enum CalculationHistoryItem {
    case number(Double)
    case operation(Operation)
}

class ViewController: UIViewController {
    
    @IBAction func buttonText(_ sender: UIButton) {
        guard let buttonText = sender.currentTitle else { return }
        if buttonText == "," && label.text?.contains(",") == true {
            return
        }
        
        if label.text == "0" {
            label.text = buttonText
        } else {
            label.text?.append(buttonText)
        }
     }
    
    @IBAction func operationButtonText(_ sender: UIButton) {
        guard
            let buttonText = sender.currentTitle,
            let buttomOperation = Operation(rawValue: buttonText)
            else { return }
        
        guard
            let labelText = label.text,
            let labelNumber = numberFormatter.number(from: labelText)?.doubleValue
            else { return }
        
        calculationHistoryItem.append(.number(labelNumber))
        calculationHistoryItem.append(.operation(buttomOperation))
        resultLabelText()
    }
    
    @IBAction func clearButtonText() {
        calculationHistoryItem.removeAll()
        
        resultLabelText()
    }
    
    @IBAction func calculateButtonText() {
        guard
            let labelText = label.text,
            let labelNumber = numberFormatter.number(from: labelText)?.doubleValue
            else { return }
        
        calculationHistoryItem.append(.number(labelNumber))
        
        do {
            
            let result = try calculate()
        
            label.text = numberFormatter.string(from: NSNumber(value: result))
            
        } catch {
        
            label.text = "Ошибка"
            
        }
        
        calculationHistoryItem.removeAll()
    }
    
    @IBOutlet weak var label: UILabel!
    
    var calculationHistoryItem: [CalculationHistoryItem] = []

    lazy var numberFormatter: NumberFormatter = {
        let numberFormatter = NumberFormatter()
        
        numberFormatter.usesGroupingSeparator = false
        numberFormatter.locale = Locale(identifier: "ru_RU")
        numberFormatter.numberStyle = .decimal
         
        return numberFormatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resultLabelText()
    }
    
    func calculate() throws -> Double {
        guard case .number(let firstNumber) = calculationHistoryItem[0] else { return 0}
        
        var currentResult = firstNumber
        
        for index in stride(from: 1, to: calculationHistoryItem.count - 1, by: 2) {
            guard
                case .operation(let operation) = calculationHistoryItem[index],
                case .number(let number) = calculationHistoryItem[index + 1]
            else { break }
            
            currentResult = try operation.calculate(currentResult, number)
            
            if currentResult > Double.greatestFiniteMagnitude {
                throw CalculationError.rangeOverflow
                
            }
        }
        
        return currentResult
    }
    
    func resultLabelText() {
        label.text = "0"
    }

}

