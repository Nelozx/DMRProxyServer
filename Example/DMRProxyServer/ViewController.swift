//
//  ViewController.swift
//  DMRProxyServer
//
//  Created by NELO on 12/19/2019.
//  Copyright (c) 2019 NELO. All rights reserved.
//

import UIKit
import DMRProxyServer

func log(message: String,
         function: String = #function,
         file: String = #file,
         line: Int = #line) {
    
    print("Message \"\(message)\" (File: \(file), Function: \(function), Line: \(line))")
}



class ViewController: UIViewController {
    
    
    @IBOutlet weak var ipTF: UITextField!
    @IBOutlet weak var portTF: UITextField!
    @IBOutlet weak var showLbl: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension ViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
//        if textField == ipTF {
//            
//            if DMRCompliance.compliance(ip: textField.text!) == false {
//                textField.text = nil
//                textField.placeholder = "IP格式不正确"
//                return
//            }
//        }
//    
//        if (textField == portTF) {
//            if DMRCompliance.compliance(port: textField.text!) == false {
//                textField.placeholder = "Port格式不正确"
//                textField.text = nil
//                return
//                
//            }
//        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
}



