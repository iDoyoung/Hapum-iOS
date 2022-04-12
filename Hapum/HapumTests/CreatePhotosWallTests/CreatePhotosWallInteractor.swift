//
//  CreatePhotosWallInteractor.swift
//  HapumTests
//
//  Created by Doyoung on 2022/04/12.
//

import XCTest

@testable import Hapum

class CreatePhotosWallInteractorTestes: XCTestCase {

    var sut: CreatePhotosWallInteractor!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = CreatePhotosWallInteractor()
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }
    
    //MARK: - Mock
    class MockCreatePhotosWallPresentation: CreatePhotosWallPresentationLogic {
        
        var presentPhotosCalled = false
        
        func presentPhotos(response: [Photos.Photo]) {
            presentPhotosCalled = true
        }
    }
    
    //MARK: - Test
    func test_getPhotosShouldAskPreseterToFormat() {
        ///given
        let mockPresenter = MockCreatePhotosWallPresentation()
        sut.presenter = mockPresenter
        sut.photos = []
        ///when
        sut.getPhotos()
        ///then
        XCTAssert(mockPresenter.presentPhotosCalled, "GetPhotos() should ask presenter to format photos")
    }
    
}
