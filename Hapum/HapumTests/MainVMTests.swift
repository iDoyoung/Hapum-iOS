//
//  HapumTests.swift
//  HapumTests
//
//  Created by Doyoung on 2022/03/27.
//

import XCTest
import Photos

@testable import Hapum

class MockPhotosServic: PhotoFetchable {
    func fetchPhotos() -> [Photo] {
        return [Photo(identifier: "1", image: nil, creationDate: nil, location: nil),
                Photo(identifier: "2", image: nil, creationDate: nil, location: nil),
                Photo(identifier: "3", image: nil, creationDate: nil, location: nil)]
    }
}

class MainVMTests: XCTestCase {

    var sut: MainViewModel!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = MainViewModel(service: MockPhotosServic())
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }
    
    func test_fetchPhotosWhenUpdate() {
        //given
        let guess = [Photo(identifier: "1", image: nil, creationDate: nil, location: nil),
                     Photo(identifier: "2", image: nil, creationDate: nil, location: nil),
                     Photo(identifier: "3", image: nil, creationDate: nil, location: nil)]
        //when
        sut.updatePhotos()
        //then
        XCTAssertEqual(guess, sut.allPhotos)
    }
}
