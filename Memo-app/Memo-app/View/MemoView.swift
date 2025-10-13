//
//  MemoView.swift
//  Memo-app
//
//  Created by miyamotokenshin on R 7/10/12.
//

import SwiftUI
import CoreData

struct MemoView: View {
    @StateObject var viewModel = MemoViewModel()
    // 👇 これでCoreDataのcontextを取得できる
    @Environment(\.managedObjectContext) private var context
    // 👇 CoreDataのデータを自動取得（List表示）
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Memo.date, ascending: false)]
    ) private var memos: FetchedResults<Memo>
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    TextField("メモを入力", text: $viewModel.newMemo)
                        .textFieldStyle(.roundedBorder)
                    
                    Button("追加") {
                        viewModel.addMemo(context: context)
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding()
                
                List {
                    ForEach(memos) { memo in
                        VStack(alignment: .leading) {
                            Text(memo.title ?? "タイトルなし")
                            if let date = memo.date {
                                Text(date.formatted(date: .abbreviated, time: .shortened))
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .onDelete { indexSet in
                        viewModel.deleteMemo(context: context, offsets: indexSet, memos: Array(memos))
                    }
                }
            }
            .navigationTitle("メモ一覧")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    MemoView()
}
