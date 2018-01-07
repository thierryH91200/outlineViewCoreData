//
//  Affectation.swift
//  TaskManager
//
//  Created by Michal Sverak on 10/6/16.
//  Copyright © 2016 MichalSverak. All rights reserved.
//

import Foundation
import Cocoa
import CoreData

class Affectation {
    
    @objc  var mainObjectContext: NSManagedObjectContext = (NSApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    
    fileprivate enum AffectationDisplayProperty: String {
        case name     = "name"
        case objectif    = "objectif"
//        case uuid     = "uuid"
    }
    
    static let sharedInstance = Affectation()
    
    var entities = [EntityAffectation]()
    
    func addEntity(name: String)
    {
        let entity = EntityAffectation(context: mainObjectContext)
        
        entity.name = name
//        entity.objectif = 0.0
//        entity.color = NSColor.black
//        entity.uuid = uuid
//        entity.compte = compteCourant
    }
    
    // delete Entity
//    func removeEntity(withUUID: UUID)
//    {
//        if let i = entities.index(where: {$0.uuid == withUUID}) {
//            mainObjectContext.delete(entities[i])
//        }
//    }
    
    func removeEntity(entity: EntityAffectation)
    {
        mainObjectContext.delete(entity)
    }
    
    func entityAtIndex(entity: EntityAffectation) -> Int {
        
        let i = entities.index{$0 === entity}
        return i!
    }
    
//    func editEntity( entity: EntityAffectation) {
//
//        let request = NSFetchRequest<EntityAffectation>(entityName: "EntityAffectation")
////        let predicate = NSPredicate(format: "compte == %@", compteCourant!)
//        request.predicate = predicate
//
//        do {
//            let searchResults = try mainObjectContext.fetch(request)
//            for result in searchResults
//            {
//                if result.uuid == entity.uuid
//                {
//                    result.name = entity.name
//                    //                    result.category = entity.color
//                    result.compte = compteCourant
//                    break
//                }
//            }
//
//        } catch {
//            print("Error with request: \(error)")
//        }
//    }
    
//    func entityColor(name: String) -> NSColor {
//
//        let i = entities.index{$0.name == name}
//        if i == nil {
//            return NSColor.black
//        }
//        return entities[i!].color as! NSColor
//    }
    
    func getAllEntity() -> [EntityAffectation] {
        
        do {
            let fetchRequest = NSFetchRequest<EntityAffectation>(entityName: "EntityAffectation")
//            let predicate = NSPredicate(format: "compte == %@", compteCourant!)
//            fetchRequest.predicate = predicate
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: AffectationDisplayProperty.name.rawValue, ascending:true)]
            
            entities = try mainObjectContext.fetch(fetchRequest)
        }catch {
            print("Error fetching data from CoreData")
        }
        
        defaultEntities()
        return entities
    }
    
    func defaultEntities()
    {
        
        var isEmpty : Bool {
            do{
                let request = NSFetchRequest<NSFetchRequestResult>(entityName: "EntityAffectation")
                let count  = try mainObjectContext.count(for: request)
                return count == 0 ? true : false
            }catch{
                return true
            }
        }
        
        if entities.count == 0 {
            var content = ""
            do {
                let url = Bundle.main.url(forResource: "categorie", withExtension: "csv")
                content =  try String(contentsOf: url!)
            }
            catch {
                print(error)
            }
            
            let csv = CSwiftV(with: content, separator: ";", replace : "\r")
            
            let keys = csv.keyedRows
            if let keys = keys
            {
                for key in keys
                {
                    if isEmpty == false {
                        do {
                            let fetchRequest = NSFetchRequest<EntityAffectation>(entityName: "EntityAffectation")
                            let predicate = NSPredicate(format: "name == %@", key["affectation"]!)
                            fetchRequest.predicate = predicate
                            fetchRequest.sortDescriptors = [NSSortDescriptor(key: AffectationDisplayProperty.name.rawValue, ascending:true)]
                            
                            entities = try mainObjectContext.fetch(fetchRequest)
                            
                        } catch {
                            print("Error fetching data from CoreData")
                        }
                    }
                    
                    if entities.count == 0 {
                        
                        let entityAffectation = EntityAffectation(context: mainObjectContext)
                        entityAffectation.name = key["affectation"]
                        entityAffectation.color = NSColor.blue

                        let entityCategory = EntityCategory(context: mainObjectContext)
                        entityCategory.name = key["categorie"]
                        entityCategory.objectif = 100
                        entityCategory.affectation = entityAffectation

                        entityAffectation.category?.adding(entityCategory)
                    }
                    else {
                        let entityCategory = EntityCategory(context: mainObjectContext)
                        entityCategory.name = key["categorie"]
                        entityCategory.objectif = 200
                        entityCategory.affectation = entities[0]

                        entities[0].category?.adding(entityCategory)
                    }
                }
                do {
                try mainObjectContext.save()
                } catch { }
            }
            do {
                let fetchRequest = NSFetchRequest<EntityAffectation>(entityName: "EntityAffectation")
                fetchRequest.sortDescriptors = [NSSortDescriptor(key: AffectationDisplayProperty.name.rawValue, ascending:true)]
                
                entities = try mainObjectContext.fetch(fetchRequest)
            }catch {
                print("Error fetching data from CoreData")
            }
            print(entities.count)
        }
        
    }
}



