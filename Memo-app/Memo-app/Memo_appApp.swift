//
//  Memo_appApp.swift
//  Memo-app
//
//  Created by miyamotokenshin on R 7/10/12.
//

import SwiftUI

@main
struct Memo_appApp: App {
    let persistence = PersistenceController.shared
    var body: some Scene {
        WindowGroup {
            MemoListView()
            // 👇 CoreDataのcontextを環境変数として注入
                .environment(\.managedObjectContext, persistence.context)
        }
    }
}
