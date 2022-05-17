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
        static let about = "About"
        static let createPhotosWall = "Create"
    }
    
    enum  ViewControllerID {
        static let main = "MainViewController"
        static let about = "AboutAppViewController"
        static let createPhotosWall = "CreatePhotosWallViewController"
    }
    
    //MARK: - Nib Name
    static let photosViewCellNibName = "PhotosViewCell"
    static let frameViewCellNibName = "FrameViewCell"
    static let photosWallViewNibName = "PhotosWallView"
    
    //MARK: - Alert
    enum AlertTitle {
        static let managingPhotosAccess = ""
        static let savingInPhotos = ""
        static let creatingFailure = "예기치 못한 오류로 이미지 저장에 실패하였습니다."
        
    }
    
    enum AlertMessage {
        static let managingPhotosAccess = "Manage to Access to Your Photos"
        static let savingInPhotos = "Save in Photos"
        static let creatingFailure = "개발자에게 오류를 알려주시면 감사하겠습니다."
    }
    
    enum AlertActionTitle {
        static let changeSetting = "Change Settings"
        static let selectMore = "Select More Photos"
        static let okay = "OK"
        static let cancel = "Cancel"
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
