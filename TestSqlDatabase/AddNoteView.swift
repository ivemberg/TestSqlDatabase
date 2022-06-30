//
//  AddNoteView.swift
//  TestSqlDatabase
//
//  Created by user on 30/06/22.
//


import Foundation
import SwiftUI
 
struct AddNoteView: View {
     
    // create variables to store user input values
    @State var note: String = ""
     
    // to go back on the home screen when the user is added
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
     
    var body: some View {
         
        VStack {
            TextField("Enter name", text: $note)
                .padding(10)
                .background(Color(.systemGray6))
                .cornerRadius(5)
                .disableAutocorrection(true)
             
            Button(action: {
                // call function to add row in sqlite database
                DB_Manager().addNote(newNote: note)
                 
                // go back to home page
                self.mode.wrappedValue.dismiss()
            }, label: {
                Text("Add Note")
            })
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.top, 10)
                .padding(.bottom, 10)
        }.padding()
         
    }
}
