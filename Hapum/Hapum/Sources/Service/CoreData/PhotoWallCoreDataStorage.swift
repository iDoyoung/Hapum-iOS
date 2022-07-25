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
    
    func createPhotoWall(_ photoWall: PhotoWall, completion: @escaping (PhotoWall, CoreDataStoreError?) -> Void) {
        persistentContainer.performBackgroundTask { context in
            let managedPhotoWall = ManagedPhotoWall(context: context)
            managedPhotoWall.fromPhotoWall(photoWall, context: context)
            
            if context.hasChanges {
                do {
                try context.save()
                    completion(photoWall, nil)
                } catch let error {
                    completion(photoWall, CoreDataStoreError.saveError(error))
                }
            }
        }
    }
    
    func fetchPhotoWall(completion: @escaping ([PhotoWall], CoreDataStoreError?) -> Void) {
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
    
    func deletePhotoWall(_ photoWall: PhotoWall, completion: @escaping (PhotoWall, CoreDataStoreError?) -> Void) {
        persistentContainer.performBackgroundTask { context in
            do {
                let request = ManagedPhotoWall.fetchRequest()
                request.predicate = NSPredicate(format: "id==%@", photoWall.id as CVarArg)
                let results = try context.fetch(request)
                if let managedPhotoWall = results.first {
                    context.delete(managedPhotoWall)
                    try context.save()
                    completion(photoWall, nil)
                }
            } catch {
                completion(photoWall, CoreDataStoreError.deleteError(error))
            }
        }
    }
        
}

protocol PhotoWallStorable {
        
    func createPhotoWall(_ photoWall: PhotoWall, completion: @escaping (PhotoWall, CoreDataStoreError?) -> Void)
    func fetchPhotoWall(completion: @escaping ([PhotoWall], CoreDataStoreError?) -> Void)
    func updatePhotoWall(to photoWall: PhotoWall, completion: @escaping () -> Void)
    func deletePhotoWall(_ photoWall: PhotoWall, completion: @escaping (PhotoWall, CoreDataStoreError?) -> Void)
    
}
