//
//  NoteMO.swift
//  ProyectoPersistencia
//
//  Created by Samuel Bautista Sánchez on 9/2/21.
//

import Foundation
import CoreData

public class NoteMO: NSManagedObject {

    @discardableResult
    static func createNote(managedObjectContext: NSManagedObjectContext,
                           notebook: NotebookMO,
                           title: String,
                           contents: String,
                           createdAt: Date) -> NoteMO? {
        let note = NSEntityDescription.insertNewObject(forEntityName: "Note",
                                                       into: managedObjectContext) as? NoteMO

        note?.title = title
        note?.contents = contents
        note?.createAt = createdAt
        note?.notebook = notebook

        return note
    }
}
