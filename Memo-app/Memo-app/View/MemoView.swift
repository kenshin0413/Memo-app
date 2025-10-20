//
//  MemoView.swift
//  Memo-app
//
//  Created by miyamotokenshin on R 7/10/14.
//

import SwiftUI

struct MemoView: View {
    @StateObject var viewModel = MemoViewModel()
    @FocusState var focusedField: Field?
    @Environment(\.managedObjectContext) private var context
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Memo.isPinned, ascending: false), NSSortDescriptor(keyPath: \Memo.date, ascending: false)]
    ) private var memos: FetchedResults<Memo>
    @Environment(\.dismiss) var dismiss
    init(viewModel: MemoViewModel = MemoViewModel()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                TextField("タイトルを入力してください", text: $viewModel.title)
                    .padding()
                    .textFieldStyle(.roundedBorder)
                    .focused($focusedField, equals: .title)
                    .submitLabel(.next)
                    .onSubmit {
                        focusedField = .body
                    }
                
                Divider()
                
                TextEditor(text: $viewModel.body)
                    .padding()
                    .scrollContentBackground(.hidden)
                    .focused($focusedField, equals: .body)
                    .font(.body)
            }
            .navigationTitle("メモ")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        viewModel.saveMemo(context: context)
                        dismiss()
                    } label: {
                        Text("保存")
                    }
                }
            }
            .onAppear {
                if let memo = viewModel.memo {
                    viewModel.title = memo.title ?? ""
                    viewModel.body = memo.body ?? ""
                } else {
                    focusedField = .title
                }
            }
        }
    }
}

#Preview {
    MemoView()
}
