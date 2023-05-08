//
//  ViewController.swift
//  bitemecokr
//
//  Created by 위트플러스 on 2023/03/01.
//

import UIKit
import WebKit;
import FirebaseMessaging

class ViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {
    
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var networkerror: UIImageView!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnHome: UIButton!
    @IBOutlet weak var btnLogo: UIButton!
    //var webView: WKWebView!
    @IBOutlet weak var subView: UIView!
    var popupWebView: WKWebView!
    var isFirstRun = true
    var url: URL?
    var urlString: String?
    
    
    
    @IBAction func actBtnBack(_ sender: Any) {
        
       /* let url = URL(string: strBackUrl)
        let request = URLRequest(url: url!)
        self.webView.load(request)*/
        viewClose()
    }
    @IBAction func actBtnLogo(_ sender: Any) {
        
        let url = URL(string: strLogoUrl)
        let request = URLRequest(url: url!)
        self.webView.load(request)
        viewClose()
    }
    @IBAction func actBtnHome(_ sender: Any) {
        
        let url = URL(string: strLogoUrl)
        let request = URLRequest(url: url!)
        self.webView.load(request)
       // self.webView.evaluateJavaScript(strHomeUrl)
        viewClose()
    }
    override func loadView() {
     
        super.loadView()
        webView.configuration.allowsInlineMediaPlayback = false
        webView.configuration.preferences.javaScriptEnabled = true
        webView.configuration.preferences.javaScriptCanOpenWindowsAutomatically = true
        
        webView.uiDelegate = self
        webView.navigationDelegate = self
        // 밀어서 뒤로가기 기능 추가
        webView.allowsBackForwardNavigationGestures = true
        self.topView.isHidden = true
        self.topView.layer.addBorder([.bottom], color: UIColor.lightGray    , width: 1.0)
        webView.scrollView.bounces = false
        webView.isOpaque = false;
        webView.backgroundColor = UIColor.white
        
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        if #available(iOS 13.0, *) {
//            print("ios 13.0");
            let app = UIApplication.shared
            let statusBarHeight: CGFloat = app.statusBarFrame.size.height

            let statusbarView = UIView()
            statusbarView.backgroundColor = UIColor.black
            view.addSubview(statusbarView)

            statusbarView.translatesAutoresizingMaskIntoConstraints = false
            statusbarView.heightAnchor
                .constraint(equalToConstant: statusBarHeight).isActive = true
            statusbarView.widthAnchor
                .constraint(equalTo: view.widthAnchor, multiplier: 1.0).isActive = true
            statusbarView.topAnchor
                .constraint(equalTo: view.topAnchor).isActive = true
            statusbarView.centerXAnchor
                .constraint(equalTo: view.centerXAnchor).isActive = true
          
        } else {
//            print("ios 12.0");
            let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView
            statusBar?.backgroundColor = UIColor.black
        }
        
        
        
        // 앱 현재 버전
        let version = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
//               print("version : \(version)");
        
        self.webView.configuration.allowsInlineMediaPlayback = true
        
        // 앱이 완전 종료 되고 다시 들어 올때 값을 확인 함 
        let pushLink = UserDefaults.standard.string(forKey: "PUSH_URL")
        if let url = URL(string: pushLink ?? "") {
            let request = URLRequest(url: url)
            self.webView.load(request)
            UserDefaults.standard.removeObject(forKey: "PUSH_URL")
        } else {
            Messaging.messaging().token { token, error in
              if let error = error {
                print("Error fetching FCM registration token: \(error)")
                let url = URL(string: appIndexUrl.replacingOccurrences(of: "$version$", with: version))
                let request = URLRequest(url: url!)
                print("redirect: \(String(describing: url))")
                self.webView.load(request)
              } else if let token = token {
                print("FCM registration token: \(token)")
                let url = URL(string: tokenUrl.replacingOccurrences(of: "$version$", with: version).replacingOccurrences(of: "$token$", with: token))
                let request = URLRequest(url: url!)
                print("redirect: \(String(describing: url))")
                self.webView.load(request)
    //            self.fcmRegTokenMessage.text  = "Remote FCM registration token: \(token)"
              }
            }
        }
//        self.webView.configuration.allowsInlineMediaPlayback = false
        
        isFirstRun = false
    }
    
    // 푸시 url로 들어왔을 경우 webview load
    func handlePushNotification(urlString: String) {
        print("handlePushNotification", urlString)
        self.urlString = urlString
        
        // WebView 다시 로드
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            webView.load(request)
            UserDefaults.standard.removeObject(forKey: "PUSH_URL")
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
            
        // 글자색을 흰색으로
        return .lightContent
        
        // 글자색을 검은색으로
        //return .darkContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated) // No need for semicolon
        print("viewWillAppear")
     }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("viewDidAppear")
        
       
    }
    
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    

    //alert 처리
   func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "확인", style: .default, handler: { (action) in completionHandler() }))
        self.present(alertController, animated: true, completion: nil)
    }
    
    //confirm 처리
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "확인", style: .default, handler: { (action) in completionHandler(true) }))
        alertController.addAction(UIAlertAction(title: "취소", style: .default, handler: { (action) in completionHandler(false) }))
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    //confirm 처리2
    func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) { let alertController = UIAlertController(title: "", message: prompt, preferredStyle: .alert)
        alertController.addTextField { (textField) in textField.text = defaultText }
        alertController.addAction(UIAlertAction(title: "확인", style: .default, handler: { (action) in if let text = alertController.textFields?.first?.text { completionHandler(text) } else { completionHandler(defaultText) } }))
        alertController.addAction(UIAlertAction(title: "취소", style: .default, handler: { (action) in completionHandler(nil) }))
        self.present(alertController, animated: true, completion: nil)
        
    }
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
       // self.indicator.startAnimating()
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//        self.webView.evaluateJavaScript("document.querySelectorAll('video').forEach(v => { v.pause(); })", completionHandler: nil)
        //self.indicator.stopAnimating()
    }
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        //self.indicator.stopAnimating()
    }
    
    // href="_blank" 처리
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        
        //if url.description.lowercased().range(of: "clubclio.co.kr") != nil
        
        
        if navigationAction.targetFrame == nil, let url = navigationAction.request.url {
//            print("팝업 들어오는지 ",url)
            if !isFirstRun
            {
                if url.description.hasPrefix(strDefaultUrl){
                    self.topView.isHidden = true
                }else
                {
                    //무조건 삭제 하려고 주석 처리함
//                    self.topView.isHidden = false
                    self.topView.isHidden = true
                }
            }
            // sns 로그인
            if url.description.lowercased().range(of: "nid.naver.com") != nil ||
                url.description.lowercased().range(of: "kauth.kakao.com") != nil ||
                url.description.lowercased().range(of: "www.facebook.com/v") != nil {
                
                popupWebView = WKWebView(frame: CGRect(x: 0, y: 0, width: self.subView.frame.size.width, height: self.view.frame.size.height), configuration: configuration)
                popupWebView?.translatesAutoresizingMaskIntoConstraints = false
                popupWebView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                popupWebView?.uiDelegate = self
                popupWebView?.navigationDelegate = self
                popupWebView?.scrollView.showsHorizontalScrollIndicator = false // 세로 스크롤 Show여부
                popupWebView?.scrollView.showsVerticalScrollIndicator = false // 가로 스크롤 Show여부
                popupWebView?.scrollView.pinchGestureRecognizer?.isEnabled = false
                popupWebView?.scrollView.bounces = false
                
                UIView.transition(with: self.view, duration: 1, options: UIView.AnimationOptions.transitionCrossDissolve, animations: {self.subView.addSubview(self.popupWebView)}, completion: nil);
                
        
                return popupWebView!
            // 사파리 브라우저 오픈
            } else {
                if url.description.lowercased().range(of: "http://") != nil ||
                  url.description.lowercased().range(of: "https://") != nil ||
                  url.description.lowercased().range(of: "mailto:") != nil {
                    print("사파리 브라우저 오픈",url)
                  UIApplication.shared.open(url)
                }
                
            }
        }
        return nil
    }
    
    // 카카오 링크 열기
//    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction,
//                     decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
//        if let url = navigationAction.request.url, url.scheme == "kakaoLink" {
//            UIApplication.shared.open(url, options: [:], completionHandler: nil)
//            decisionHandler(.cancel)
//            return
//        }
//        decisionHandler(.allow)
//    }
//
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
       
//        if navigationAction.request.url?.description.lowercased().range(of: "clubclio.co.kr") != nil{
//            self.topView.isHidden = false
//
//        }else{
//            self.topView.isHidden = true
//        }
       if let url = navigationAction.request.url, url.scheme != "http" && url.scheme != "https" {
           UIApplication.shared.open(url)
         decisionHandler(.cancel)
       } else {
         decisionHandler(.allow)
       }
     }
    
    func viewClose(){
      
        UIView.transition(with: self.view, duration: 1, options: UIView.AnimationOptions.transitionCrossDissolve, animations: {
            self.topView.isHidden = true
            self.popupWebView?.removeFromSuperview()
            self.popupWebView = nil
                          }, completion: nil);
        
    }
    
    // 중복적으로 리로드 방지
    public func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        webView.reload()
        
    }
    


}

