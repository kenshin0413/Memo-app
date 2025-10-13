//
//  MemoViewModel.swift
//  Memo-app
//
//  Created by miyamotokenshin on R 7/10/12.
//

import Foundation
import CoreData

@MainActor
class MemoViewModel: ObservableObject {
    @Published var newMemo = ""
    
    func addMemo(context: NSManagedObjectContext) {
        guard !newMemo.isEmpty else { return }
        let memo = Memo(context: context)
        memo.title = newMemo
        memo.date = Date()
        try? context.save()
        newMemo = ""
    }
    
    func deleteMemo(context: NSManagedObjectContext, offsets: IndexSet, memos: [Memo]) {
        for index in offsets {
            let memo = memos[index]
            context.delete(memo)
        }
        try? context.save()
    }
}
