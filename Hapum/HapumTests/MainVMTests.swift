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
                Photo(identifier: "2", image: nil, creationDate: Date(), location: nil),
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
    
    func test_existWhenFilterByToday() {
        let guess = [
            Photo(identifier: "2", image: nil, creationDate: Date(), location: nil)
        ].map {
                $0.identifier
            }
        sut.filterPhotos(by: .today)
        let result = sut.filteredPhotos!.map {
            $0.identifier
        }
        XCTAssertEqual(guess, result)
    }
    
    func test_WhenFilterByToday() {
        let guess = [Photo]()
        sut.filterPhotos(by: .today)
        XCTAssertEqual(guess, sut.filteredPhotos)
    }
    
    func test_whenFilterByAll() {
        let guess = [Photo(identifier: "1", image: nil, creationDate: nil, location: nil),
            Photo(identifier: "2", image: nil, creationDate: nil, location: nil),
            Photo(identifier: "3", image: nil, creationDate: nil, location: nil)]
        sut.filterPhotos(by: .all)
        XCTAssertEqual(guess, sut.filteredPhotos)
    }
    
}
