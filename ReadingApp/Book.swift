//
//  Book.swift
//  ReadingApp
//
//  Created by alumno on 25/10/24.
//

import Foundation
import SwiftData

@Model
final class Book {
    var title: String
    var pubYear: Int
    var numPages: Int
    var currentPage: Int
    var price: Double
    var author: Author
    
    init(title: String, pubYear: Int, numPages: Int, price: Double, author: Author) {
        self.title = title
        self.pubYear = pubYear
        self.numPages = numPages
        self.currentPage = 1
        self.price = price
        self.author = author
    }
    
    func getStatus() -> Int {
        return (currentPage / numPages) * 100
    }
    
    func updatePage(page: Int) {
        currentPage = page
    }
    
    func getTimeLeft(readingSpeed: Double) -> String {
        let pagesLeft = numPages - currentPage
        let timeLeft = Int(Double(pagesLeft) / readingSpeed)
        let hours = timeLeft / 60
        let minutes = timeLeft % 60
        
        if hours > 0 {
            return "\(hours)h \(minutes)m left"
        }
        return "\(timeLeft)m left"
    }
    
    func getPageContent() -> String {
        return "Welcome to page \(String(currentPage)) of \(title) by \(author.name) \(author.surname) !"
    }
}
