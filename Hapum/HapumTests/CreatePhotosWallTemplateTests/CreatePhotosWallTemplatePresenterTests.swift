//
//  CreatePhotosWallTemplatePresenterTests.swift
//  HapumTests
//
//  Created by Doyoung on 2022/07/10.
//

import XCTest

@testable import Hapum

class CreatePhotosWallTemplatePresenterTests: XCTestCase {
    //MARK: - System under test
    var sut: CreatePhotosWallTemplatePresenter!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = CreatePhotosWallTemplatePresenter()
    }
    override func tearDownWithError() throws {
        sut = nil
    }

    //MARK: - Test doubles
    private class CreatePhotosWallTemplateDisplayLogicSpy: CreatePhotosWallTemplateDisplayLogic {
        var displayUpdatedPhotosWallViewCalled = false
        var displaySuccessAddPhotosWallTemplateCalled = false
        var displayFailureAddPhotosWallTemplateCalled = false
        
        func displayUpdatedPhotosWallView(viewModel: PhotoFrame.ViewModel) {
            displayUpdatedPhotosWallViewCalled = true
        }
        func displaySuccessAddPhotosWallTemplate() {
            displaySuccessAddPhotosWallTemplateCalled = true
        }
                func displayFailureAddPhotosWallTemplate() {
            displayFailureAddPhotosWallTemplateCalled = true
        }
    }
    
    //MARK: - Tests
//    func test_shouldCallDisplayUpdatedPhotosWallView_whenPresentUpdatedWallView() {
//        //given
//        let createPhotosWallTemplateDisplayLogicSpy = CreatePhotosWallTemplateDisplayLogicSpy()
//        sut.viewController = createPhotosWallTemplateDisplayLogicSpy
//        //when
//        sut.pre
//        sut.presentUpdatedWallView(response: Seeds.photoFrameMock)
//        //then
//        XCTAssert(createPhotosWallTemplateDisplayLogicSpy.displayUpdatedPhotosWallViewCalled, "Should call displayUpdatedPhotosWallView in View Controller")
//    }
}
