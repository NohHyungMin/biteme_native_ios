//
//  IntroViewController.swift
//  bitemecokr
//
//  Created by 위트플러스 on 2023/03/01.
//

import UIKit

class IntroViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!


    override func viewDidLoad() {
        super.viewDidLoad()
        
        // imageView를 수평 및 수직 중앙에 배치
        imageView.translatesAutoresizingMaskIntoConstraints = true
//        NSLayoutConstraint.activate([
//            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
//        ])

        if let url = URL(string: imgLaunchScreen) {
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let data = data {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: [])
                        if let jsonDict = json as? [String: Any] {
                            // JSON에서 필요한 값을 추출하여 라벨에 표시
                            
                            if let introurl = jsonDict["introurl"] as? String {
                                if let url = URL(string: introurl) {
                                    let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                                        if let data = data {
                                            DispatchQueue.main.async {
                                                // 이미지 로딩이 완료되면 imageView에 설정
                                                self.imageView.image = UIImage(data: data)
                                            }
                                        }
                                    }
                                    task.resume()
                                }
                            }
                            
                            
                        }
                    } catch {
                        print("error : ",error.localizedDescription)
                    }
                }
            }
            task.resume()
        }
        // 3초 뒤에 다음 뷰 컨트롤러로 이동
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "ViewController")
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: false, completion: nil)
        }
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }

    
}
