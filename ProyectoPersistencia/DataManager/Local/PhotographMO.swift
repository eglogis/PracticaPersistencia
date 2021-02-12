//
//  PhotographMO.swift
//  ProyectoPersistencia
//
//  Created by Samuel Bautista Sánchez on 10/2/21.
//

import Foundation
import CoreData

@objc
public class PhotographMO: NSManagedObject {

    static func createPhoto(imageData: Data,
                            managedObjectContext: NSManagedObjectContext) -> PhotographMO? {
        let photograph = NSEntityDescription.insertNewObject(forEntityName: "Photograph",
                                                             into: managedObjectContext) as? PhotographMO

        photograph?.imageData = imageData
        photograph?.createAt = Date()

        return photograph
    }
}
