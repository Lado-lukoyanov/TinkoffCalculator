//
//  ViewController.swift
//  TinkoffCalculator
//
//  Created by Владимир  Лукоянов on 13.02.2024.
//

import UIKit

class ViewController: UIViewController {
    
    @IBAction func buttonText(_ sender: UIButton) {
        guard let buttonText = sender.currentTitle else {
            return
            
        }
        print(buttonText)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }


}

