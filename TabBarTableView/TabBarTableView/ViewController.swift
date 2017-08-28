//
//  ViewController.swift
//  TabBarTableView
//
//  Created by 杨国盛 on 2017/8/24.
//  Copyright © 2017年 yanggs. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let tabbarTableView = TabBarTableView.init(frame: self.view.bounds, items: ["hehe","xixi","lala"]);
        self.view .addSubview(tabbarTableView);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

