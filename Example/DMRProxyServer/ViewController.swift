//
//  ViewController.swift
//  DMRProxyServer
//
//  Created by NELO on 12/19/2019.
//  Copyright (c) 2019 NELO. All rights reserved.
//

import UIKit
import DMRProxyServer


class ViewController: UIViewController {

    @IBOutlet weak var ipTF: UITextField!
    @IBOutlet weak var portTF: UITextField!
    @IBOutlet weak var showLbl: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // 注册
//        URLProtocol.registerClass(DMRURLProtocol.self)
        
        portTF.delegate = self
        ipTF.delegate = self
        
        let ip = "223.241.119.16"
        let port = 9999
        self.ipTF.text = ip
        self.portTF.text = "\(port)"
        
        // 默认使用无代理加载目标主机
        load(config: URLSessionConfiguration.default)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func actionConnect(_ sender: Any) {
        if ipTF.text?.lengthOfBytes(using: .utf8) == 0 ||
        portTF.text?.lengthOfBytes(using: .utf8) == 0  {
            load(config: URLSessionConfiguration.default)
        } else {
            load(config: URLSessionConfiguration.default)
//            loadForProxy(ipTF.text!, Int(portTF.text!)!, .https)
        }
    }
}


extension ViewController {
    
    func loadForProxy(_ ip: String , _ port: Int ,_ type: ProxyServerType) {
        let config = URLSessionConfiguration.proxy(ip, port, type)
        load(config: config)
    }
    func load(config: URLSessionConfiguration) {
        
        self.title = "Loading......"
        // http://ip111.cn/
        let url = URL(string: "https://ip.cn/")
        let req = URLRequest(url: url!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        
        let session = URLSession(configuration: config)
        
        session.dataTask(with: req) { (data, res, err) in
            
            if let data = data {
                let content = String(data: data, encoding: .utf8)
                
                print(content ?? "NO DATA")
                DispatchQueue.main.async {
                    self.showLbl.text = content
                    self.title = "Loading Success"
                    
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
                        self.title = "Agent"
                        
                    }
                    //                    self.webView.loadHTMLString(content ?? "NO DATA", baseURL: nil)
                }
            } else {
                DispatchQueue.main.async {
                    self.title = "Loading Failed"
                }
                
            }
            
        }.resume()
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

}

extension ViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == ipTF {
            
            if DMRCompliance.compliance(ip: textField.text!) == false {
                textField.text = nil
                textField.placeholder = "IP格式不正确"
                return
            }
        }
    
        if (textField == portTF) {
            if DMRCompliance.compliance(port: textField.text!) == false {
                textField.placeholder = "Port格式不正确"
                textField.text = nil
                return
                
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
}



