//
//  Namespace.swift
//  Hapum
//
//  Created by Doyoung on 2022/05/20.
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

enum AlbumName {
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
    static let creatingFailure = ""
    static let restrictedStatus = ""
}

enum AlertMessage {
    static let managingPhotosAccess = "Manage to Access to Photos.".localized
    static let savingInPhotos = "Save in your Photos library.".localized
    static let creatingFailure = "Failed to save image due to an unexpected error.".localized
    static let restrictedStatus = "Please allow Hapum to access photos.".localized
}

enum AlertActionTitle {
    static let changeSetting = "Change Settings".localized
    static let selectMore = "Select More Photos".localized
    static let okay = "OK".localized
    static let cancel = "Cancel".localized
    static let save = "Save".localized
    static let setting = "Open Setting".localized
}

enum PhotosAccessStatusMessage {
    static let restricted = "Please Allow Access to Photos".localized
    static let limited = "You allow access to selected only".localized
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
