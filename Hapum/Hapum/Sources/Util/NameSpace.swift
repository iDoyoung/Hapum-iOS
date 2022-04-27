//
//  NameSpace.swift
//  Hapum
//
//  Created by Doyoung on 2022/03/30.
//

import Foundation

enum NameSpace {
    static let albumName = "Hapum"
    
    enum Storyboard {
        static let main = "Main"
        static let createPhotosWall = "Create"
    }
    
    enum  ViewControllerID {
        static let main = "MainViewController"
        static let createPhotosWall = "CreatePhotosWallViewController"
    }
    
    //MARK: - Nib Name
    static let photosViewCellNibName = "PhotosViewCell"
    static let frameViewCellNibName = "FrameViewCell"
    static let photosWallViewNibName = "PhotosWallView"
    
    //MARK: - Alert
    enum Alert {
        static let title = "Manage to Access to Your Photos"
        static let message = ""
        
        enum ActionTitle {
            static let changeSetting = "Change Settings"
            static let selectMore = "Select More Photos"
            static let cancel = "Cancel"
        }
        
    }
    
    //MARK: - Segue identifier
    enum MainSegue {
        static let frameSelectionIdentifier = "FrameSelection"
    }
    
    enum PhotosAccessStatusMessage {
        static let needToSet = "Please Allow Access to Your Photos"
        static let limitedStatus = "You allow access to selected only in your Photos"
    }
}
