//
//  DMRURLProtocol.swift
//  DMRProxyServer
//
//  Created by DMR on 2019/12/20.
//

import UIKit

class DMRURLProtocol: URLProtocol {

    static let DMRURLProtocolKey = "DMRURLProtocolKey"

    private var dataTask:URLSessionDataTask?
    
    static var host: String?
    static var port: Int?

    /// 确定协议子类是否可以处理指定的请求。
    override class func canInit(with request: URLRequest) -> Bool {
        guard let url = request.url else { return false }
        
        guard let scheme = url.scheme?.lowercased() else { return  false }
        
        guard scheme == "http" || scheme == "https" else { return false}
        // 发现是处理过的请求直接返回No不拦截此请求
        if let _ = URLProtocol.property(forKey:DMRURLProtocolKey, in: request) {
            return false
        }
        return true
    }

    /// 返回指定请求的规范版本
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    /// 启动特定于协议的请求加载
    override func startLoading() {
        
        // 放行Request添加一个键值标记为YES,防止♻️
        URLProtocol.setProperty(true, forKey: DMRURLProtocol.DMRURLProtocolKey, in: request as! NSMutableURLRequest)
       //复制一份获取拦截的请求
       URLSession.shared.dataTask(with: request) { (data, res, err) in
           self.client?.urlProtocol(self, didLoad: data!)
           self.client?.urlProtocol(self, didReceive: res!, cacheStoragePolicy: .notAllowed)
           self.client?.urlProtocol(self, didFailWithError: err!)
           self.client?.urlProtocolDidFinishLoading(self)
       }.resume()
    }
    
    /// 停止特定于协议的请求加载
    override func stopLoading() {
        dataTask?.cancel()
    }
}



extension DMRURLProtocol: URLSessionDataDelegate {
    func urlSession(_ session: URLSession,
          didReceive dataTask: URLSessionDataTask,
                     response: URLResponse,
            completionHandler: (URLSession.ResponseDisposition) -> Void)  {
        client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        completionHandler(.allow)
    }
}

extension DMRURLProtocol: URLSessionTaskDelegate {
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if error != nil && error!._code != NSURLErrorCancelled {
            client?.urlProtocol(self, didFailWithError: error!)
        } else {
            client?.urlProtocolDidFinishLoading(self)
        }
    }
}
