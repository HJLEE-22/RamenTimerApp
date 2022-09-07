//
//  RamensDataManager.swift
//  RamenTimer
//
//  Created by 이형주 on 2022/08/30.
//

import UIKit

class RamensDataManager {
    
    var ramens: [Ramen] = [
        Ramen(number: 0, image: UIImage(named: "짜파게티"), title: "짜파게티", suggestedTime: 300, settingTime: 3, rating: .oneStar, brand: .nongSim, bookmark: true),
        Ramen(number: 1, image: UIImage(named: "불닭볶음면"), title: "불닭볶음면", suggestedTime: 300, settingTime: 300, rating: .fiveStar, brand: .samyang, bookmark: true),
        Ramen(number: 2, image: UIImage(named: "까르보불닭볶음면"), title: "까르보불닭볶음면", suggestedTime: 300, settingTime: 300, rating: .fiveStar,  brand: .samyang, bookmark: true),
        Ramen(number: 3, image: UIImage(named: "신라면건면-1"), title: "신라면건면", suggestedTime: 270, settingTime: 270, rating: .fourStar, brand: .nongSim, bookmark: true),
        Ramen(number: 4, image: UIImage(named: "열라면"), title: "열라면", suggestedTime: 240, settingTime: 240, rating: .fourStar, brand: .ottugi, bookmark: true)

    ]

    func getRamenArray() -> [Ramen] {
        return ramens
    }
    
}
