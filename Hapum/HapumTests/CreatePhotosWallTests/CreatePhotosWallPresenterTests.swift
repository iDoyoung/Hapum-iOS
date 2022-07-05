//
//  CreatePhotosWallPresenterTests.swift
//  HapumTests
//
//  Created by Doyoung on 2022/04/12.
//

import XCTest

@testable import Hapum

class CreatePhotosWallPresenterTests: XCTestCase {

    //MARK: - System under system
    var sut: CreatePhotosWallPresenter!

    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = CreatePhotosWallPresenter()
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }

    //MARK: - Test doubles
    class CreatePhotosWallDisplayLogicSpy: CreatePhotosWallDisplayLogic {
        
        var displayPhotosCalled = false
        
        func displayPhotos(viewModel: [UIImage]) {
            displayPhotosCalled = true
        }
        
        func displayCamera() {
        }
        
        func displayDoneAlert() {
        }
        
        func displayCreatingSuccess() {
        }
        
        func displayCreatingFailure() {
        }
        
        func displayRestrictedStatus() {
        }
        
    }

    //MARK: - Tests
    func test_shouldCallDisplayPhotosInViewController_whenPresentPhotos() {
        //given
        let createPhotosWallDisplayLogicSpy = CreatePhotosWallDisplayLogicSpy()
        sut.viewController = createPhotosWallDisplayLogicSpy
        //when
        sut.presentPhotos(resource: Seeds.PhotoResultAssetDummy.fetched)
        //then
        XCTAssert(createPhotosWallDisplayLogicSpy.displayPhotosCalled, "Should call display method in View controller")
    }
    
}
