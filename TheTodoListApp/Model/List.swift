//
//  List.swift
//  TheTodoListApp
//
//  Created by Wynelher Tagayuna on 4/2/23.
//

import Foundation

struct List: Codable{// Codable allows the encoding and decoding of data.
    var title: String = ""
    var done: Bool = false
}
