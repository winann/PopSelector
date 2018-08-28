//
//  ViewController.swift
//  PopSelector
//
//  Created by winann on 08/27/2018.
//  Copyright (c) 2018 winann. All rights reserved.
//

import UIKit
import PopSelector

class ViewController: UIViewController, WillShowPopSelector {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func showAction(_ sender: UIButton) {
        let models = ["录租房", "录二手房"].map { (str) -> ContentModel in
            var model = ContentModel()
            model.title = str
            model.image = UIImage(named: str)
            return model
        }
        showSelector(from: self, models: models, callBack: { seleceModel in
            
        })
    }
}

