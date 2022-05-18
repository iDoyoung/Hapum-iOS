//
//  String+Extension.swift
//  Hapum
//
//  Created by Doyoung on 2022/05/17.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}
