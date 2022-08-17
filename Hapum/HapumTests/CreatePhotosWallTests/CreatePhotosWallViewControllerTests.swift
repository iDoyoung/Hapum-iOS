//
//  CreatePhotosWallViewControllerTests.swift
//  HapumTests
//
//  Created by Doyoung on 2022/04/14.
//

import XCTest

@testable import Hapum

class CreatePhotosWallViewControllerTests: XCTestCase {

    var sut: CreatePhotosWallViewController!
    var window: UIWindow!

    override func setUpWithError() throws {
        try super.setUpWithError()
        window = UIWindow()
        let storyboard = Storyboard.createPhotosWall
        sut = ViewController.createPhotosWall(storyboard: storyboard) as? CreatePhotosWallViewController
    }

    override func tearDownWithError() throws {
        sut = nil
        window = nil
        try super.tearDownWithError()
    }

    func loadView() {
        window.addSubview(sut.view)
    }

    //MARK: - Test Doubles
    class MockBusinessLogic: CreatePhotosWallBusinessLogic {
        var getPhotosCalled = false
        
        func getPhotos() {
            getPhotosCalled = true
        }
        
        func addPhoto(_ photo: UIImage) {
        }
        
        func requestAccessCamera() {
        }
        
        func trySavePhotosWallView() {
        }

    }

    //MARK: - Test
    func test_shouldGetPhotos_whenViewDidLoad() {
        ///given
        let mockBusinessLogic = MockBusinessLogic()
        sut.interactor = mockBusinessLogic
        loadView()
        ///when
        sut.viewDidLoad()
        ///then
        XCTAssert(mockBusinessLogic.getPhotosCalled, "Should get photos right after the view did load")
    }

}
