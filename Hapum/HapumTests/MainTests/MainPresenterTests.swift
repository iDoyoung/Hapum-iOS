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
        
        var displayPhotosAccessStatusMessageCalled = false
        var displayFetchedPhotosCalled = false
        var displayFetchedAlbumCalled = false
        
        var viewModel: [Photos.Asset]!
        var message: String?
        
        func displayPhotosAccessStatusMessage(viewModel: Photos.Status.Response) {
            displayPhotosAccessStatusMessageCalled = true
            self.message = viewModel.message
        }
        
        func displayFetchedPhotos(viewModel: [Photos.Asset]?) {
            displayFetchedPhotosCalled = true
            self.viewModel = viewModel
        }
        
        func displayFetchedAlbum(viewModel: [Photos.Asset]?) {
            displayFetchedAlbumCalled = true
            self.viewModel = viewModel
        }
        
    }
    //MARK: - Test
    func test_presentFetchedPhotos() {
        let mockMainDisplayLogic = MockMainDisplayLogic()
        sut.viewController = mockMainDisplayLogic
        sut.presentPhotosAccessStatus(response: Photos.Status.Response(message: nil,
                                                                       isLimited: nil))
        XCTAssert(mockMainDisplayLogic.displayPhotosAccessStatusMessageCalled)
    }
    
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
