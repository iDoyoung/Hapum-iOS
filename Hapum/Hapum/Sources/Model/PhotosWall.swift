//
//  PhotoFrame.swift
//  Hapum
//
//  Created by Doyoung on 2022/07/10.
//

import UIKit

struct PhotosWall: Equatable {
    let id: UUID
    var createdDate: Date
    var photoFrames: [PhotoFrame]
    
    static func == (lhs: PhotosWall, rhs: PhotosWall) -> Bool {
        lhs.id == rhs.id
    }
}

struct PhotoFrame {
    var id: UUID
    var x: Double
    var y: Double
    var width: Double
    var height: Double
    var borderWidth: Float
    var space: Bool
}

//struct ViewModel {
//    let id: UUID
//    var photoFrames: [PhotoFrame]
//    var createdDate: Date
//
//    struct PhotoFrame {
//        var frame: CGRect
//        var borderWidth: Float
//        var space: Bool
//
//        init(_ response: Response.PhotoFrame) {
//            let deviceScreen = UIScreen.main.bounds
//            frame = CGRect(x: response.x * deviceScreen.width, y: response.y * deviceScreen.height, width: response.width, height: response.height)
//            borderWidth = response.borderWidth
//            space = response.space
//        }
//    }
//
//}
