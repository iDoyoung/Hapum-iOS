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
    
    private init() { }
    
    struct PhotoResultAssetDummy {
        private init() { }
        static let fetched: PHFetchResult<PHAsset> = PHFetchResult()
    }
    
    struct ImageDummy {
        private init() { }
        static let image = UIImage(systemName: "checkmark.seal.fill")
    }
    
    struct PhotosWallDummy {
        private init() { }
        private static let id = UUID()
        
        static let responseMock = PhotosWall.Response(
            id: id,
            createdDate: Date(),
            photoFrames: [])
        static let viewModelMock = PhotosWall.ViewModel(id: id, displayedView: CustomPhotosWallView(photosFrameViews: []))
    }
    
    static let photoFrameMock = PhotoFrame.Response(id: UUID(), x: 0, y: 0, width: 0, height: 0, borderWidth: 0, space: false)
    
}
