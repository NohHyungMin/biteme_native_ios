//
//  IntroViewController.swift
//  bitemecokr
//
//  Created by 위트플러스 on 2023/03/01.
//

import UIKit
import WebKit

class SettingViewController: UIViewController {
    
    @IBOutlet weak var currentVersion: UILabel!
    @IBOutlet weak var recentVersion: UILabel!
    @IBOutlet weak var model: UILabel!
    @IBOutlet weak var osVersion: UILabel!
    @IBAction func doDelCache() {
        self.alert("알림", "캐시 및 쿠키 삭제하시겠습니까?")
    }
    
    @IBAction func doViewClose(){
        dismiss(animated: true);
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //현재 버전, 최신 버전 가져오기
        guard let info = Bundle.main.infoDictionary,
            let strCurrentVersion = info["CFBundleShortVersionString"] as? String, // 현재 버전
            let identifier = info["CFBundleIdentifier"] as? String,
            let url = URL(string: "http://itunes.apple.com/kr/lookup?bundleId=\(identifier)") else { return }
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            do {
                if let error = error { throw error }
                guard let data = data else { throw VersionError.invalidResponse }
                let json = try JSONSerialization.jsonObject(with: data, options: [.allowFragments]) as? [String: Any]
                guard let result = (json?["results"] as? [Any])?.first as? [String: Any], let version = result["version"] as? String else {
                    throw VersionError.invalidResponse
                }
                DispatchQueue.main.async {
                    self.currentVersion.text = strCurrentVersion
                    self.recentVersion.text = version
                }
            } catch {
                
            }
        }
        task.resume()
        
       
        //기기모델명
        self.model.text = common.getModelName()
        //os 버전명
        self.osVersion.text = common.getOsVersion()
    }
    
    
    enum VersionError: Error {
        case invalidResponse, invalidBundleInfo
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }

    private func alert(_ strTitle: String, _ strDelCache: String){
        // 메시지창 컨트롤러 인스턴스 생성
        let alert = UIAlertController(title: strTitle, message: strDelCache, preferredStyle: UIAlertController.Style.alert)
        
        // 메시지 창 컨트롤러에 들어갈 버튼 액션 객체 생성
        let okAction = UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: { _ in
            let webseiteDateTypes = NSSet(array: [WKWebsiteDataTypeDiskCache, // 디스크 캐시
                                                  WKWebsiteDataTypeMemoryCache, // 메모리 캐시
                                                  WKWebsiteDataTypeCookies, // 웹 쿠키, WKWebsiteDataTypeOfflineWebApplicationCache, // 앱 캐시
                                                  WKWebsiteDataTypeWebSQLDatabases, // 웹 SQL 데이터 베이스
                                                  WKWebsiteDataTypeIndexedDBDatabases])  // 데이터 베이스 정보
            let date = NSDate(timeIntervalSince1970: 0)
            WKWebsiteDataStore.default().removeData(ofTypes: webseiteDateTypes as! Set, modifiedSince: date as Date, completionHandler: {
                // remove callback
                let alert = UIAlertController(title: "안내", message: "캐시 및 쿠키가 삭제되었습니다.\n앱을 종료 후 재시작해주세요.", preferredStyle: UIAlertController.Style.alert)
                let okAction =  UIAlertAction(title: "확인", style: UIAlertAction.Style.cancel, handler: nil)
                alert.addAction(okAction)
                //메시지 창 컨트롤러를 표시
                self.present(alert, animated: false)
            })
        })
        alert.addAction(okAction)
        let cancelAction =  UIAlertAction(title: "취소", style: UIAlertAction.Style.cancel, handler: nil)
        alert.addAction(cancelAction)
        //메시지 창 컨트롤러를 표시
        self.present(alert, animated: false)
    }
   
}
