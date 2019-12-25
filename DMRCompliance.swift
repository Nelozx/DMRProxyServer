//
//  DMRCompliance.swift
//  ProxyHTTP
//
//  Created by DMR on 2019/12/25.
//  Copyright © 2019 Alistar. All rights reserved.
//

import UIKit


struct DMRCompliance {
    
    
    /// 是否符合网络ip的规则
    /// - Parameter ip: ipv4
    static func compliance(ip: String) -> Bool {
        let  regex = "^(1\\d{2}|2[0-4]\\d|25[0-5]|[1-9]\\d|[1-9])\\.(1\\d{2}|2[0-4]\\d|25[0-5]|[1-9]\\d|\\d)\\.(1\\d{2}|2[0-4]\\d|25[0-5]|[1-9]\\d|\\d)\\.(1\\d{2}|2[0-4]\\d|25[0-5]|[1-9]\\d|\\d)$"
        return compliance(ip, regex)
    }
    
    
    /// 是否符合网络端口的规则
    /// - Parameter port: 端口(0 ～ 65535)
    static func compliance(port: String) -> Bool {
        let  regex = "^([1-9][0-9]{0,3}|[1-5][0-9]{4}|6[0-4][0-9]{3}|65[0-4][0-9]{2}|655[0-2][0-9]{1}|6553[0-5])$"
        return compliance(port, regex)
    }
    
    
    /// 是否符合某种的规则
    /// - Parameters:
    ///   - match: 需要判断的
    ///   - regex: 正则表达式
    private static func compliance(_ match: String,_ regex: String) -> Bool {
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: match)
    }
    
}
