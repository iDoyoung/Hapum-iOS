//
//  Date+Extension.swift
//  Hapum
//
//  Created by Doyoung on 2022/04/01.
//

import Foundation

extension Date {
    
    func yesterday() -> Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: Date())!
    }
    
    var noon: Date {
        return Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: self)!
    }
    
    var onlyDate: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        return formatter.string(from: self)
    }
    
}
