//
//  MemoViewModel.swift
//  Memo-app
//
//  Created by miyamotokenshin on R 7/10/12.
//

import Foundation
import CoreData

@MainActor
class MemoListViewModel: ObservableObject {
    
    func deleteMemo(context: NSManagedObjectContext, offsets: IndexSet, memos: [Memo]) {
        for index in offsets {
            let memo = memos[index]
            context.delete(memo)
        }
        try? context.save()
    }
    // ピン止め処理
    func togglePin(for memo: Memo, context: NSManagedObjectContext) {
        memo.isPinned.toggle()
        try? context.save()
    }
}
