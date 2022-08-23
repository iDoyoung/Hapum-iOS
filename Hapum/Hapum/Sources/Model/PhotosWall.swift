//
//  PhotoFrame.swift
//  Hapum
//
//  Created by Doyoung on 2022/07/10.
//

import Foundation

enum PhotosWall {
    struct Response: Equatable {
        let id: UUID
        var createdDate: Date
        var photoFrames: [PhotoFrame.Response]
        
        static func == (lhs: Response, rhs: Response) -> Bool {
            lhs.id == rhs.id
        }
    }
    struct ViewModel: Equatable {
        var id: UUID
        var displayedView: CustomPhotosWallView
    }
}
