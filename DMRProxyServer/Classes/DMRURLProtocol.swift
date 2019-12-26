//
//  DMRURLProtocol.swift
//  DMRProxyServer
//
//  Created by DMR on 2019/12/20.
//

import UIKit



/// NSURLProtocol可以劫持系统所有基于C socket的网络请求
/**
 * 重定向网络请求（可以解决电信的DNS域名劫持问题）
 * 忽略网络请求，使用本地缓存
 * 自定义网络请求的返回结果Response
 * 拦截图片加载请求，转为从本地文件加载
 * 一些全局的网络请求设置
 * 快速进行测试环境的切换
 * 过滤掉一些非法请求
 * 网络的缓存处理（H5离线包 和 网络图片缓存）
 * 可以拦截UIWebView，基于系统的NSURLConnection或者NSURLSession进行封装的网络请求。目前WKWebView无法被NSURLProtocol拦截。
 * 当有多个自定义NSURLProtocol注册到系统中的话，会按照他们注册的反向顺序依次调用URL加载流程。当其中有一个NSURLProtocol拦截到请求的话，后续的NSURLProtocol就无法拦截到该请求。
 */
open class DMRURLProtocol: URLProtocol {

    static let DMRURLProtocolKey = "DMRURLProtocolKey"

    private var dataTask:URLSessionDataTask?
    
    static var host: String?
    static var port: Int?

    /// 确定协议子类是否可以处理指定的请求。
    override open class func canInit(with request: URLRequest) -> Bool {
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
    override open class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    /// 启动特定于协议的请求加载
    override open func startLoading() {
        // 放行Request添加一个键值标记为YES,防止♻️
        URLProtocol.setProperty(true, forKey: DMRURLProtocol.DMRURLProtocolKey, in: request as! NSMutableURLRequest)
        //复制一份获取拦截的请求
        URLSession.shared.dataTask(with: request) { (data, res, err) in
            guard let data = data, let res = res, let err = err else {
               return
            }
            self.client?.urlProtocol(self, didLoad: data)
            self.client?.urlProtocol(self, didReceive: res, cacheStoragePolicy: .notAllowed)
            self.client?.urlProtocol(self, didFailWithError: err)
            self.client?.urlProtocolDidFinishLoading(self)
            
        }.resume()

    }
    
    /// 停止特定于协议的请求加载
    override open func stopLoading() {
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
    public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if error != nil && error!._code != NSURLErrorCancelled {
            client?.urlProtocol(self, didFailWithError: error!)
        } else {
            client?.urlProtocolDidFinishLoading(self)
        }
    }
}
