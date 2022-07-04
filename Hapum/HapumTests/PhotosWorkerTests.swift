//
//  PhotosServiceTest.swift
//  HapumTests
//
//  Created by Doyoung on 2022/04/07.
//

import XCTest
import Photos

@testable import Hapum

class PhotosWorkerTests: XCTestCase {

    //MARK: - System under test
    var sut: PhotosWorker!

    static var testPhotoFetchResult: Result<PHFetchResult<PHAsset>, PhotosError>!
    static var testPhotoAuthorizationStatus: PHAuthorizationStatus!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = PhotosWorker(service: PhotosServiceSpy())
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }
    
    //MARK: Test doubles
    class PhotosServiceSpy: PhotoServicing {
       
        var fetchAllPhotosCalled = false
        var fetchAlbumPhotosCalled = false
        var addAssetCalled = false
        var requestAccessStatusCalled = false
        
        func fetchAllPhotos(completion: @escaping (Result<PHFetchResult<PHAsset>, PhotosError>) -> Void) {
            fetchAllPhotosCalled = true
            completion(PhotosWorkerTests.testPhotoFetchResult)
        }
        
        func fetchAlbumPhotos(completion: @escaping (Result<PHFetchResult<PHAsset>, PhotosError>) -> Void) {
            fetchAlbumPhotosCalled = true
            completion(PhotosWorkerTests.testPhotoFetchResult)
        }
        
        func addAsset(of image: UIImage, completion: @escaping () -> Void) {
            addAssetCalled = true
            completion()
        }
        
        func requestAccessStatus(completion: @escaping (PHAuthorizationStatus) -> Void) {
            requestAccessStatusCalled = true
            completion(PhotosWorkerTests.testPhotoAuthorizationStatus)
        }

    }

    //MARK: - Test
    func test_requestAccessStatusShouldAskPhotosServiceAndReturnStatus() {
        //given
        PhotosWorkerTests.testPhotoAuthorizationStatus = .authorized
        let accessStatus: PHAuthorizationStatus = .authorized
        let mockPhotosService = sut.service as! PhotosServiceSpy
        let expect = expectation(description: "Wait for requestAccessStatus() to return")
        //when
        sut.service.requestAccessStatus { status in
            expect.fulfill()
        }
        waitForExpectations(timeout: 1.0)
        ///then
        XCTAssert(mockPhotosService.requestAccessStatusCalled, "Calling requestAccessStatus() should ask the Photo Service for access photos")
        XCTAssertEqual(accessStatus, PhotosWorkerTests.testPhotoAuthorizationStatus, "Requested access status match the status in the test")
    }
    
    func test_addAssetsShouldAskPhotosService() {
        //given
        let mockPhotosService = sut.service as! PhotosServiceSpy
        //when
        sut.addPhotoAsset(Seeds.ImageDummy.image!) {
        }
        //then
        XCTAssert(mockPhotosService.addAssetCalled, "Calling addPhotoAsset() should ask the Photo Service for add photo")
    }
    
    func test_fetchAllPhotosShouldAskPhotosServiceAndBeSuccessFetched() {
        //given
        PhotosWorkerTests.testPhotoFetchResult = .success(Seeds.PhotoResultAssetDummy.fetched)
        let mockPhotosService = sut.service as! PhotosServiceSpy
        var fetchedPhotos: PHFetchResult<PHAsset>!
        //when
        let expectedResult = try! PhotosWorkerTests.testPhotoFetchResult.get()
        sut.fetchAllPhotos { result in
            fetchedPhotos = try! result.get()
        }
        //then
        XCTAssert(mockPhotosService.fetchAllPhotosCalled, "Calling fetchPhotos() should ask the Photo Service for all of photos")
        XCTAssertEqual(fetchedPhotos, expectedResult, "Requested fetch photo asset match the asset in the test")
    }
    
    func test_fetchAlbumPhotosShoulAskPhotosServiceAndBeSuccessFetched() {
        //given
        PhotosWorkerTests.testPhotoFetchResult = .success(Seeds.PhotoResultAssetDummy.fetched)
        let mockPhotosService = sut.service as! PhotosServiceSpy
        var fetchedPhotos: PHFetchResult<PHAsset>!
        //when
        let expectedResult = try! PhotosWorkerTests.testPhotoFetchResult.get()
        sut.fetchAlbumsPhotos { result in
            fetchedPhotos = try! result.get()
        }
        //then
        XCTAssert(mockPhotosService.fetchAlbumPhotosCalled, "Calling fetchAlbumPhotos() should ask the Photo Service for a album's photos")
        XCTAssertEqual(fetchedPhotos, expectedResult, "Requested fetch photo asset match the asset in the test")
    }
    
}
