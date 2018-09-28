//
//  ViewController.swift
//  tooskie-ios
//
//  Created by Antoine Hoorelbeke on 26/09/2018.
//  Copyright © 2018 Antoine Hoorelbeke. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBOutlet weak var label: UILabel!
    
    @IBAction func changeLabel(_ sender: Any) {
        let number = Int.random(in: 0 ..< 2)
        let tab = ["poulet", "cc"]
        label.text = tab[number]
    }
}

