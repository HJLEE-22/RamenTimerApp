//
//  DataBaseContainer.swift
//  RamenTimer
//
//  Created by 이형주 on 2022/09/14.
//

import Foundation
import CoreData

class DatabaseController {

    static let shared = DatabaseController()
    private init() {}

    //Returns the current Persistent Container for CoreData
    class func getContext () -> NSManagedObjectContext {
        return DatabaseController.persistentContainer.viewContext
    }


    static var persistentContainer: NSPersistentContainer = {
        //The container that holds both data model entities
        let container = NSPersistentContainer(name: "RamenData")

        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */

                //TODO: - Add Error Handling for Core Data

                fatalError("Unresolved error \(error), \(error.userInfo)")
            }


        })
        return container
    }()

    // MARK: - Core Data Saving support
    class func saveContext() {
        let context = self.getContext()
        if context.hasChanges {
            do {
                try context.save()
                print("Data Saved to Context")
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate.
                //You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    /* Support for GRUD Operations */

    // GET / Fetch / Requests
    class func getAllRamens() -> [RamenData] {
        let all = NSFetchRequest<RamenData>(entityName: "RamenData")
        var allRamens = [RamenData]()

        do {
            let fetched = try DatabaseController.getContext().fetch(all)
            allRamens = fetched
        } catch {
            let nserror = error as NSError
            //TODO: Handle Error
            print(nserror.description)
        }

        return allRamens
    }

    // Get Show by uuid
    class func getRamenWith(uuid: String) -> RamenData? {
        let requested = NSFetchRequest<RamenData>(entityName: "RamenData")
        requested.predicate = NSPredicate(format: "uuid == %@", uuid)

        do {
            let fetched = try DatabaseController.getContext().fetch(requested)

            //fetched is an array we need to convert it to a single object
            if (fetched.count > 1) {
                //TODO: handle duplicate records
            } else {
                return fetched.first //only use the first object..
            }
        } catch {
            let nserror = error as NSError
            //TODO: Handle error
            print(nserror.description)
        }

        return nil
    }

    // REMOVE / Delete
    class func deleteRamen(with uuid: String) -> Bool {
        let success: Bool = true

        let requested = NSFetchRequest<RamenData>(entityName: "RamenData")
        requested.predicate = NSPredicate(format: "uuid == %@", uuid)


        do {
            let fetched = try DatabaseController.getContext().fetch(requested)
            for show in fetched {
                DatabaseController.getContext().delete(show)
            }
            return success
        } catch {
            let nserror = error as NSError
            //TODO: Handle Error
            print(nserror.description)
        }

        return !success
    }

    
    //// Delete ALL SHOWS From CoreData
    class func deleteAllRamens() {
        do {
            let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "RamenData")
            let deleteALL = NSBatchDeleteRequest(fetchRequest: deleteFetch)
    
            try DatabaseController.getContext().execute(deleteALL)
            DatabaseController.saveContext()
        } catch {
            print ("There is an error in deleting records")
        }
    }
}


