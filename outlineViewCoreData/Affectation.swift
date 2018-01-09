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
        case color    = "color"
    }
    
    static let sharedInstance = Affectation()
    
    var entities = [EntityAffectation]()
    
    func addEntity(name: String)
    {
        let entity = EntityAffectation(context: mainObjectContext)
        
        entity.name = name
        entity.color = NSColor.black
    }
    
    
    func removeEntity(entity: EntityAffectation)
    {
        mainObjectContext.delete(entity)
    }
    
    func entityAtIndex(entity: EntityAffectation) -> Int {
        
        let i = entities.index{$0 === entity}
        return i!
    }
    
    func getAllEntity() -> [EntityAffectation] {
        
        do {
            let fetchRequest = NSFetchRequest<EntityAffectation>(entityName: "EntityAffectation")
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
        }
    }
    
}



