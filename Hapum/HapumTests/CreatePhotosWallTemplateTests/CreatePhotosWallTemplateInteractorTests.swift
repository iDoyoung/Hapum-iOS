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
       
        var presentUpdatedWallViewCalled = false
        var presentSuccessCreatePhotosWallTemplateCalled = false
        var presentFailureCreatePhotosWallTemplaterCalled = false
        
        func presentUpdatedWallView(response: PhotoFrame) {
            presentUpdatedWallViewCalled = true
        }
        
        func presentSuccessCreatePhotosWallTemplate() {
            presentSuccessCreatePhotosWallTemplateCalled = true
        }
        
        func presentFailureCreatePhotosWallTemplate() {
            presentFailureCreatePhotosWallTemplaterCalled = true
        }
        
    }
    
    //MARK: - Tests
    func test_shouldCalledPresentUpdatedWallView_whenAddPhotoFrame() {
        //given
        let createPhotosWallTemplatePresentationLogicSpy = CreatePhotosWallTemplatePresentationLogicSpy()
        sut.presenter = createPhotosWallTemplatePresentationLogicSpy
        //when
        sut.addPhotoFrame(Seeds.photoFrame)
        //then
        XCTAssert(createPhotosWallTemplatePresentationLogicSpy.presentUpdatedWallViewCalled, "Should call presentUpdatedWallView() in Presenter")
    }
}
