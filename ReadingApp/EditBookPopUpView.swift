//
//  EditBookPopUpView.swift
//  ReadingApp
//
//  Created by alumno on 31/10/24.
//

import Foundation
import SwiftUI
import SwiftData

struct EditBookPopUpView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var books: [Book]
    
    @State var title: String
    @State var pubYear: String
    @State var numPages: String
    @State var price: String
    @State var authorName: String
    @State var authorSurname: String
    @State var bookIndex: Int
    
    @Binding var showingPopUp: Bool

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Enter book details:")) {
                    TextField("Title", text: $title)
                    TextField("Publication Year", text: $pubYear)
                        .keyboardType(.numberPad)
                    TextField("Number of Pages", text: $numPages)
                        .keyboardType(.numberPad)
                    TextField("Price", text: $price)
                        .keyboardType(.decimalPad)
                    TextField("Author Name", text: $authorName)
                    TextField("Author Surname", text: $authorSurname)
                }
            }
            .navigationTitle("Edit Book")
            .navigationBarItems(leading: Button("Cancel") {
                showingPopUp = false
            }, trailing: Button("Save") {
                saveBook()
            }
                .disabled(!canSave)
            )
        }
    }
    
    private var canSave: Bool {
        return !title.isEmpty && !pubYear.isEmpty && !numPages.isEmpty && !price.isEmpty && !authorName.isEmpty && !authorSurname.isEmpty
    }
    
    private func saveBook () {
        if let year = Int(pubYear), let pages = Int(numPages), let bookPrice = Double(price) {
            let newAuthor = Author(name: authorName, surname: authorSurname)
            let newBook = Book(title: title, pubYear: year, numPages: pages, price: bookPrice, author: newAuthor)
            newBook.updatePage(page: books[bookIndex].getPage()	)
            modelContext.delete(books[bookIndex])
            modelContext.insert(newBook)
            do {
                try modelContext.save()
            } catch {
                print("Error saving book: \(error.localizedDescription)")
            }
            showingPopUp = false
        }
        else {
            //Show alert saying that the user hasn´t entered the info correctly
        }
    }
}
