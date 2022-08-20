//
//  PhotoFrame.swift
//  Hapum
//
//  Created by Doyoung on 2022/08/19.
//

import Foundation

enum PhotoFrame {
    struct Response: Equatable {
        var id: UUID
        var x: Double
        var y: Double
        var width: Double
        var height: Double
        var borderWidth: Float
        var space: Bool
        
        static func == (lhs: Response, rhs: Response) -> Bool {
            lhs.id == rhs.id
        }
    }
    struct ViewModel: Equatable {
        var id: UUID?
        var displayedView: FrameView
        
        static func == (lhs: ViewModel, rhs: ViewModel) -> Bool {
            lhs.id == rhs.id
        }
    }
}
