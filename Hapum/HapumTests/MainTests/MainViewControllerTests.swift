//
//  MainViewControllerTests.swift
//  HapumTests
//
//  Created by Doyoung on 2022/04/11.
//

import XCTest

@testable import Hapum

class MainViewControllerTests: XCTestCase {

    //MARK: - System under test
    var sut: MainViewController!
    var window: UIWindow!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        window = UIWindow()
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        sut = storyboard.instantiateViewController(withIdentifier: "MainViewController") as? MainViewController
    }

    override func tearDownWithError() throws {
        sut = nil
        window = nil
        try super.tearDownWithError()
    }
    
    func loadView() {
        window.addSubview(sut.view)
    }
    
    //MARK: - Test doubles
    class MainBusinessLogicSpy: MainBusinessLogic {
        
        var fetchPhotosCalled = false
        var fetchAlbumsPhotosCalled = false
        var fetchPhotosAccessStatusCalled = false
        
        func fetchPhotos() {
            fetchPhotosCalled = true
        }
        
        func fetchAlbumsPhotos() {
            fetchAlbumsPhotosCalled = true
        }
        
        func fetchPhotos(width: Float, height: Float) {
            fetchPhotosCalled = true
        }
        
        func fetchPhotosAccessStatus() {
            fetchPhotosAccessStatusCalled = true
        }
       
    }
    
    //MARK: - Tests
    func test_shouldFetchPhotosByInteractor_whenViewWillAppear() {
        //given
        let mainBusinessLogicSpy = MainBusinessLogicSpy()
        sut.interactor = mainBusinessLogicSpy
        loadView()
        //when
        sut.viewWillAppear(true)
        //then
        XCTAssert(mainBusinessLogicSpy.fetchPhotosCalled, "Should fetch photos right after the view will appear")
    }
    
    func test_sholdFetchPhotosAccessStatusCalled_whenViewWillApear() {
        //given
        let mainBusinessLogicSpy = MainBusinessLogicSpy()
        sut.interactor = mainBusinessLogicSpy
        loadView()
        //when
        sut.viewWillAppear(true)
        //then
        XCTAssert(mainBusinessLogicSpy.fetchPhotosAccessStatusCalled, "Should request photos access status right after the view will appear")
    }
    
}
