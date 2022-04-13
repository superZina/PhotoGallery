//
//  ViewController.swift
//  test
//
//  Created by 이진하 on 2021/09/05.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let popGestureRecognizer = self.navigationController!.interactivePopGestureRecognizer!
            if let targets = popGestureRecognizer.value(forKey: "targets") as? NSMutableArray {
                let gestureRecognizer = UIPanGestureRecognizer()
                gestureRecognizer.setValue(targets, forKey: "targets")
                gestureRecognizer.set
                self.view.addGestureRecognizer(gestureRecognizer)
            }
        UIGestureRecognizer()
    }


}

