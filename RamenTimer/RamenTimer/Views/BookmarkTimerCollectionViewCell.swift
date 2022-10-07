//
//  BookmarkMainCollectionViewCell.swift
//  RamenTimer
//
//  Created by 이형주 on 2022/08/27.
//

import UIKit

class BookmarkTimerCollectionViewCell: UICollectionViewCell {
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        return imageView
    }()
    
    
    var isZoom = false //이미지 확대 여부를 나타내는bool타입변수
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                imageView.contentMode = .center
            } else {
                imageView.contentMode = .scaleAspectFit            
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
        setupImageView()

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupImageView() {
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            imageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0)
          
            ])
        }
    }
    
//    func imageZoom() {
//        let scale: CGFloat = 2.0 //확대할 배율 값
//        var newWidth: CGFloat, newHeight: CGFloat
//        //확대할 크기의 계산 값을 보관할 변수
//        if (isZoom) { //true 현재 확대된 그림일 경우(타이틀은 축소)
//            newWidth = imageView.frame.width/scale
//            //이미지 뷰의 프레임 너빗값을 scale값으로 나눔
//            newHeight = imageView.frame.height/scale
//            //이미지 뷰의 프레임 높잇값을 scale값으로 나눔
////            btnResize.setTitle("확대", for: .normal)
//            //버튼의 타이틀을 "확대"로 변경
//        }
//        else { //false현재 축소된 그림일 경우(타이틀은 확대)
//            newWidth = imageView.frame.width*scale
//            //이미지 뷰의 프레임 너빗값을 scale값으로 곱함
//            newHeight = imageView.frame.height*scale
//            //이미지 뷰의 프레임 높잇값을 scale값으로 곱함
////            btnResize.setTitle("축소", for: .normal)
//            //버튼의 타이틀을 "축소"로 변경한다.
//        }
//        imageView.frame.size = CGSize(width: newWidth, height: newHeight)
//        //이미지 뷰의 프레임 크기를 수정된 너비와 높이로 변경
//        isZoom = !isZoom //isZoom변수의 상태를 !를 이용해 반전시킴
//    }
//}


