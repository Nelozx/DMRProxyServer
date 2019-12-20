//
//  DMRURLProtocol.swift
//  DMRProxyServer
//
//  Created by DMR on 2019/12/20.
//

import UIKit

class DMRURLProtocol: URLProtocol {
    

    static let DMRHttpProxyProtocolKey = "DMRHttpProxyProtocolKey"

    private var dataTask:URLSessionDataTask?

    override class func canInit(with request: URLRequest) -> Bool {
        guard let url = request.url else { return false }
        
        guard let scheme = url.scheme?.lowercased() else { return  false }
        
        guard scheme == "http" || scheme == "https" else { return false}
        
        if let _ = URLProtocol.property(forKey:DMRHttpProxyProtocolKey, in: request) {
            return false
        }
        return true

    }

    // 处理request
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    // 请求进行重发，设置URLSessionConfigration，生成URLSession请求
    override func startLoading() {
        
        let reRequest = request as! NSMutableURLRequest
        URLProtocol.setProperty(true, forKey: type(of: self).DMRHttpProxyProtocolKey, in: reRequest)
        let proxyPool = ProxyPool("dddddd", 9999, type: .https)
        let config = URLSessionConfiguration.ephemeral
        config.connectionProxyDictionary = proxyPool.pool
        let session =  URLSession(configuration: config, delegate: self as URLSessionDelegate, delegateQueue: nil)
        
        dataTask = session.dataTask(with:reRequest as URLRequest)
        dataTask!.resume()
    }
    
    
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
