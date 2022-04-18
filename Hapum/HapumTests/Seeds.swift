//
//  Seeds.swift
//  HapumTests
//
//  Created by Doyoung on 2022/04/07.
//

import Foundation
import UIKit

@testable import Hapum

struct Seeds {
    struct PhotosDummy {
        static let springPhoto = Photos.Asset(
            identifier: "0", image: UIImage(systemName: "leaf.fill"),
            creationDate: nil,
            location: nil
        )
        static let summerPhoto = Photos.Asset(
            identifier: "1", image: UIImage(systemName: "sun.max.fill"),
            creationDate: nil,
            location: nil
        )
        static let fallsPhoto = Photos.Asset(
            identifier: "2", image: UIImage(systemName: "wind"),
            creationDate: nil,
            location: nil
        )
        static let winterPhoto = Photos.Asset(
            identifier: "3", image: UIImage(systemName: "snowflake"),
            creationDate: nil,
            location: nil
        )
    }
    
    struct ImageDummy {
        static let image = UIImage(systemName: "checkmark.seal.fill")
    }
}
