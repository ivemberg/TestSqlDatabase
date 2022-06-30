//
//  UserModel.swift
//  TestSqlDatabase
//
//  Created by user on 30/06/22.
//

import Foundation

/**
    Classe Pojo
    Your model class must conform to Identifiable protocol in order to show the users in List view.
 */
class NoteModel: Identifiable {
    public var id: Int64 = 0
    public var note: String = ""
}
