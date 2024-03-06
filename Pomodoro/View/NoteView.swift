//
//  NoteView.swift
//  Pomodoro
//
//  Created by Marcelo de Araújo on 06/03/24.
//

import SwiftUI

struct NoteView: View {
    @Environment(\.modelContext) private var context
    @State var id:UUID?
    @State var data:Data?
    @State var title:String?
    
    var body: some View {
        NoteRepresentableView(data: data ?? Data(), id: id ?? UUID())
            .navigationTitle(title ?? "Untitled")
            .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NoteView()
}
