//
//  MainPresenter.swift
//  Hapum
//
//  Created by Doyoung on 2022/04/05.
//

import Foundation

protocol MainPresentationLogic {
    func presentFetchedAllPhotos(resource: [Photos.Photo]?)
    func presentFetchedAlbums(resource: [Photos.Photo]?)
}

final class MainPresenter: MainPresentationLogic {
    
    weak var viewController: MainDisplayLogic?
    
    func presentFetchedAllPhotos(resource: [Photos.Photo]?) {
        viewController?.displayFetchedPhotos(viewModel: resource)
    }
    
    func presentFetchedAlbums(resource: [Photos.Photo]?) {
        viewController?.displayFetchedAlbum(viewModel: resource)
    }
    
}
