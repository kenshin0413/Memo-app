//
//  MemoView.swift
//  Memo-app
//
//  Created by miyamotokenshin on R 7/10/12.
//

import SwiftUI
import CoreData

struct MemoListView: View {
    @StateObject var viewModel = MemoListViewModel()
    @Environment(\.managedObjectContext) private var context
    // 並び替えの優先順位
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Memo.isPinned, ascending: false), NSSortDescriptor(keyPath: \Memo.date, ascending: false)]
    ) private var memos: FetchedResults<Memo>
    
    @State var showModal = false
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottomTrailing) {
                VStack {
                    List {
                        ForEach(memos) { memo in
                            NavigationLink {
                                MemoView(viewModel: MemoViewModel(memo: memo))
                            } label: {
                                VStack(alignment: .leading) {
                                    HStack {
                                        Button {
                                            viewModel.togglePin(for: memo, context: context)
                                        } label: {
                                            Image(systemName: memo.isPinned ? "pin.fill" : "pin")
                                                .foregroundColor(.yellow)
                                        }
                                        .buttonStyle(.plain)

                                        Text(memo.title ?? "")
                                            .font(.headline)
                                        Text(memo.body ?? "")
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                            .lineLimit(1)
                                        if let date = memo.date {
                                            Text(date.formatted(date: .abbreviated, time: .shortened))
                                                .font(.caption)
                                                .foregroundColor(.gray)
                                        }
                                    }
                                }
                            }
                            .background(memo.isPinned ? Color.yellow.opacity(0.2) : Color(.systemBackground))
                        }
                        .onDelete { indexSet in
                            viewModel.deleteMemo(context: context, offsets: indexSet, memos: Array(memos))
                        }
                    }
                    .sheet(isPresented: $showModal) {
                        MemoView()
                    }
                }
                
                Button {
                    showModal = true
                } label: {
                    Image(systemName: "plus")
                        .frame(width: 60, height: 60)
                        .background(Color.gray)
                        .clipShape(.circle)
                        .foregroundStyle(Color.white)
                }
                .padding(40)
            }
            .navigationTitle("メモ一覧")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    MemoListView()
}
