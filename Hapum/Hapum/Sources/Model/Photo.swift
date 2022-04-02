//
//  Photo.swift
//  Hapum
//
//  Created by Doyoung on 2022/03/31.
//

import UIKit
import CoreLocation

struct Photo: Equatable {
    
    let identifier: String
    let image: UIImage?
    let creationDate: Date?
    let location: CLLocation?
    
}
