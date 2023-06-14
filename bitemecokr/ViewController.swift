//
//  ViewController.swift
//  bitemecokr
//
//  Created by 위트플러스 on 2023/03/01.
//

import UIKit
import WebKit;
import FirebaseMessaging

import AdSupport
import AirBridge
//import BuzzBooster
import Foundation
import SafariServices

//BuzzBooster 로그인 정보
struct LoginInfo: Codable {
    var id: String
    var type: String
}

//BuzzBooster 이벤트 정보
struct EventInfo: Codable {
    var event_name: String
}

class ViewController: UIViewController, WKUIDelegate, WKNavigationDelegate, WKScriptMessageHandler {
    
    var webView: WKWebView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var networkerror: UIImageView!
    @IBOutlet weak var btnBack: UIButton!
    //@IBOutlet weak var btnHome: UIButton!
    //@IBOutlet weak var btnLogo: UIButton!
    //var webView: WKWebView!
    @IBOutlet weak var subView: UIView!
    var popupWebView: WKWebView!
    var popupWebViewWithouClose: WKWebView!
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

        //let configuration = WKWebViewConfiguration()
                
//        let event = ABInAppEvent()
//        event?.setCategory(ABCategory.viewHome)
//        event?.send()
        let configuration = WKWebViewConfiguration()
        let controller = WKUserContentController()
        AirBridge.webInterface()?.inject(to: controller, withWebToken: "d673b0ff0b9d49daa0bff7c634f953c6")

        configuration.userContentController = controller
        
        if #available(iOS 10.0, *) {
            configuration.mediaTypesRequiringUserActionForPlayback = []
        }
        configuration.allowsInlineMediaPlayback = true
        configuration.preferences.javaScriptEnabled = true
        configuration.preferences.javaScriptCanOpenWindowsAutomatically = true
        
        
        webView = WKWebView(frame: .zero, configuration: configuration)
        //if let webView = webView {
        subView.addSubview(webView)
//        webView.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            webView.leadingAnchor.constraint(equalTo: subView.leadingAnchor),
//            webView.trailingAnchor.constraint(equalTo: subView.trailingAnchor),
//            webView.topAnchor.constraint(equalTo: subView.topAnchor),
//            webView.bottomAnchor.constraint(equalTo: subView.bottomAnchor)])
        //}
        
        //webView.configuration.allowsInlineMediaPlayback = true
        //webView.configuration.preferences.javaScriptEnabled = true
        //webView.configuration.preferences.javaScriptCanOpenWindowsAutomatically = true
        
        //JS에서의 호출 대응
        webView.configuration.userContentController.add(self, name: "setting")
        //BuzzBooster 호출
        webView.configuration.userContentController.add(self, name: "buzzLogin")
        webView.configuration.userContentController.add(self, name: "buzzLogout")
        webView.configuration.userContentController.add(self, name: "buzzShowCampaign")
        webView.configuration.userContentController.add(self, name: "buzzShowCampaignWithId")
        webView.configuration.userContentController.add(self, name: "buzzSendEvent")
        
        webView.uiDelegate = self
        webView.navigationDelegate = self
        
        webView.translatesAutoresizingMaskIntoConstraints = false
        let guide = view.safeAreaLayoutGuide
        webView.topAnchor.constraint(equalTo: topView.bottomAnchor).isActive = true
        webView.leftAnchor.constraint(equalTo: guide.leftAnchor).isActive = true
        webView.rightAnchor.constraint(equalTo: guide.rightAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: guide.bottomAnchor).isActive = true
        
        
        // 밀어서 뒤로가기 기능 추가
        webView.allowsBackForwardNavigationGestures = true
        self.topView.isHidden = true
        //self.topView.layer.addBorder([.top], color: UIColor.lightGray, width: 0.5)
        
        webView.scrollView.bounces = false
        webView.isOpaque = false;
        webView.backgroundColor = UIColor.white
        webView.allowsLinkPreview = false
        //에어브릿지 딥링크 콜백
//        AirBridge.deeplink()?.setDeeplinkCallback({ deeplink in
//                // 딥링크로 앱이 열리는 경우 작동할 코드
//                // Airbridge 를 통한 Deeplink = YOUR_SCHEME://...
//            NSLog("DeeplinkCallback : %@", deeplink)
//            let version = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
//
//            var urlString = appIndexUrl.replacingOccurrences(of: "$version$", with: version)
//
//            if(common.getDeviceId() != "") {
//                urlString += "&ID=" + common.getDeviceId()
//            }
//            if(common.getOsVersion() != "") {
//                urlString += "&OS_VER=" + common.getOsVersion()
//            }
//            if(deeplink != "biteme://" && deeplink != "https://"  && deeplink != "http://") {
//                let changedDeeplink = deeplink.replacingOccurrences(of: "biteme://", with: "https://")
//                urlString += "&deeplink=Y&LINK=" + changedDeeplink
//            }
//            Messaging.messaging().token { token, error in
//                if let error = error {
//                    print("Error fetching FCM registration token: \(error)")
//                    let url = URL(string: urlString)
//                    let request = URLRequest(url: url!)
//                    print("redirect: \(String(describing: url))")
//                    self.webView.load(request)
//                } else if let token = token {
//                    print("FCM registration token: \(token)")
//                    urlString += "&TOKEN=" + token
//                    let url = URL(string: urlString)
//                    let request = URLRequest(url: url!)
//                    self.webView.load(request)
//                }
//            }
//        })
   }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        if #available(iOS 13.0, *) {
//            print("ios 13.0");
            let app = UIApplication.shared
            let statusBarHeight: CGFloat = app.statusBarFrame.size.height

            let statusbarView = UIView()
            statusbarView.backgroundColor = UIColor.white
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
            statusBar?.backgroundColor = UIColor.white
        }
        landgindPage()
        isFirstRun = false
    }
    
    // 푸시 url로 들어왔을 경우 webview load
    func handlePushNotification(urlString: String) {
        print("handlePushNotification", urlString)
        //self.urlString = urlString
        landgindPage()
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
    
    //푸시클릭 및 페이지 랜딩 처리
    func landgindPage(){
        let version = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
        
        var urlString = appIndexUrl.replacingOccurrences(of: "$version$", with: version)
        
        if(common.getDeviceId() != "") {
            urlString += "&ID=" + common.getDeviceId()
        }
        if(common.getOsVersion() != "") {
            urlString += "&OS_VER=" + common.getOsVersion()
        }
//        if(getModelName() != "") {
//            urlString += "&MODEL=" + getModelName()
//        }
        
        if let pushSeq = UserDefaults.standard.string(forKey: "PUSH_SEQ") {
            urlString += "&SEQ=" + pushSeq
            UserDefaults.standard.removeObject(forKey: "PUSH_SEQ")
        }
        if let pushLink = UserDefaults.standard.string(forKey: "PUSH_URL") {
            urlString += "&LINK=" + pushLink
            UserDefaults.standard.removeObject(forKey: "PUSH_URL")
        }
        if let deepLink = UserDefaults.standard.string(forKey: "DEEPLINK") {
            UserDefaults.standard.removeObject(forKey: "DEEPLINK")
            if(deepLink != "biteme://" && deepLink != "https://"  && deepLink != "http://") {       //단순 앱열기용 링크는 링크 이동 적용 안함
                if(deepLink.contains("biteme://") || deepLink.contains("https://") || deepLink.contains("http://")){
                    let changedDeeplink = deepLink.replacingOccurrences(of: "biteme://", with: "https://")
                    urlString += "&deeplink=Y&LINK=" + changedDeeplink
                }
            }
            if((deepLink == "biteme://"
            || deepLink.contains("isppay"))   //isp결제 후 돌아오면
               && self.webView.url != nil){  //첫시작이 아니고 기본 스키마로 들어올 경우 링크 이동 안함
                return
            }
        }
        Messaging.messaging().token { token, error in
            if let error = error {
                print("Error fetching FCM registration token: \(error)")
                let url = URL(string: urlString)
                let request = URLRequest(url: url!)
                print("redirect: \(String(describing: url))")
                self.webView.load(request)
            } else if let token = token {
                print("FCM registration token: \(token)")
                urlString += "&TOKEN=" + token
                let url = URL(string: urlString)
                let request = URLRequest(url: url!)
                self.webView.load(request)
            }
        }
    }
    
    // JS -> Native CALL
    @available (iOS 8.0, *)
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if(message.name == "setting"){
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "SettingViewController")
            vc.modalPresentationStyle = .pageSheet
            self.present(vc, animated: true, completion: nil)
        }/*else if(message.name == "buzzLogin"){
            let decoder = JSONDecoder()
            do {
                let json = (message.body as! String).data(using: .utf8)!
                let decoded = try decoder.decode(LoginInfo.self, from: json)
                let user = BSTUser { builder in
                    builder.userId = decoded.id as NSString           //  (필수) 유저 식별자
                    builder.marketingStatus = .optIn                   //  (권장) 마케팅 수신 동의 여부
                    builder.properties = ["login_type": decoded.type] //  (권장) 로그인 타입
                }
                BuzzBooster.setUser(user)
                //print("id" + decoded.id)
                //print("type" + decoded.type)
            }catch{}
        }else if(message.name == "buzzLogout"){
            BuzzBooster.setUser(nil)
        }else if(message.name == "buzzShowCampaign"){
            BuzzBooster.showCampaign(with: self)
        }else if(message.name == "buzzShowCampaignWithId"){
            BuzzBooster.showCampaign(with: self, campaignId: message.body as! String)
            //print(message.body)
        }else if(message.name == "buzzSendEvent"){
            let decoder = JSONDecoder()
            do {
                let json = (message.body as! String).data(using: .utf8)!
                let decoded = try decoder.decode(EventInfo.self, from: json)
                BuzzBooster.sendEvent(withEventName: decoded.event_name);
                //print("event:" + decoded.event_name)
            }catch{}
            
        }*/
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
//            if !isFirstRun
//            {
//                if url.description.hasPrefix(strDefaultUrl){
//                    self.topView.isHidden = true
//                }else
//                {
//                    //무조건 삭제 하려고 주석 처리함
////                    self.topView.isHidden = false
//                    self.topView.isHidden = true
//                }
//            }
            // sns 로그인 및 상담하기
            if url.description.lowercased().range(of: "nid.naver.com") != nil ||
                url.description.lowercased().range(of: "kauth.kakao.com") != nil ||
                url.description.lowercased().range(of: "www.facebook.com/v") != nil ||
                url.description.lowercased().range(of: "biteme.channel.io") != nil {
                
                popupWebViewWithouClose = WKWebView(frame: CGRect(x: 0, y: 0, width: self.subView.frame.size.width, height: self.subView.frame.size.height), configuration: configuration)
                popupWebViewWithouClose?.translatesAutoresizingMaskIntoConstraints = false
                popupWebViewWithouClose?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                popupWebViewWithouClose?.uiDelegate = self
                popupWebViewWithouClose?.navigationDelegate = self
                popupWebViewWithouClose?.scrollView.showsHorizontalScrollIndicator = false // 세로 스크롤 Show여부
                popupWebViewWithouClose?.scrollView.showsVerticalScrollIndicator = false // 가로 스크롤 Show여부
                popupWebViewWithouClose?.scrollView.pinchGestureRecognizer?.isEnabled = false
                popupWebViewWithouClose?.scrollView.bounces = false
                popupWebViewWithouClose?.allowsLinkPreview = false
                
                UIView.transition(with: self.view, duration: 0, options: UIView.AnimationOptions.transitionCrossDissolve, animations: {self.subView.addSubview(self.popupWebViewWithouClose)}, completion: nil);
                
        
                return popupWebViewWithouClose!
            } else if url.description.lowercased().range(of: "bizbite.me") != nil {
                UIApplication.shared.open(url)
                return nil
            }else {
                // 사파리 브라우저 오픈
//                if url.description.lowercased().range(of: "http://") != nil ||
//                                  url.description.lowercased().range(of: "https://") != nil ||
//                                  url.description.lowercased().range(of: "mailto:") != nil {
//                    let safariView = SFSafariViewController(url: url)
//                    present(safariView, animated: false, completion: nil)
//                    //let _getSchemeStr = webView.url?.scheme
//                }
//                return nil
                
                //뷰를 생성하는 경우
//                let frame = UIScreen.main.bounds
//
//                //파라미터로 받은 configuration
//                createWebView = WKWebView(frame: frame, configuration: configuration)
//
//                //오토레이아웃 처리
//                createWebView!.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//
//                createWebView!.navigationDelegate = self
//                createWebView!.uiDelegate = self
//                createWebView!.tag = 100
//
//                self.subView.addSubview(createWebView!)

                
                // 사파리 브라우저 오픈
//                if url.description.lowercased().range(of: "http://") != nil ||
//                  url.description.lowercased().range(of: "https://") != nil ||
//                  url.description.lowercased().range(of: "mailto:") != nil {
//                    print("사파리 브라우저 오픈",url)
//                  UIApplication.shared.open(url)
//                }
                self.topView.isHidden = false
                
                popupWebView = WKWebView(frame: CGRect(x: 0, y: 0, width: self.subView.frame.size.width, height: self.subView.frame.size.height), configuration: configuration)
                popupWebView?.translatesAutoresizingMaskIntoConstraints = false
                popupWebView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                popupWebView?.uiDelegate = self
                popupWebView?.navigationDelegate = self
                //popupWebView?.scrollView.showsHorizontalScrollIndicator = false // 세로 스크롤 Show여부
                //popupWebView?.scrollView.showsVerticalScrollIndicator = false // 가로 스크롤 Show여부
                //popupWebView?.scrollView.pinchGestureRecognizer?.isEnabled = false
                popupWebView?.scrollView.bounces = false
                popupWebView?.allowsLinkPreview = false
                popupWebView?.allowsBackForwardNavigationGestures = true
                
                UIView.transition(with: self.view, duration: 0, options: UIView.AnimationOptions.transitionCrossDissolve, animations: {self.subView.addSubview(self.popupWebView)}, completion: nil);
                
                return popupWebView!
            }
        }
        return nil
    }
    
    //새창 닫기
    //iOS9.0 이상
    func webViewDidClose(_ webView: WKWebView) {
        popupWebViewWithouClose?.removeFromSuperview()
        popupWebViewWithouClose = nil
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
       
        if webView.url?.description.lowercased().range(of: strDefaultUrl) != nil  {        //카카오 로그인, 페이코 로그인 화면에서 뒤로갈수 있는 기능
            if popupWebView == nil && popupWebViewWithouClose == nil {
                self.topView.isHidden = true
            }
        }else{
            if popupWebView == nil && popupWebViewWithouClose == nil{
                self.topView.isHidden = false
            }
        }
       if let url = navigationAction.request.url, url.scheme != "http" && url.scheme != "https" {
           UIApplication.shared.open(url)
         decisionHandler(.cancel)
       } else {
         decisionHandler(.allow)
       }
     }
    
    
    
    func viewClose(){
        if self.popupWebView != nil {
            UIView.transition(with: self.view, duration: 0, options: UIView.AnimationOptions.transitionCrossDissolve, animations: {
                self.topView.isHidden = true
                self.popupWebView?.removeFromSuperview()
                self.popupWebView = nil
            }, completion: nil);
        }else{
            if self.webView.canGoBack{
                self.webView.goBack()
            }
        }
        
    }
    
    // 중복적으로 리로드 방지
    public func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        webView.reload()
        
    }
}

