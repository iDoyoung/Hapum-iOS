//
//  Photo.swift
//  Hapum
//
//  Created by Doyoung on 2022/03/31.
//

import UIKit
import CoreLocation

enum Photos {
    
    struct Asset: Hashable {
        let identifier: String
        let image: UIImage?
        let creationDate: Date?
        let location: CLLocation?
    }
    
    struct Photo {
        let image: UIImage
    }
    
    enum Filtering {
        case all, today, location
    }
    
    enum Status {  case notDetermined, restricted, denied, authorized, limited }
    
}
