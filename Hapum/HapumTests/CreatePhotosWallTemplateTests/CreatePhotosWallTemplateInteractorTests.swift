//
//  CreatePhotosWallTemplateInteractorTests.swift
//  HapumTests
//
//  Created by Doyoung on 2022/07/10.
//

import XCTest

@testable import Hapum

class CreatePhotosWallTemplateInteractorTests: XCTestCase {
    //MARK: - System under test
    var sut: CreatePhotosWallTemplateInteractor!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = CreatePhotosWallTemplateInteractor()
    }
    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }

    //MARK: - Test doubles
    private class CreatePhotosWallTemplatePresentationLogicSpy: CreatePhotosWallTemplatePresentationLogic {
        var photosWallMock: PhotosWall.Response?
        var presentUpdatedWallViewCalled = false
        var presentSuccessCreatePhotosWallTemplateCalled = false
        var presentFailureCreatePhotosWallTemplaterCalled = false
        
        func presentUpdatedWallView(response: PhotoFrame.Response) {
            presentUpdatedWallViewCalled = true
        }
        func presentSuccessCreatePhotosWallTemplate(_ photoWall: PhotosWall.Response) {
            presentSuccessCreatePhotosWallTemplateCalled = true
            photosWallMock = photoWall
        }
        func presentFailureCreatePhotosWallTemplate() {
            presentFailureCreatePhotosWallTemplaterCalled = true
        }
    }
    private class PhotoWallWorkerSpy: PhotoWallWorker {
        var createPhotoWallCalled = false
        
        override func createPhotoWall(_ photoWall: PhotosWall.Response, completion: @escaping (PhotosWall.Response) -> Void) {
            createPhotoWallCalled = true
            completion(photoWall)
        }
    }
   
    //MARK: - Tests
    func test_shouldCalledPresentSuccessCreatePhotoWallTemplate_askWorkerToCallCreatePhotoWall_presenterGetPhotosWall_whenCreatPhotosWallTemplate() {
        //given
        let photosWallWorkerSpy = PhotoWallWorkerSpy(photoWallStorage: PhotoWallCoreDataStorage())
        let createPhotosWallTemplatePresentationLogicSpy = CreatePhotosWallTemplatePresentationLogicSpy()
        let testPhotosWall = Seeds.PhotosWallDummy.photosWallMock
        sut.photoWallWorker = photosWallWorkerSpy
        sut.presenter = createPhotosWallTemplatePresentationLogicSpy
        //when
        sut.createPhotosWallTemplate([])
        //then
        XCTAssert(photosWallWorkerSpy.createPhotoWallCalled)
        XCTAssert(createPhotosWallTemplatePresentationLogicSpy.presentSuccessCreatePhotosWallTemplateCalled)
        XCTAssertEqual(createPhotosWallTemplatePresentationLogicSpy.photosWallMock, testPhotosWall)
    }
}
