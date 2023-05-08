//
//  common.swift
//  bitemecokr
//
//  Created by 위트플러스 on 2023/03/01.
//


import Foundation
import UIKit

let strDefaultUrl = "https://www.biteme.co.kr"
let strLogoUrl = "https://www.biteme.co.kr/shop/App_main"
let strHomeUrl = "https://www.biteme.co.kr/shop/App_main"
let strBackUrl = "https://www.biteme.co.kr/shop/App_main?app_type=login"
let appIndexUrl = "https://www.biteme.co.kr/shop/App_main?OS=IOS&VERSION=$version$"
let tokenUrl = "https://www.biteme.co.kr/shop/App_main?OS=IOS&VERSION=$version$&TOKEN=$token$"
let imgLaunchScreen = "https://api.devbiteme.co.kr/app/biteme_app.php"


extension CALayer {
    func addBorder(_ arr_edge: [UIRectEdge], color: UIColor, width: CGFloat) {
        for edge in arr_edge {
            let border = CALayer()
            switch edge {
            case UIRectEdge.top:
                border.frame = CGRect.init(x: 0, y: 0, width: frame.width, height: width)
                break
            case UIRectEdge.bottom:
                border.frame = CGRect.init(x: 0, y: frame.height - width, width: frame.width, height: width)
                break
            case UIRectEdge.left:
                border.frame = CGRect.init(x: 0, y: 0, width: width, height: frame.height)
                break
            case UIRectEdge.right:
                border.frame = CGRect.init(x: frame.width - width, y: 0, width: width, height: frame.height)
                break
            default:
                break
            }
            border.backgroundColor = color.cgColor;
            self.addSublayer(border)
        }
    }
}
