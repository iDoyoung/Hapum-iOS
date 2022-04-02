//
//  Date+Extension.swift
//  Hapum
//
//  Created by Doyoung on 2022/04/01.
//

import Foundation

extension Date {
   
    var onlyDate: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        return formatter.string(from: self)
    }
    
}
