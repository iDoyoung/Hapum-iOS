//
//  MainPresenter.swift
//  Hapum
//
//  Created by Doyoung on 2022/04/05.
//

import Foundation

protocol MainPresentationLogic {
    func presentFetchedAllPhotos(resource: [Photos.Asset]?)
    func presentFetchedAlbums(resource: [Photos.Asset]?)
    func presentPhotosAccessStatus(message: String?)
}

final class MainPresenter: MainPresentationLogic {
    
    weak var viewController: MainDisplayLogic?
    
    func presentPhotosAccessStatus(message: String?) {
        
    }
    
    func presentFetchedAllPhotos(resource: [Photos.Asset]?) {
        viewController?.displayFetchedPhotos(viewModel: resource)
    }
    
    func presentFetchedAlbums(resource: [Photos.Asset]?) {
        viewController?.displayFetchedAlbum(viewModel: resource)
    }
    
}
