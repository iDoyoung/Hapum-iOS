//
//  MainInteractorTests.swift
//  HapumTests
//
//  Created by Doyoung on 2022/04/08.
//

import XCTest

@testable import Hapum

class MainInteractorTests: XCTestCase {

    var sut: MainInteractor!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = MainInteractor()
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }

    //MARK: - Mock
    class MockMainPresentationLogic: MainPresentationLogic {
        
        var presentFetchedAllPhotosCalled = false
        var presentFetchedAlbumsCalled = false
        var presentPhotosAccessStatusCalled = false
        
        func presentFetchedAllPhotos(resource: [Photos.Asset]?) {
            presentFetchedAllPhotosCalled = true
        }
        
        func presentFetchedAlbums(resource: [Photos.Asset]?) {
            presentFetchedAlbumsCalled = true
        }
        
        func presentPhotosAccessStatus(message: String?) {
            presentPhotosAccessStatusCalled = true
        }
        
    }
    
    class MockPhotosWorker: PhotosWorker {
        
        var fetchAllPhotosCalled = false
        var fetchAlbumsPhotosCalled = false
        var fetchAccessStatusCalled = false
        
        override func fetchAllPhotos(completion: @escaping ([Photos.Asset]) -> Void) {
            fetchAllPhotosCalled = true
            completion([Seeds.PhotosDummy.springPhoto,
                        Seeds.PhotosDummy.summerPhoto,
                        Seeds.PhotosDummy.fallsPhoto,
                        Seeds.PhotosDummy.winterPhoto])
        }
        
        override func fetchAlbumsPhotos(completion: @escaping ([Photos.Asset]) -> Void) {
            fetchAlbumsPhotosCalled = true
            completion([Seeds.PhotosDummy.winterPhoto,
                        Seeds.PhotosDummy.springPhoto])
        }
        
        override func fetchAccessStatus(completion: @escaping (Photos.Status?) -> Void) {
            fetchAccessStatusCalled = true
            completion(.authorized)
        }
        
    }
    
    class MockPhotosService: PhotoFetchable {
        func addAsset(photo: Photos.Photo, completion: @escaping ((Bool, Error?)) -> Void) {
        }
        
        
        func requestAccessStatus(completion: @escaping (Photos.Status?) -> Void) {
            completion(.limited)
        }
        
        func fetchPhotos(completion: @escaping ([Photos.Asset]) -> Void) {
            completion([Seeds.PhotosDummy.springPhoto,
                        Seeds.PhotosDummy.summerPhoto,
                        Seeds.PhotosDummy.fallsPhoto,
                        Seeds.PhotosDummy.winterPhoto])
        }
        
        func fetchPhotosFromAlbums(completion: @escaping ([Photos.Asset]) -> Void) {
            completion([Seeds.PhotosDummy.winterPhoto,
                        Seeds.PhotosDummy.springPhoto
                       ])
        }
        
    }
    
    //MARK: - Test
    func test_fetchPhotosAccessStatusAsksPhotosWorkerAndPresenterToFromat() {
        ///given
        let mockMainPresentationLogic = MockMainPresentationLogic()
        let mockPhotoWorker = MockPhotosWorker(service: MockPhotosService())
        sut.presenter = mockMainPresentationLogic
        sut.photosWorker = mockPhotoWorker
        ///when
        sut.fetchPhotosAccessStatus()
        ///then
        XCTAssert(mockMainPresentationLogic.presentPhotosAccessStatusCalled)
        XCTAssert(mockPhotoWorker.fetchAccessStatusCalled)
    }
    func test_fetchPhotosShouldAsksPhotosWorkerToFetchPhotosAndPresenterToFormat() {
        ///given
        let mockMainPresentationLogic = MockMainPresentationLogic()
        let mockPhotosWorker = MockPhotosWorker(service: MockPhotosService())
        sut.presenter = mockMainPresentationLogic
        sut.photosWorker = mockPhotosWorker
        
        ///when
        sut.fetchPhotos()
        
        ///then
        XCTAssert(mockMainPresentationLogic.presentFetchedAllPhotosCalled, "FetchPhotos() should ask presenter to format photos")
        XCTAssert(mockPhotosWorker.fetchAllPhotosCalled, "FetchPhotos() should ask PhotosWorker to fetch photos")
    }
   
    func test_AlbumsPhotos() {
        ///given
        let mockMainPresentationLogic = MockMainPresentationLogic()
        let mockPhotosWorker = MockPhotosWorker(service: MockPhotosService())
        sut.presenter = mockMainPresentationLogic
        sut.photosWorker = mockPhotosWorker
        
        ///when
        sut.fetchAlbumsPhotos()
        
        ///then
        XCTAssert(mockMainPresentationLogic.presentFetchedAlbumsCalled, "FetchAlbumsPhotos() should ask presenter to format photos")
        XCTAssert(mockPhotosWorker.fetchAlbumsPhotosCalled, "FetchAlbumsPhotos() should ask PhotosWorker to fetch photos")
    }
    
}
