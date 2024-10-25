//
//  Author.swift
//  ReadingApp
//
//  Created by alumno on 25/10/24.
//

import Foundation
import SwiftData

@Model
final class Author {
    var name: String
    var surname: String
    
    init(name: String, surname: String) {
        self.name = name
        self.surname = surname
    }
}
