//
//  MemoViewModel.swift
//  Memo-app
//
//  Created by miyamotokenshin on R 7/10/14.
//

import Foundation
import CoreData

class MemoViewModel: ObservableObject {
    @Published var title: String = ""
    @Published var body: String = ""
    var memo: Memo?
    
    init(memo: Memo? = nil) {
        self.memo = memo
    }
    
   
    
    func saveMemo(context: NSManagedObjectContext) {
        let memoToSave = memo ?? Memo(context: context)
        memoToSave.title = title.trimmingCharacters(in: .whitespacesAndNewlines)
        memoToSave.body = body.trimmingCharacters(in: .whitespacesAndNewlines)
        memoToSave.date = Date()
        memoToSave.id = memo?.id ?? UUID()
        
        do {
            try context.save()
        } catch {
            print("保存エラー\(error.localizedDescription)")
        }
    }
}
