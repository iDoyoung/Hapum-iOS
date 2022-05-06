//
//  CreatePhotosWallInteractor.swift
//  HapumTests
//
//  Created by Doyoung on 2022/04/12.
//

import XCTest

@testable import Hapum

class CreatePhotosWallInteractorTestes: XCTestCase {

    var sut: CreatePhotosWallInteractor!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = CreatePhotosWallInteractor()
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }
    
    //MARK: - Mock
    class MockCreatePhotosWallPresentation: CreatePhotosWallPresentationLogic {
        
        var presentPhotosCalled = false
        var showCameraTypeImagePickerCalled = false
        var showCreatingSuccessCalled = false
        var showCreatingFailureCalled = false
        var showDoneAlertCalled = false
        
        func presentPhotos(resource: [Photos.Asset]) {
            presentPhotosCalled = true
        }
        
        func showCameraTypeImagePicker() {
            showCameraTypeImagePickerCalled = true
        }
        
        func showCreatingSuccess() {
            showCreatingSuccessCalled = true
        }
        
        func showCreatingFailure() {
            showCreatingFailureCalled = true
        }
        
        func showDoneAlert() {
            showDoneAlertCalled = true
        }
    }
    
    class MockPhotosWorker: PhotosWorker {
        
        override func addPhotoAsset(photo: Photos.Photo, completion: @escaping ((Bool, Error?)) -> Void) {
            service.addAsset(photo: Photos.Photo(image: Seeds.ImageDummy.image!)) { (success, error) in
                completion((success, error))
            }
        }
        
    }
    
    class MockSuccessPhotosService: PhotoFetchable {
        func fetchPhotos(width: Float, height: Float, completion: @escaping ([Photos.Asset]) -> Void) {
        }
        
        func fetchPhotosFromAlbums(width: Float, height: Float, completion: @escaping ([Photos.Asset]) -> Void) {
        }
        
        func requestAccessStatus(completion: @escaping (Photos.Status?) -> Void) {
        }
        
        func addAsset(photo: Photos.Photo, completion: @escaping ((Bool, Error?)) -> Void) {
            completion((true, nil))
        }
    }
    
    class MockFailurePhotosService: PhotoFetchable {
        func fetchPhotos(width: Float, height: Float, completion: @escaping ([Photos.Asset]) -> Void) {
        }
        
        func fetchPhotosFromAlbums(width: Float, height: Float, completion: @escaping ([Photos.Asset]) -> Void) {
        }
        
        func requestAccessStatus(completion: @escaping (Photos.Status?) -> Void) {
        }
     
        
        func addAsset(photo: Photos.Photo, completion: @escaping ((Bool, Error?)) -> Void) {
            completion((false, nil))
        }
    }
    
    
    //MARK: - Test
    func test_whenFailAddPhotoAskPhotosWorkerToAddPhotoAndPresenterShowCreatingFailure () {
        ///given
        let mockPresenter = MockCreatePhotosWallPresentation()
        let mockPhotosWorker = MockPhotosWorker(service: MockFailurePhotosService())
        sut.presenter = mockPresenter
        sut.photosWorker = mockPhotosWorker
        ///when
        sut.addPhoto(photo: Photos.Photo(image: Seeds.ImageDummy.image!))
        ///then
        XCTAssert(mockPresenter.showCreatingFailureCalled)
    }
    
    func test_whenSuccessAddPhotoAskPhotosWorkerToAddPhotoAndPresenterShowCreatingSuccess() {
        ///given
        let mockPresenter = MockCreatePhotosWallPresentation()
        let mockPhotosWorker = MockPhotosWorker(service: MockSuccessPhotosService())
        sut.presenter = mockPresenter
        sut.photosWorker = mockPhotosWorker
        ///when
        sut.addPhoto(photo: Photos.Photo(image: Seeds.ImageDummy.image!))
        ///then
        XCTAssert(mockPresenter.showCreatingSuccessCalled)
    }
    
    func test_whenTrySavePhotosWallViewPresenterShowAlert() {
        let mockPresenter = MockCreatePhotosWallPresentation()
        sut.presenter = mockPresenter
        sut.trySavePhotosWallView()
        XCTAssert(mockPresenter.showDoneAlertCalled)
    }
    
}
