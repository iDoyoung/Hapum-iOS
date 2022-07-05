//
//  CreatePhotosWallInteractor.swift
//  HapumTests
//
//  Created by Doyoung on 2022/04/12.
//

import XCTest
import Photos

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
    
    //MARK: - Test double
    class CreatePhotosWallPresentationSpy: CreatePhotosWallPresentationLogic {
        
        var presentPhotosCalled = false
        var showCameraTypeImagePickerCalled = false
        var showDoneAlertCalled = false
        var showCreatingSuccessCalled = false
        var showCreatingFailureCalled = false
        var showAuthorizationStatusCalled = false
        
        func presentPhotos(resource: PHFetchResult<PHAsset>?) {
            presentPhotosCalled = true
        }
        
        func showCameraTypeImagePicker() {
            showCameraTypeImagePickerCalled = true
        }
        
        func showDoneAlert() {
            showDoneAlertCalled = true
        }
        
        func showCreatingSuccess() {
            showCreatingSuccessCalled = true
        }
        
        func showCreatingFailure() {
            showCreatingFailureCalled = true
        }
        
        func showAuthorizationStatus() {
            showAuthorizationStatusCalled = true
        }
        
    }
    
    class PhotosWorkerSpy: PhotosWorker {
        
        var addPhotoAssetCalled = false
        
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
    
    
    //MARK: - Tests
    func test_shouldCallPresentPhotosInPresenter_whenGetPhotos() {
        //given
        let createPhotosWallPresentationSpy = CreatePhotosWallPresentationSpy()
        sut.presenter = createPhotosWallPresentationSpy
        //when
        sut.getPhotos()
        //then
        XCTAssert(createPhotosWallPresentationSpy.presentPhotosCalled, "Should call Presenter")
    }
    
}
