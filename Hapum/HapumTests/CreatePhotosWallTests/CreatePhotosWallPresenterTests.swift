//
//  CreatePhotosWallPresenterTests.swift
//  HapumTests
//
//  Created by Doyoung on 2022/04/12.
//

import XCTest

@testable import Hapum

class CreatePhotosWallPresenterTests: XCTestCase {

    var sut: CreatePhotosWallPresenter!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = CreatePhotosWallPresenter()
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }
    
    //MARK: - Mock
    class MockCreatePhotosWallDisplayLogic: CreatePhotosWallDisplayLogic {
        
        var displayPhotosCalled = false
        var displayCameraCalled = false
        var displayCreatingSuccessCalled = false
        var displayCreatingFailureCalled = false
        var displayDoneAlertCalled = false
        var displayRestrictedStatusCalled = false
        
        var viewModel: [Photos.Asset]!
        
        func displayPhotos(viewModel: [Photos.Asset]?) {
            displayPhotosCalled = true
            self.viewModel = viewModel
        }
        
        func displayCamera() {
            displayCameraCalled = true
        }
        
        func displayCreatingSuccess() {
            displayCreatingSuccessCalled = true
        }
        
        func displayCreatingFailure() {
            displayCreatingFailureCalled = true
        }
        
        func displayRestrictedStatus() {
            displayRestrictedStatusCalled = true
        }
        
        func displayDoneAlert() {
            displayDoneAlertCalled = true
        }
        
    }
    
    //MARK: - Test
    func test_presentPhotosShouldAskViewControllertoDisplayPhotos() {
        ///given
        let mockDisplayLogic = MockCreatePhotosWallDisplayLogic()
        sut.viewController = mockDisplayLogic
        ///when
        sut.presentPhotos(resource: [])
        ///then
        XCTAssert(mockDisplayLogic.displayPhotosCalled, "Presenting photos should ask view controller to display that")
    }
    
    func test_showCreatingSuccessShouldAskViewController() {
        ///given
        let mockDisplayLogic = MockCreatePhotosWallDisplayLogic()
        sut.viewController = mockDisplayLogic
        ///when
        sut.showCreatingSuccess()
        ///then
        XCTAssert(mockDisplayLogic.displayCreatingSuccessCalled)
    }
    
    func test_showCreatingFailureShouldAskViewController() {
        ///given
        let mockDisplayLogic = MockCreatePhotosWallDisplayLogic()
        sut.viewController = mockDisplayLogic
        ///when
        sut.showCreatingFailure()
        ///then
        XCTAssert(mockDisplayLogic.displayCreatingFailureCalled)
    }
    
    func test_whenShowDoneAlertShouldAskViewController() {
        let mockDisplayLogic = MockCreatePhotosWallDisplayLogic()
        sut.viewController = mockDisplayLogic
        sut.showDoneAlert()
        XCTAssert(mockDisplayLogic.displayDoneAlertCalled)
    }
}
