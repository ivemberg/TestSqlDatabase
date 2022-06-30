//
//  EditNoteView.swift
//
//
//  Created by user on 30/06/22.
//

import Foundation
import SwiftUI
 
struct EditNoteView: View {
     
    // id receiving of user from previous view
    @Binding var id: Int64
     
    // variables to store value from input fields
    @State var note: String = ""
     
    // to go back to previous view
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
     
    var body: some View {
        VStack {
            // create name field
            TextField("Enter note", text: $note)
                .padding(10)
                .background(Color(.systemGray6))
                .cornerRadius(5)
                .disableAutocorrection(true)
             
            // button to update user
            Button(action: {
                // call function to update row in sqlite database
                DB_Manager().updateNote(idValue: self.id, noteValue: self.note)
 
                // go back to home page
                self.mode.wrappedValue.dismiss()
            }, label: {
                Text("Edit Note")
            })
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.top, 10)
                .padding(.bottom, 10)
        }.padding()
 
        // populate user's data in fields when view loaded
        .onAppear(perform: {
             
            // get data from database
            let noteModel: NoteModel = DB_Manager().getUser(idValue: self.id)
             
            // populate in text fields
            self.note = noteModel.note
        })
    }
}
 
struct EditNoteView_Previews: PreviewProvider {
     
    // when using @Binding, do this in preview provider
    @State static var id: Int64 = 0
     
    static var previews: some View {
        EditNoteView(id: $id)
    }
}
