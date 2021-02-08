//
//  DataController.swift
//  ProyectoPersistencia
//
//  Created by Samuel Bautista Sánchez on 7/2/21.
//

import Foundation
import CoreData
import UIKit

class DataController: NSObject {
    private let persistentContainer: NSPersistentContainer

    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    @discardableResult
    init(modelName: String, optionalStoreName: String?, completionHandler: (@escaping (NSPersistentContainer?) -> ())) {
        if let optionalStoreName = optionalStoreName {
            let managedObjectModel = Self.manageObjectModel(with: modelName)
            self.persistentContainer = NSPersistentContainer(name: optionalStoreName,
                                                             managedObjectModel: managedObjectModel)
            super.init()

            persistentContainer.loadPersistentStores { [weak self] (description, error) in
                if let error = error {
                    fatalError("Couldn't load CoreData Stack \(error.localizedDescription)")
                }

                completionHandler(self?.persistentContainer)
            }

            persistentContainer.performBackgroundTask { (privateMOC) in
            }

        } else {

            self.persistentContainer = NSPersistentContainer(name: modelName)

            super.init()

            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                self?.persistentContainer.loadPersistentStores { [weak self] (description, error) in
                    if let error = error {
                        fatalError("Couldn't load CoreData Stack \(error.localizedDescription)")
                    }

                    DispatchQueue.main.async {
                        completionHandler(self?.persistentContainer)
                    }
                }
            }
        }
    }

    static func manageObjectModel(with name: String) -> NSManagedObjectModel {
        guard let modelURL = Bundle.main.url(forResource: name, withExtension: "momd") else {
            fatalError("Error could not find model.")
        }

        guard let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Error initializing managedObjectModel from: \(modelURL).")
        }

        return managedObjectModel
    }

    func performInBackground(_ block: @escaping (NSManagedObjectContext) -> Void) {
        let privateMOC = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)

        privateMOC.parent = viewContext

        privateMOC.perform {
            block(privateMOC)
        }
    }

    func save() {
        do {
            try persistentContainer.viewContext.save()
        } catch {
            print("=== could not save view context ===")
            print("error: \(error.localizedDescription)")
        }
    }

    func reset() {
        persistentContainer.viewContext.reset()
    }

    func delete() {

        guard let persistentStoreUrl = persistentContainer
                .persistentStoreCoordinator.persistentStores.first?.url else {
            return
        }

        do {
            try persistentContainer.persistentStoreCoordinator.destroyPersistentStore(
                at: persistentStoreUrl,
                ofType: NSSQLiteStoreType,
                options: nil
            )
        } catch {
            fatalError("could not delete test database. \(error.localizedDescription)")
        }
    }
}

extension DataController {

    func saveNotebooks() {
        let managedObjectContext = viewContext
        NotebookMO.createNotebook(
            createdAt: Date(),
            title: "notebook 1",
            in: managedObjectContext
        )

        NotebookMO.createNotebook(
            createdAt: Date(),
            title: "notebook 2",
            in: managedObjectContext
        )

        NotebookMO.createNotebook(
            createdAt: Date(),
            title: "notebook 3",
            in: managedObjectContext
        )

        do {
            try managedObjectContext.save()
        } catch {
            fatalError("failure to save in background.")
        }
    }

    func saveNotebooksInBackground() {
        performInBackground { (privateManagedObjectContext) in
            let managedObjectContext = privateManagedObjectContext
            NotebookMO.createNotebook(
                createdAt: Date(),
                title: "notebook nuevo",
                in: managedObjectContext
            )

            do {
                try managedObjectContext.save()
            } catch {
                fatalError("failure to save in background.")
            }
        }
    }
}
