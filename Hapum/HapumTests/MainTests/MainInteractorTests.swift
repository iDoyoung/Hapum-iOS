//
//  MainInteractorTests.swift
//  HapumTests
//
//  Created by Doyoung on 2022/04/08.
//

import XCTest
import Photos

@testable import Hapum

class MainInteractorTests: XCTestCase {

    //MARK: - System under test
    var sut: MainInteractor!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = MainInteractor()
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }

    //MARK: - Test doubles
    class MainPresentationLogicSpy: MainPresentationLogic {
        var presentFetchedAllPhotosCalled = false
        var presentFetchedAlbumsCalled = false
        var presentAuthorizedPhotosAccessStatusCalled = false
        var presentLimitedPhotosAccessStatusCalled = false
        var presentRestrictedPhotosAccessStatusCalled = false
        
        func presentFetchedAllPhotos(resource: PHFetchResult<PHAsset>?) {
            presentFetchedAllPhotosCalled = true
        }
        func presentFetchedAlbums(resource: PHFetchResult<PHAsset>?) {
            presentFetchedAlbumsCalled = true
        }
        func presentAuthorizedPhotosAccessStatus() {
            presentAuthorizedPhotosAccessStatusCalled = true
        }
        func presentLimitedPhotosAccessStatus() {
            presentLimitedPhotosAccessStatusCalled = true
        }
        func presentRestrictedPhotosAccessStatus() {
            presentRestrictedPhotosAccessStatusCalled = true
        }
    }
    class PhotosWorkerSpy: PhotosWorker {
        var fetchAllPhotosCalled = false
        var fetchAlbumsPhotosCalled = false
        var fetchAccessStatusCalled = false
        var addPhotoAssetCalled = false
        
        var fetchedResult: Result<PHFetchResult<PHAsset>, PhotosError>?
        var authorizationStatus: PHAuthorizationStatus?
       
        override func fetchAccessStatus(completion: @escaping (PHAuthorizationStatus) -> Void) {
            fetchAccessStatusCalled = true
            completion(authorizationStatus!)
        }
        override func fetchAllPhotos(completion: @escaping PhotosWorker.CompletionHandler) {
            fetchAllPhotosCalled = true
            completion(fetchedResult!)
        }
        override func fetchAlbumsPhotos(completion: @escaping PhotosWorker.CompletionHandler) {
            fetchAlbumsPhotosCalled = true
            completion(fetchedResult!)
        }
        override func addPhotoAsset(_ photo: UIImage, completion: @escaping () -> Void) {
            addPhotoAssetCalled = true
        }
    }
    
    class PhotosServiceSpy: PhotoServicing {
        var fetchReulst: Result<PHFetchResult<PHAsset>, PhotosError>?
        
        var fetchAllPhotosCalled = false
        var fetchAlbumPhotosCalled = false
        var addAssetCalled = false
        var requestAccessStatusCalled = false
        
        func fetchAllPhotos(completion: @escaping (Result<PHFetchResult<PHAsset>, PhotosError>) -> Void) {
            fetchAllPhotosCalled = true
        }
        func fetchAlbumPhotos(completion: @escaping (Result<PHFetchResult<PHAsset>, PhotosError>) -> Void) {
            fetchAlbumPhotosCalled = true
        }
        func addAsset(of image: UIImage, completion: @escaping () -> Void) {
            addAssetCalled = true
        }
        func requestAccessStatus(completion: @escaping (PHAuthorizationStatus) -> Void) {
            requestAccessStatusCalled = true
        }
    }
    class PhotosWallWorkerSpy: PhotoWallWorker {
        var fetchPhotoWallsCalled = false
        override func fetchPhotoWalls(completion: @escaping ([PhotosWall]) -> Void) {
            completion([Seeds.PhotosWallDummy.photosWallMock])
            fetchPhotoWallsCalled = true
        }
    }
    class PhotosWallStroableSpy: PhotoWallStorable {
        func createPhotoWall(_ photoWall: PhotosWall, completion: @escaping (PhotosWall, CoreDataStoreError?) -> Void) {
        }
        func fetchPhotoWall(completion: @escaping ([PhotosWall], CoreDataStoreError?) -> Void) {
        }
        func updatePhotoWall(to photoWall: PhotosWall, completion: @escaping (PhotosWall, CoreDataStoreError?) -> Void) {
        }
        func deletePhotoWall(_ photoWall: PhotosWall, completion: @escaping (PhotosWall, CoreDataStoreError?) -> Void) {
        }
    }
        
    //MARK: - Test
    func test_shouldCallPresentLimitedPhotosAccessStatusAndAskPhotosWorkerWhenFetchedLimitedStatus() {
        //given
        let photosWorkerSpy = PhotosWorkerSpy(service: PhotosServiceSpy())
        let mainPresentationLogicSpy = MainPresentationLogicSpy()
        photosWorkerSpy.authorizationStatus = .limited
        sut.photosWorker = photosWorkerSpy
        sut.presenter = mainPresentationLogicSpy
        //when
        sut.fetchPhotosAccessStatus()
        //then
        XCTAssert(mainPresentationLogicSpy.presentLimitedPhotosAccessStatusCalled)
        XCTAssert(photosWorkerSpy.fetchAccessStatusCalled)
    }
    func test_shouldCallPresentAuthorizedPhotosAccessStatusAndAskPhotosWorkerWhenFetchedAuthorizedStatus() {
        //given
        let photosWorkerSpy = PhotosWorkerSpy(service: PhotosServiceSpy())
        let mainPresentationLogicSpy = MainPresentationLogicSpy()
        photosWorkerSpy.authorizationStatus = .authorized
        sut.photosWorker = photosWorkerSpy
        sut.presenter = mainPresentationLogicSpy
        //when
        sut.fetchPhotosAccessStatus()
        //then
        XCTAssert(mainPresentationLogicSpy.presentAuthorizedPhotosAccessStatusCalled)
        XCTAssert(photosWorkerSpy.fetchAccessStatusCalled)
    }
    func test_shouldCallPresentRestrictedPhotosAccessStatusAndAskPhotosWorkerWhenFetchedRestrictedStatus() {
        //given
        let photosWorkerSpy = PhotosWorkerSpy(service: PhotosServiceSpy())
        let mainPresentationLogicSpy = MainPresentationLogicSpy()
        photosWorkerSpy.authorizationStatus = .restricted
        sut.photosWorker = photosWorkerSpy
        sut.presenter = mainPresentationLogicSpy
        //when
        sut.fetchPhotosAccessStatus()
        //then
        XCTAssert(mainPresentationLogicSpy.presentRestrictedPhotosAccessStatusCalled)
        XCTAssert(photosWorkerSpy.fetchAccessStatusCalled)
    }
    func test_shouldCallPresentRestrictedPhotosAccessStatusAndAskPhotosWorkerWhenFetchedDeniedStatus() {
        //given
        let photosWorkerSpy = PhotosWorkerSpy(service: PhotosServiceSpy())
        let mainPresentationLogicSpy = MainPresentationLogicSpy()
        photosWorkerSpy.authorizationStatus = .denied
        sut.photosWorker = photosWorkerSpy
        sut.presenter = mainPresentationLogicSpy
        //when
        sut.fetchPhotosAccessStatus()
        //then
        XCTAssert(mainPresentationLogicSpy.presentRestrictedPhotosAccessStatusCalled)
        XCTAssert(photosWorkerSpy.fetchAccessStatusCalled)
    }
    func test_shouldCallPresentRestrictedPhotosAccessStatusAndAskPhotosWorkerWhenFetchedNotDeterminedStatus() {
        //given
        let photosWorkerSpy = PhotosWorkerSpy(service: PhotosServiceSpy())
        let mainPresentationLogicSpy = MainPresentationLogicSpy()
        photosWorkerSpy.authorizationStatus = .notDetermined
        sut.photosWorker = photosWorkerSpy
        sut.presenter = mainPresentationLogicSpy
        //when
        sut.fetchPhotosAccessStatus()
        //then
        XCTAssert(mainPresentationLogicSpy.presentRestrictedPhotosAccessStatusCalled)
        XCTAssert(photosWorkerSpy.fetchAccessStatusCalled)
    }
    func test_shouldAskPhotosWorkerAndCallPresentFetchedAllPhotosAndResultIsSuccessWhenSuccessToFetchResult() {
        //given
        let expectResult = Seeds.PhotoResultAssetDummy.fetched
        let photoWorkerSpy = PhotosWorkerSpy(service: PhotosServiceSpy())// as! PhotosWorkerSpy
        let mainPresentationLogicSpy = MainPresentationLogicSpy()
        photoWorkerSpy.fetchedResult = .success(Seeds.PhotoResultAssetDummy.fetched)
        sut.photosWorker = photoWorkerSpy
        sut.presenter = mainPresentationLogicSpy
        //when
        sut.fetchPhotos()
        //then
        XCTAssertEqual(sut.fetchAllResult, expectResult, "FetchAllResult should equal expect")
        XCTAssert(photoWorkerSpy.fetchAllPhotosCalled, "FetchPhotos() should ask PhotosWorker to fetch photos")
        XCTAssert(mainPresentationLogicSpy.presentFetchedAllPhotosCalled, "FetchPhotos() should ask presenter to format photos")
    }
    func test_shouldAskPhotosWorkerAndCallPresentFetchedAlbumPhotosAndResultIsSuccessWhenSuccessToFetchResult() {
        //given
        let expectResult = Seeds.PhotoResultAssetDummy.fetched
        let photoWorkerSpy = PhotosWorkerSpy(service: PhotosServiceSpy())// as! PhotosWorkerSpy
        let mainPresentationLogicSpy = MainPresentationLogicSpy()
        photoWorkerSpy.fetchedResult = .success(Seeds.PhotoResultAssetDummy.fetched)
        sut.photosWorker = photoWorkerSpy
        sut.presenter = mainPresentationLogicSpy
        //when
        sut.fetchAlbumsPhotos()
        //then
        XCTAssertEqual(sut.fetchAlbumsResult, expectResult, "FetchAlbumsResult should equal expect")
        XCTAssert(photoWorkerSpy.fetchAlbumsPhotosCalled, "FetchAlbumsPhotos() should ask PhotosWorker to fetch photos")
        //XCTAssert(mainPresentationLogicSpy.presentFetchedAlbumsCalled, "FetchAlbumsPhotos() should ask presenter to format photos")
    }
    func test_fetchPhotosWallTemplate_whenReceiveSomeData_shouldCallPhotoWallAndReturnData() {
        //given
        let photosWallWorkerSpy = PhotosWallWorkerSpy(photoWallStorage: PhotosWallStroableSpy())
        sut.photoWallWorker = photosWallWorkerSpy
        //when
        sut.fetchPhotosWallTemplate()
        //then
        XCTAssert(photosWallWorkerSpy.fetchPhotoWallsCalled)
        XCTAssertEqual(sut.photosWallTemplates, [Seeds.PhotosWallDummy.photosWallMock])
    }
}
