//
//  ContentView.swift
//  TestSqlDatabase
//
//  Created by user on 30/06/22.
//

import SwiftUI



struct ContentView: View {
    // check if user is selected for edit
    @State var noteSelected: Bool = false
     
    // id of selected user to edit or delete
    @State var selectedNoteId: Int64 = 0
    
    
    // array of user models
    @State var noteModels: [NoteModel] = []
    
    var body: some View {
        ZStack {
            
            LinearGradient(gradient: Gradient(colors :[Color.red , Color.white , Color.blue]), startPoint: .leading, endPoint: .trailing)
            
        }
        
        // create list view to show all users
        List (self.noteModels) { (model) in
            ZStack {
                Color(.red).edgesIgnoringSafeArea(.all)
            }
            
            // show name, email and age horizontally
            HStack {
                Text(model.note)
                Spacer()
                // edit and delete button goes here
                
                // button to edit user
                Button(action: {
                    self.selectedNoteId = model.id
                    self.noteSelected = true
                    
                    print("EDITING BOX")
                    
                }, label: {
                    Text("Edit")
                        .foregroundColor(Color.blue)
                    })
                    // by default, buttons are full width.
                    // to prevent this, use the following
                    .buttonStyle(PlainButtonStyle())
                
                // button to delete user
                Button(action: {
                    
                    // create db manager instance
                    let dbManager: DB_Manager = DB_Manager()
                    
                    // call delete function
                    dbManager.deleteNote(idValue: model.id)
                    
                    // refresh the user models array
                    self.noteModels = dbManager.getNotes()
                }, label: {
                    Text("Delete")
                        .foregroundColor(Color.red)
                })// by default, buttons are full width.
                // to prevent this, use the following
                .buttonStyle(PlainButtonStyle())
            }
        }
        
        // create navigation view
        NavigationView {
            VStack {
                // create link to add user
                HStack {
                    Spacer()
                    NavigationLink (destination: AddNoteView(), label: {
                        Text("Add user")
                    })
                    
                    // navigation link to go to edit user view
                    NavigationLink (destination: EditNoteView(id: self.$selectedNoteId), isActive: self.$noteSelected) {
                        EmptyView()
                    }
                    
                }
         
                // list view goes here
         
            }.padding()
            .navigationBarTitle("SQLite")
            // load data in user models array
            .onAppear(perform: {
                self.noteModels = DB_Manager().getNotes()
            })
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
