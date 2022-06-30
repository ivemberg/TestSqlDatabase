//
//  DBManager.swift
//  TestSqlDatabase
//
//  Created by user on 30/06/22.
//

import Foundation
import SQLite


class DB_Manager {
     
    // sqlite instance
    private var db: Connection!
     
    // table instance
    private var notes: Table!
 
    // columns instances of table
    private var id: Expression<Int64>!
    private var note: Expression<String>!
     
    // constructor of this class
    init () {
         
        // exception handling
        do {
             
            // path of document directory
            let path: String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first ?? ""
 
            // creating database connection
            db = try Connection("\(path)/my_notes.sqlite3")
             
            // creating table object
            notes = Table("notes")
             
            // create instances of each column
            id = Expression<Int64>("id")
            note = Expression<String>("note")
             
            // check if the user's table is already created
            if (!UserDefaults.standard.bool(forKey: "is_db_created")) {
 
                // if not, then create the table
                try db.run(notes.create { (t) in
                    t.column(id, primaryKey: true)
                    t.column(note)
                })
                 
                // set the value to true, so it will not attempt to create the table again
                UserDefaults.standard.set(true, forKey: "is_db_created")
            }
             
        } catch {
            // show error message if any
            print(error.localizedDescription)
        }
         
    }
    
    public func addNote(newNote: String) {
        do {
            try db.run(notes.insert(note <- newNote))
        } catch {
            print(error.localizedDescription)
        }
    }
    
    // return array of user models
    public func getNotes() -> [NoteModel] {
         
        // create empty array
        var noteModels: [NoteModel] = []
     
        // get all users in descending order
        notes = notes.order(id.desc)
     
        // exception handling
        do {
     
            // loop through all users
            for n in try db.prepare(notes) {
     
                // create new model in each loop iteration
                let noteModel: NoteModel = NoteModel()
     
                // set values in model from database
                noteModel.id = n[id]
                noteModel.note = n[note]
     
                // append in new array
                noteModels.append(noteModel)
            }
        } catch {
            print(error.localizedDescription)
        }
     
        // return array
        return noteModels
    }
    
    // get single user data
    public func getUser(idValue: Int64) -> NoteModel {
     
        // create an empty object
        let noteModel = NoteModel()
         
        // exception handling
        do {
     
            // get user using ID
            let notes: AnySequence<Row> = try db.prepare(notes.filter(id == idValue))
     
            // get row
            try notes.forEach({ (rowValue) in
     
                // set values in model
                noteModel.id = try rowValue.get(id)
                noteModel.note = try rowValue.get(note)
            })
        } catch {
            print(error.localizedDescription)
        }
     
        // return model
        return noteModel
    }
    
    
    
    // function to update user
    public func updateNote(idValue: Int64, noteValue: String) {
        do {
            // get user using ID
            let noteTemp: Table = notes.filter(id == idValue)
             
            // run the update query
            try db.run(noteTemp.update(note <- noteValue))
        } catch {
            print(error.localizedDescription)
        }
    }
    
 
  
        
    // function to delete user
    public func deleteNote(idValue: Int64) {
        do {
            // get user using ID
            let note: Table = notes.filter(id == idValue)
             
            // run the delete query
            try db.run(note.delete())
        } catch {
            print(error.localizedDescription)
        }
    }
    
    
    
}
