//
//  MainPresenterTests.swift
//  HapumTests
//
//  Created by Doyoung on 2022/04/08.
//

import XCTest

@testable import Hapum

class MainPresenterTests: XCTestCase {

    //MARK: - System under test
    var sut: MainPresenter!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = MainPresenter()
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }
    
    //MARK: - Test doubles
    class MainDisplayLogicSpy: MainDisplayLogic {
       
        var displayFetchedPhotosCalled = true
        var displayFetchedAlbumCalled = true
        var displayAuthorizedPhotosAccessStatusMessageCalled = false
        var displayRestrictedPhotosAccessStatusMessageCalled = false
        var displayLimitedPhotosAccessStatusMessageCalled = false
       
        func displayFetchedPhotos(viewModel: [UIImage]) {
            displayFetchedPhotosCalled = true
        }
        
        func displayFetchedAlbum(viewModel: [UIImage]) {
            displayFetchedAlbumCalled = true
        }
        
        func displayAuthorizedPhotosAccessStatusMessage() {
            displayAuthorizedPhotosAccessStatusMessageCalled = true
        }
        
        func displayRestrictedPhotosAccessStatusMessage() {
            displayRestrictedPhotosAccessStatusMessageCalled = true
        }
        
        func displayLimitedPhotosAccessStatusMessage() {
            displayLimitedPhotosAccessStatusMessageCalled = true
        }
        
    }
    //MARK: - Test
    func test_shouldCallDisplayFetchedPhotosInViewControllerWhenPresentFetchedAllPhotos() {
        //given
        let mainDisplayLogicSpy = MainDisplayLogicSpy()
        sut.viewController = mainDisplayLogicSpy
        //when
        sut.presentFetchedAllPhotos(resource: Seeds.PhotoResultAssetDummy.fetched)
        //then
        XCTAssert(mainDisplayLogicSpy.displayFetchedPhotosCalled, "Call view controller to display fetched photos")
    }
    
    func test_shouldCallDisplayFetchedAlbumInViewControllerWhenPresentFetchedAllPhotos() {
        //given
        let mainDisplayLogicSpy = MainDisplayLogicSpy()
        sut.viewController = mainDisplayLogicSpy
        //when
        sut.presentFetchedAlbums(resource: Seeds.PhotoResultAssetDummy.fetched)
        //then
        XCTAssert(mainDisplayLogicSpy.displayFetchedAlbumCalled, "Call view controller to display fetched photos")
    }
    
    var displayAuthorizedPhotosAccessStatusMessageCalled = false
    var displayRestrictedPhotosAccessStatusMessageCalled = false
    var displayLimitedPhotosAccessStatusMessageCalled = false
    
    func test_shouldCallDisplayAuthorizedPhotosAccessStatusMessageInViewController_whenPresentAuthorizedPhotosAccessStatus() {
        //given
        let mainDisplayLogicSpy = MainDisplayLogicSpy()
        sut.viewController = mainDisplayLogicSpy
        //when
        sut.presentAuthorizedPhotosAccessStatus()
        //then
        XCTAssert(mainDisplayLogicSpy.displayAuthorizedPhotosAccessStatusMessageCalled, "Call suitable display method by access status in Main View controlelr")
    }
    
    func test_shouldCallDisplayLimitedPhotosAccessStatusMessageInViewController_whenPresentLimitedPhotosAccessStatus() {
        //given
        let mainDisplayLogicSpy = MainDisplayLogicSpy()
        sut.viewController = mainDisplayLogicSpy
        //when
        sut.presentLimitedPhotosAccessStatus()
        //then
        XCTAssert(mainDisplayLogicSpy.displayLimitedPhotosAccessStatusMessageCalled, "Call suitable display method by access status in Main View controlelr")
    }

    func test_shouldCallDisplayRestrictedPhotosAccessStatusMessage_whenPresentRestrictedPhotosAccessStatus() {
        //given
        let mainDisplayLogicSpy = MainDisplayLogicSpy()
        sut.viewController = mainDisplayLogicSpy
        //when
        sut.presentRestrictedPhotosAccessStatus()
        //then
        XCTAssert(mainDisplayLogicSpy.displayRestrictedPhotosAccessStatusMessageCalled, "Call suitable display method by access status in Main View controlelr")
    }
    
}
