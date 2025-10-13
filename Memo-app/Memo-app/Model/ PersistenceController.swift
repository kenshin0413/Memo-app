//
//   PersistenceController.swift
//  Memo-app
//
//  Created by miyamotokenshin on R 7/10/12.
//

import CoreData

class PersistenceController {
    static let shared = PersistenceController()
    
    let container: NSPersistentContainer
    
    private init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Model") // .xcdatamodeld の名前
        if inMemory {
            // 単体テスト等でディスクに保存したくない時
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        // 軽量マイグレーションを有効化（モデル更新に強くなる）
        if let desc = container.persistentStoreDescriptions.first {
            desc.setOption(true as NSNumber, forKey: NSMigratePersistentStoresAutomaticallyOption)
            desc.setOption(true as NSNumber, forKey: NSInferMappingModelAutomaticallyOption)
        }
        
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Persistent store load error: \(error)")
            }
        }
        // マージポリシー（保存競合時の解決策：後勝ち）必須じゃない
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    var context: NSManagedObjectContext { container.viewContext }
}
