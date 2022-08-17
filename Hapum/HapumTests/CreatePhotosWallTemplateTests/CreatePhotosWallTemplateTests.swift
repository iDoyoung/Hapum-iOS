//
//  CreatePhotosWallTemplateTests.swift
//  HapumTests
//
//  Created by Doyoung on 2022/08/16.
//

import XCTest
@testable import Hapum

class CreatePhotosWallTemplateTests: XCTestCase {
    //MARK: System under test
    var sut: CreatePhotosWallTemplateViewController!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = CreatePhotosWallTemplateViewController()
    }
    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }
    //MARK: - Test doubles
    class CreatePhotosWallTemplateBusinessLogicSpy: CreatePhotosWallTemplateBusinessLogic {
        var addPhotoFrameCalled = false
        var updatePhotoFrameCalled = false
        var createPhotosWallTemplateCalled = false
        
        func addPhotoFrame(_ photoFrame: PhotoFrame) {
            addPhotoFrameCalled = true
        }
        
        func updatePhotoFrame(_ photoFrame: PhotoFrame) {
            updatePhotoFrameCalled = true
        }
        
        func createPhotosWallTemplate(_ photoWall: PhotosWall) {
            createPhotosWallTemplateCalled = true
        }
    }
    //MARK: - Tests
    func test_createPhotoWallTemplate_whenPhotosFrameWallTemplateIsNotNil_shouldBeCallInteractor() {
        //given
        let createPhotosWallTemplateBusinessLogicSpy = CreatePhotosWallTemplateBusinessLogicSpy()
        sut.interactor = createPhotosWallTemplateBusinessLogicSpy
        sut.photosFrameWallTemplate = Seeds.PhotosWallDummy.photosWallMock
        //when
        sut.createPhotoWallTemplate()
        //then
        XCTAssert(createPhotosWallTemplateBusinessLogicSpy.createPhotosWallTemplateCalled)
    }
    
    func test_createPhotoWallTemplate_whenPhotosFrameWallTemplateIsNil_shouldBeNotCallInteractor() {
        //given
        let createPhotosWallTemplateBusinessLogicSpy = CreatePhotosWallTemplateBusinessLogicSpy()
        sut.interactor = createPhotosWallTemplateBusinessLogicSpy
        //when
        sut.createPhotoWallTemplate()
        //then
        XCTAssert(!createPhotosWallTemplateBusinessLogicSpy.createPhotosWallTemplateCalled)
    }
}
