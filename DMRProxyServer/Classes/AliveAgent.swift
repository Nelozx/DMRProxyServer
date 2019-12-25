//
//  AliveIP.swift
//  ProxyHTTP
//
//  Created by DMR on 2019/12/16.
//  Copyright © 2019 Alistar. All rights reserved.
//

import UIKit

// http://captive.apple.com/
fileprivate let LinkTest = "https://www.baidu.com/"

class AliveAgent: NSObject {
    
    class func alive(_ ip: String, _ port: Int, type: ProxyPoolType) -> Bool {
        // 使用信号量实现NSURLSession同步请求
        let semaphore = DispatchSemaphore(value: 0)
        var result = false
        let config = URLSessionConfiguration.proxy(ip, port, type)
        let session = URLSession(configuration: config)
        let req  = URLRequest(url: URL(string: LinkTest)!, cachePolicy: URLRequest.CachePolicy.reloadIgnoringCacheData, timeoutInterval: 1)
        
        session.dataTask(with: req) { (data, res, err) in
            guard let res = res else {
                return
            }
            
            let response = res as! HTTPURLResponse
            result = (response.statusCode == 200) ? true : false
            semaphore.signal()
        }.resume()
        semaphore.wait()
        return result
    }
}
