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
    @Published var sortOption: SortOption = .new
    @Published var memos: [Memo] = []
    
    func deleteMemo(context: NSManagedObjectContext, offsets: IndexSet, memos: [Memo]) {
        for index in offsets {
            let memo = memos[index]
            context.delete(memo)
        }
        saveContext(context)
        fetchMemos(context: context)
    }
    // ピン止め処理
    func togglePin(for memo: Memo, context: NSManagedObjectContext) {
        memo.isPinned.toggle()
        saveContext(context)
        fetchMemos(context: context)
        context.refreshAllObjects()
    }
    
    func fetchMemos(context: NSManagedObjectContext) {
        let request: NSFetchRequest<Memo> = Memo.fetchRequest()
        
        request.sortDescriptors = [
                    NSSortDescriptor(keyPath: \Memo.isPinned, ascending: false),
                    NSSortDescriptor(keyPath: \Memo.date, ascending: sortOption == .old)
                ]
        do {
            memos = try context.fetch(request)
        } catch {
            print("メモ取得失敗\(error.localizedDescription)")
        }
    }
    
    func saveContext(_ context: NSManagedObjectContext) {
        do {
            try context.save()
        } catch {
            print("保存失敗\(error.localizedDescription)")
        }
    }
}
