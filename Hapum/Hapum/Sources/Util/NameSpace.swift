//
//  NameSpace.swift
//  Hapum
//
//  Created by Doyoung on 2022/03/30.
//

import Foundation

enum StoryboardName {
    static let main = "Main"
    static let about = "About"
    static let createPhotosWall = "Create"
}

enum ViewControllerID {
    static let main = "MainViewController"
    static let about = "AboutAppViewController"
    static let createPhotosWall = "CreatePhotosWallViewController"
}

enum NibName {
    static let photosViewCell = "PhotosViewCell"
    static let frameViewCell = "FrameViewCell"
    static let photosWallView = "PhotosWallView"
}

enum SegueID {
    static let privacyPolicy = "PrivacyPolicy"
}

enum AlbumName{
    static let hapum = "Hapum"
}

//MARK: - For UI
enum LabelText {
    static let recommending = "Recommend Hapum".localized
    static let reviewing = "Write a review".localized
    static let privacyPolicy = "Privacy policy".localized
}
//MARK: - Alert
enum AlertTitle {
    static let managingPhotosAccess = ""
    static let savingInPhotos = ""
    static let creatingFailure = "예기치 못한 오류로 이미지 저장에 실패하였습니다.".localized
}

enum AlertMessage {
    static let managingPhotosAccess = "Manage to Access to Your Photos".localized
    static let savingInPhotos = "Save in Photos".localized
    static let creatingFailure = "개발자에게 오류를 알려주시면 감사하겠습니다.".localized
}

enum AlertActionTitle {
    static let changeSetting = "Change Settings".localized
    static let selectMore = "Select More Photos".localized
    static let okay = "OK".localized
    static let cancel = "Cancel".localized
    static let save = "Save".localized
}

enum PhotosAccessStatusMessage {
    static let needToSet = "Please Allow Access to Your Photos".localized
    static let limitedStatus = "You allow access to selected only".localized
}

//MARK: - Menu
enum MenuTitle {
    static let changeColor = "Change Color".localized
    static let changePhoto = ""
}

enum MenuActionTitle {
    static let choosePhoto = "Choose a photo".localized
    static let takePhoto = "Take a photo".localized
    static let changeBackgroundColor = "Background".localized
    static let changeFrameColor = "Frame".localized
}
