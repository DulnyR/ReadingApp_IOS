//
//  ContentView.swift
//  ReadingApp
//
//  Created by alumno on 25/10/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var books: [Book]
    @State private var addBookPopUp = false
    @State private var speedPopUp = false
    @State private var readingSpeed: Double = 1.0

    var body: some View {
        NavigationSplitView {
            List {
                ForEach(books) { book in
                    NavigationLink {
                        BookView(book: book)
                    } label: {
                        VStack {
                            Text(book.title)
                                .fontWeight(.bold)
                                .font(.title)
                            Text(book.author.name + " " + book.author.surname)
                                .font(.caption)
                            HStack {
                                let progressValue = Double(book.currentPage)
                                let totalPages = Double(book.numPages)
                                
                                ProgressView(String(book.getStatus()) + "%", value: progressValue, total: totalPages)
                                    .progressViewStyle(LinearProgressViewStyle())
                                Spacer()
                                Text(book.getTimeLeft(readingSpeed: readingSpeed))
                            }
                            .padding()
                        }
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: addBook) {
                        Text("Add Book")
                            .fontWeight(.bold)
                    }
                }
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: setSpeed) {
                        Text("Set Reading Speed")
                    }
                }
            }
            .sheet(isPresented: $addBookPopUp) {
                AddBookPopUpView(showingPopUp: $addBookPopUp)
            }
            .sheet(isPresented: $speedPopUp) {
                VStack {
                    Text("Adjust Reading Speed")
                    Slider(value: $readingSpeed, in: 0.5...5.0, step: 0.5)
                    Text("\(readingSpeed, specifier: "%.1f") pages per minute")
                        .padding()
                    Button("Done") {
                        speedPopUp = false
                    }
                    .padding()
                }
                .padding()
            }
        } detail: {
            Text("Select an item")
        }
    }
    
    private func setSpeed() {
        speedPopUp.toggle()
    }

    private func addBook() {
        addBookPopUp.toggle()
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(books[index])
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Book.self, inMemory: true)
}
