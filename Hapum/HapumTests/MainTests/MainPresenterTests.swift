//
//  MainPresenterTests.swift
//  HapumTests
//
//  Created by Doyoung on 2022/04/08.
//

import XCTest

@testable import Hapum

class MainPresenterTests: XCTestCase {

    var sut: MainPresenter!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = MainPresenter()
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }

    //MARK: - Mock
    class MockMainDisplayLogic: MainDisplayLogic {
        
        var displayFetchedPhotosCalled = false
        var displayFetchedAlbumCalled = false
        
        var viewModel: [Photos.Photo]!
        
        func displayFetchedPhotos(viewModel: [Photos.Photo]?) {
            displayFetchedPhotosCalled = true
            self.viewModel = viewModel
        }
        
        func displayFetchedAlbum(viewModel: [Photos.Photo]?) {
            displayFetchedAlbumCalled = true
            self.viewModel = viewModel
        }
        
    }
    //MARK: - Test
    func test_presentFetchedPhotosShouldAskViewControllerToDisplayFetchedPhotos() {
        ///given
        let mockMainDisplayLogic = MockMainDisplayLogic()
        sut.viewController = mockMainDisplayLogic
        ///when
        sut.presentFetchedAllPhotos(resource: [])
        ///then
        XCTAssert(mockMainDisplayLogic.displayFetchedPhotosCalled, "Presenting fetched photos should ask view controller to display them")
    }
    
    func test_presentFetchedAlbumsShouldFormatedPhotosForDisplay() {
        ///given
        let mockMainDisplayLogic = MockMainDisplayLogic()
        sut.viewController = mockMainDisplayLogic
        ///when
        sut.presentFetchedAlbums(resource: [])
        ///then
        XCTAssert(mockMainDisplayLogic.displayFetchedAlbumCalled, "Presenting fetched album should ask view controller to display them")
    }
    
}
