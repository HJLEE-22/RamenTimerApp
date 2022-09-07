//
//  BookmarkTimerPickerVC.swift
//  RamenTimer
//
//  Created by 이형주 on 2022/09/02.
//

import UIKit

class BookmarkTimerPickerVC: UIViewController {
    
    
    lazy var timepPicker: UIPickerView = {
       let picker = UIPickerView()
        picker.numberOfRows(inComponent: 2)
        
       return picker
    }()
    
}
