//
//  H5WebViewController.swift
//  DanaPinjol
//
//  Created by hekang on 2026/3/17.
//

import UIKit
import SnapKit
import WebKit
import StoreKit

class H5WebViewController: BaseViewController {
    
    var pageUrl: String = ""
    
    lazy var bgImageView: UIImageView = {
        let bgImageView = UIImageView()
        bgImageView.image = UIImage(named: "app_bg_image")
        return bgImageView
    }()
    
    lazy var webView: WKWebView = {
        let configuration = WKWebViewConfiguration()
        configuration.userContentController = WKUserContentController()
        
        configuration.userContentController.add(self, name: "roomenne")
        configuration.userContentController.add(self, name: "cauliagencyship")
        configuration.userContentController.add(self, name: "pedien")
        configuration.userContentController.add(self, name: "totalsome")
        configuration.userContentController.add(self, name: "archeoid")
        
        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.navigationDelegate = self
        webView.uiDelegate = self
        webView.allowsBackForwardNavigationGestures = true
        webView.scrollView.showsVerticalScrollIndicator = false
        return webView
    }()
    
    lazy var progressView: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .default)
        progressView.progressTintColor = UIColor.init(hexString: "#FAE351")
        progressView.trackTintColor = .clear
        progressView.isHidden = true
        return progressView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(bgImageView)
        bgImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        setupHeadUI()
        setupWebView()
        loadUrl()
        
        webView.addObserver(self, forKeyPath: "title", options: [.new], context: nil)
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: [.new], context: nil)
    }
    
    private func loadUrl() {
        if let url = URL(string: URLParameterHelper.shared.getFullURL(baseURL: pageUrl)) {
            webView.load(URLRequest(url: url))
        }
    }
    
    @MainActor
    deinit {
        webView.removeObserver(self, forKeyPath: "title")
        webView.removeObserver(self, forKeyPath: "estimatedProgress")
        webView.configuration.userContentController.removeAllScriptMessageHandlers()
    }
}

extension H5WebViewController {
    
    private func setupHeadUI() {
        view.addSubview(headView)
        headView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview()
            make.height.equalTo(44)
        }
        
        headView.onBackButtonTapped = { [weak self] in
            if self?.webView.canGoBack == true {
                self?.webView.goBack()
            } else {
                self?.toOrderListPage()
            }
        }
    }
    
    private func setupWebView() {
        view.addSubview(webView)
        view.addSubview(progressView)
        
        webView.snp.makeConstraints { make in
            make.top.equalTo(headView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
        
        progressView.snp.makeConstraints { make in
            make.top.equalTo(headView.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(2)
        }
    }
}

extension H5WebViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        progressView.isHidden = false
        progressView.setProgress(0.1, animated: true)
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        if let title = webView.title {
            headView.confilgTitle(title)
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        progressView.setProgress(1.0, animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            self?.progressView.isHidden = true
        }
        
        if let title = webView.title {
            headView.confilgTitle(title)
        }
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        progressView.isHidden = true
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        progressView.isHidden = true
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        decisionHandler(.allow)
    }
}

extension H5WebViewController: WKUIDelegate {
    
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if navigationAction.targetFrame == nil {
            webView.load(navigationAction.request)
        }
        return nil
    }
}

extension H5WebViewController: WKScriptMessageHandler {
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
        switch message.name {
        case "roomenne":
            handleRoomenne(message.body)
            
        case "cauliagencyship":
            handleCauliagencyship()
            
        case "pedien":
            handlePedien()
            
        case "totalsome":
            handleTotalsome(message.body)
            
        case "archeoid":
            handleArcheoid()
            
        default:
            print("Unknown message: \(message.name)")
        }
    }
}

extension H5WebViewController {
    
    private func handleRoomenne(_ body: Any) {
        print("handleRoomenne called with: \(body)")
    }
    
    private func handleCauliagencyship() {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func handlePedien() {
        NotificationCenter.default.post(name: CHANGE_ROOT_VC, object: nil)
    }
    
    private func handleTotalsome(_ body: Any) {
        
    }
    
    private func handleArcheoid() {
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }
}

extension H5WebViewController {
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "title" {
            if let title = webView.title {
                headView.confilgTitle(title)
            }
        } else if keyPath == "estimatedProgress" {
            let progress = Float(webView.estimatedProgress)
            progressView.progress = progress
            
            if progress >= 1.0 {
                progressView.isHidden = true
            } else if progressView.isHidden {
                progressView.isHidden = false
            }
        }
    }
}
