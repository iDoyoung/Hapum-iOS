//
//  PhotoWallCoreDataStorage.swift
//  Hapum
//
//  Created by Doyoung on 2022/07/22.
//

import CoreData

enum CoreDataStoreError: Error {
    case readError(Error)
    case saveError(Error)
    case deleteError(Error)
}

final class PhotoWallCoreDataStorage: PhotoWallStorable {
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "HapumDataModel")
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
        return container
    }()
    
    func createPhotoWall(_ photoWall: PhotoWall, completion: @escaping () -> Void) {
    }
    
    func fetchPhotoWall(_ photoWall: PhotoWall, completion: @escaping ([PhotoWall], CoreDataStoreError?) -> Void) {
        persistentContainer.performBackgroundTask { context in
            do {
                let request = ManagedPhotoWall.fetchRequest()
                let results = try context.fetch(request)
                let photoWalls = results.map { $0.toPhotoWall() }
                completion(photoWalls, nil)
            } catch {
                completion([], CoreDataStoreError.readError(error))
            }
        }
    }
    
    func updatePhotoWall(to photoWall: PhotoWall, completion: @escaping () -> Void) {
    }
    
    func deletePhotoWall(id: UUID, completion: @escaping () -> Void) {
    }
        
}

protocol PhotoWallStorable {
        
    func createPhotoWall(_ photoWall: PhotoWall, completion: @escaping () -> Void)
    func fetchPhotoWall(_ photoWall: PhotoWall, completion: @escaping ([PhotoWall], CoreDataStoreError?) -> Void)
    func updatePhotoWall(to photoWall: PhotoWall, completion: @escaping () -> Void)
    func deletePhotoWall(id: UUID, completion: @escaping () -> Void)
    
}
