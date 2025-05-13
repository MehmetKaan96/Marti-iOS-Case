//
//  CoreDataManager.swift
//  Marti-iOS-Case
//
//  Created by Mehmet Kaan on 13.05.2025.
//

import UIKit
import CoreData

enum ScreenType: String {
    case main
    case tag
    case taxi
}

final class CoreDataManager {
    
    private static var context: NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    static func saveLocation(latitude: Double, longitude: Double, address: String?, screenType: ScreenType) {
        let newLocation = Location(context: context)
        newLocation.latitude = latitude
        newLocation.longitude = longitude
        newLocation.address = address
        newLocation.timestamp = Date()
        newLocation.screenType = screenType.rawValue
        
        do {
            try context.save()
            print("Konum başarıyla kaydedildi.")
        } catch {
            print("Konum kaydı başarısız: \(error.localizedDescription)")
        }
    }

    static func fetchLocations() -> [Location] {
        let fetchRequest: NSFetchRequest<Location> = Location.fetchRequest()
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Konumlar alınamadı: \(error.localizedDescription)")
            return []
        }
    }

    static func deleteLocation(_ location: Location) {
        context.delete(location)
        do {
            try context.save()
        } catch {
            print("Konum silinemedi: \(error.localizedDescription)")
        }
    }

    static func deleteAllLocations() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Location.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            print("Tüm konumlar silinemedi: \(error.localizedDescription)")
        }
    }
    
    static func fetchLocations(for screenType: ScreenType) -> [Location] {
        let request: NSFetchRequest<Location> = Location.fetchRequest()
        request.predicate = NSPredicate(format: "screenType == %@", screenType.rawValue)
        do {
            return try context.fetch(request)
        } catch {
            print("Konumlar alınamadı: \(error)")
            return []
        }
    }
}
