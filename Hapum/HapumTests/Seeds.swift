//
//  Seeds.swift
//  HapumTests
//
//  Created by Doyoung on 2022/04/07.
//

import Photos
import UIKit

@testable import Hapum

struct Seeds {
    
    struct PhotoResultAssetDummy {
        static let fetched: PHFetchResult<PHAsset> = PHFetchResult()
    }
    
    struct ImageDummy {
        static let image = UIImage(systemName: "checkmark.seal.fill")
    }
}
