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
        let storyboad = UIStoryboard(name: StoryboardName.main, bundle: Bundle.main)
        sut = storyboad.instantiateViewController(withIdentifier: ViewControllerID.createPhotosWall) as? CreatePhotosWallViewController
    }
    
    override func tearDownWithError() throws {
        sut = nil
        window = nil
        try super.tearDownWithError()
    }
    
    func loadView() {
        window.addSubview(sut.view)
    }
    
    //MARK: - Mock
    class MockBusinessLogic: CreatePhotosWallBusinessLogic {
        
        var getPhotosCalled = false
        var trySavePhotosWallViewCalled = false
        
        func trySavePhotosWallView() {
            trySavePhotosWallViewCalled = true
        }
        
        func getPhotos() {
            getPhotosCalled = true
        }
        
        func requestAccessCamera() {
        }
        
        func addPhoto(photo: Photos.Photo) {
        }
        
    }
    
    //MARK: - Test
    func test_shouldGetPhotosWhenViewDidLoad() {
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
