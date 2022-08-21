//
//  CreatePhotosWallTemplateTests.swift
//  HapumTests
//
//  Created by Doyoung on 2022/08/16.
//

import XCTest
@testable import Hapum

class CreatePhotosWallTemplateViewControllerTests: XCTestCase {
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
        var createPhotosWallTemplateCalled = false
        
        func createPhotosWallTemplate(_ photos: [FrameView]) {
            createPhotosWallTemplateCalled = true
        }
    }
    //MARK: - Tests
    func test_createPhotoWallTemplate_whenPhotosFrameWallTemplateIsNotNil_shouldBeCallInteractor() {
        //given
        let createPhotosWallTemplateBusinessLogicSpy = CreatePhotosWallTemplateBusinessLogicSpy()
        sut.interactor = createPhotosWallTemplateBusinessLogicSpy
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
