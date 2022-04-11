//
//  MainViewControllerTests.swift
//  HapumTests
//
//  Created by Doyoung on 2022/04/11.
//

import XCTest

@testable import Hapum

class MainViewControllerTests: XCTestCase {

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
    
    //MARK: - Mock
    class MockBusinessLogic: MainBusinessLogic {
        
        var fetchPhotosCalled = false
        
        func fetchPhotos() {
            fetchPhotosCalled = true
        }
        
    }
    
    //MARK: - Test
    func test_shouldFetchOrderWhenViewDidLoad() {
        ///given
        let mockBusinessLogic = MockBusinessLogic()
        sut.interactor = mockBusinessLogic
        loadView()
        ///when
        sut.viewDidLoad()
        ///then
        XCTAssert(mockBusinessLogic.fetchPhotosCalled, "Should fetch photos right after the view did load")
    }
    
    func test_sholdDisplayFetchedPhotos() {
        ///given
        
        ///when
        
        ///then
        
    }
    
}
