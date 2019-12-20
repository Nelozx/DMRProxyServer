//
//  ConnectionProxy.swift
//  AliveAgent
//
//  Created by DMR on 2019/12/11.
//  Copyright © 2019 Alistar. All rights reserved.
//

import UIKit


enum ProxyPoolType: String {
    case http = "HTTP"
    case https = "HTTPS"
    case socks = "SOCKS"
}

class ProxyPool: NSObject {
    private var enableKey, proxyKey, portKey: String?
    private(set) var host: String?
    private(set) var port: Int?
    private(set) var type: ProxyPoolType?
    private(set) var pool: [String: Any]?
    
    init(_ host: String, _ port: Int, type: ProxyPoolType) {
        print("[ProxyPool]:\(host):\(port) ====>\(type)")
        super.init()
        self.host = host; self.port = port; self.type = type
        configKey(type)
        pool = [
            enableKey! : true,
            proxyKey! : host,
            portKey! : port,
        ]
    }
    private func configKey(_ type: ProxyPoolType) {
        switch type {
        case .http:
            enableKey = "HTTPEnable"
            proxyKey  = "HTTPProxy"
            portKey   = "HTTPPort"
            break
        case .https:
            enableKey = "HTTPSEnable"
            proxyKey  = "HTTPSProxy"
            portKey   = "HTTPSPort"
            break
            
        case .socks:
            enableKey = "SOCKSEnable"
            proxyKey  = "SOCKSProxy"
            portKey   = "SOCKSPort"
            break
        }
    }
}


extension URLSessionConfiguration{
    class func proxy(_ ip: String,_ port: Int, _ type: ProxyPoolType = .socks) -> URLSessionConfiguration{
        let proxyPool = ProxyPool(ip, port, type: type)
        let config = URLSessionConfiguration.default
        config.connectionProxyDictionary = proxyPool.pool
        return config
    }
    

}




