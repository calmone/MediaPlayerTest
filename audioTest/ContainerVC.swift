//
//  File.swift
//  audioTest
//
//  Created by Taehyeon Han on 2018. 7. 13..
//  Copyright © 2018년 Taehyeon Han. All rights reserved.
//

import Foundation
import UIKit

class ContainerVC: UIViewController, UIGestureRecognizerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cvc = UINavigationController(rootViewController: MainVC())
        self.view.addSubview(cvc.view)
        addChildViewController(cvc)
        self.didMove(toParentViewController: cvc)
        cvc.navigationBar.isHidden = true
        // Do any additional setup after loading the view.
        
        cvc.interactivePopGestureRecognizer?.delegate = self
        cvc.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
