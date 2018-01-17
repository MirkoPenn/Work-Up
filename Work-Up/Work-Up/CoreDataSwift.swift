import CoreData

let managedObjectContext : NSManagedObjectContext =
{
    // This is your xcdatamodeld file
    let modelURL = Bundle.main.url(forResource: "MyApp", withExtension: "momd")
    let dataModel = NSManagedObjectModel(contentsOf: modelURL!)
    
    // This is where you are storing your SQLite database file
    let documentsDirectory : NSURL! = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last as NSURL?
    let storeURL = documentsDirectory.appendingPathComponent("MyApp.sqlite")
    
    let psc = NSPersistentStoreCoordinator(managedObjectModel: dataModel!)
    
    var error : NSError?
    do {
        let store = try psc.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: nil)
    
    if let error = error
    {
        print("Uhoh, something happened! \(error), \(error.userInfo)")
    }
        
    } catch {
        
    }
    
    let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    
    context.persistentStoreCoordinator = psc
    context.undoManager = nil

    
    return context
}()
