//
//  PhotosServiceTest.swift
//  HapumTests
//
//  Created by Doyoung on 2022/04/07.
//

import XCTest

@testable import Hapum

class PhotosWorkerTests: XCTestCase {

    var sut: PhotosWorker!
    static var testAccessStatus: Photos.Status!
    static var testPhotos: [Photos.Asset]!
    static var testAlbumsPhotos: [Photos.Asset]!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = PhotosWorker(service: MockPhotosService())
        PhotosWorkerTests.testAccessStatus = .limited
        PhotosWorkerTests.testPhotos = [Seeds.PhotosDummy.springPhoto, Seeds.PhotosDummy.summerPhoto, Seeds.PhotosDummy.fallsPhoto, Seeds.PhotosDummy.winterPhoto]
        PhotosWorkerTests.testAlbumsPhotos = [Seeds.PhotosDummy.winterPhoto, Seeds.PhotosDummy.springPhoto]
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }
    
    class MockPhotosService: PhotoFetchable {
       
        var requestAccessStatusCalled = false
        var fetchPhotosCalled = false
        var fetchPhotosFromAlbumsCalled = false
        var addAssetCalled = false
        
        func requestAccessStatus(completion: @escaping (Photos.Status?) -> Void) {
            requestAccessStatusCalled = true
            completion(PhotosWorkerTests.testAccessStatus)
        }
        
        func fetchPhotos(width: Float, height: Float, completion: @escaping ([Photos.Asset]) -> Void) {
            fetchPhotosCalled = true
            completion(PhotosWorkerTests.testPhotos)
        }
        
        func fetchPhotosFromAlbums(width: Float, height: Float, completion: @escaping ([Photos.Asset]) -> Void) {
            fetchPhotosFromAlbumsCalled = true
            completion(PhotosWorkerTests.testAlbumsPhotos)
        }
        
        func addAsset(photo: Photos.Photo, completion: @escaping (AddPhotoAssetError?) -> Void) {
            addAssetCalled = true
        }
    }

    //MARK: - Test
    func test_requestAccessStatusShouldReturnStatus() {
        ///given
        let mockPhotosService = sut.service as! MockPhotosService
        ///when
        var accessStatus: Photos.Status = .notDetermined
        let expect = expectation(description: "Wait for requestAccessStatus() to return")
        sut.service.requestAccessStatus { status in
            guard let status = status else {
                return
            }
            accessStatus = status
            expect.fulfill()
        }
        waitForExpectations(timeout: 1.0)
        ///then
        XCTAssert(mockPhotosService.requestAccessStatusCalled, "Calling requestAccessStatus() should ask the fetchable for access photos")
        XCTAssertEqual(accessStatus, PhotosWorkerTests.testAccessStatus, "Requested access status match the status in the test")
    }
    
    func test_addAssetsShouldAskPhotosService() {
        ///given
        let mockPhotosService = sut.service as! MockPhotosService
        ///when
        sut.addPhotoAsset(photo: Photos.Photo(image: Seeds.ImageDummy.image!)) { _ in
        }
        ///then
        XCTAssert(mockPhotosService.addAssetCalled)
    }
    
    func test_fetchPhotosShouldReturnPhotos() {
        ///given
        let mockPhotosService = sut.service as! MockPhotosService
        ///when
        var fetchedPhotos = [Photos.Asset]()
        let expect = expectation(description: "Wait for fetchPhotos() to return")
        sut.fetchAllPhotos(width: 0, height: 0) { photos in
            fetchedPhotos = photos
            expect.fulfill()
        }
        waitForExpectations(timeout: 1.0)
        ///then
        XCTAssert(mockPhotosService.fetchPhotosCalled, "Calling fetchPhotos() should ask the fetchable for all of photos")
        XCTAssertEqual(fetchedPhotos.count, PhotosWorkerTests.testPhotos.count, "fetchPhotos() should return all of photos")
        for photo in fetchedPhotos {
            XCTAssert(PhotosWorkerTests.testPhotos.contains(photo), "Fetched photo should match the photos in the test")
        }
    }
    
    func test_fetchPhotosFromAlbumsShouldReturnAlbumsPhotos() {
        ///given
        let mockPhotosService = sut.service as! MockPhotosService
        ///when
        var fetchedAlbums = [Photos.Asset]()
        let expect = expectation(description: "Wait for fetchAlbumsPhotos() to return")
        sut.fetchAlbumsPhotos(width: 0, height: 0) { photos in
            fetchedAlbums = photos
            expect.fulfill()
        }
        waitForExpectations(timeout: 1.0)
        ///then
        XCTAssert(mockPhotosService.fetchPhotosFromAlbumsCalled, "Calling fetchAlbumsPhotos() should ask the fetchable for a album's photos")
        XCTAssertEqual(fetchedAlbums.count, PhotosWorkerTests.testAlbumsPhotos.count, "fetchAlbums() should return a album's photos")
        for photo in fetchedAlbums {
            XCTAssert(PhotosWorkerTests.testAlbumsPhotos.contains(photo), "Fetched photo should match the album's photos in the test")
        }
    }
}
