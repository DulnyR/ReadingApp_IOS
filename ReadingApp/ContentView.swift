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
    @State private var editBookPopUp = false
    @State private var speedPopUp = false
    @State private var readingSpeed: Double = UserDefaults.standard.double(forKey: "readingSpeed") == 0 ? 1.0 : UserDefaults.standard.double(forKey: "readingSpeed")
    @State private var currentBookIndex: Int = 0
    @State private var selectedFilter: BookFilter = .all
    @State private var showingClearAlert = false
    
    enum BookFilter: String, CaseIterable {
        case all = "All"
        case notStarted = "Not Started"
        case inProgress = "In Progress"
        case completed = "Completed"
    }
    
    private var filteredBooks: [Book] {
        switch selectedFilter {
        case .notStarted:
            return books.filter { $0.currentPage == 1 }
        case .inProgress:
            return books.filter { $0.currentPage > 1 && $0.currentPage < $0.numPages }
        case .completed:
            return books.filter { $0.currentPage == $0.numPages }
        case .all:
            return books
        }
    }

    var body: some View {
        NavigationSplitView {
            VStack {
                Picker("Filter", selection: $selectedFilter) {
                   ForEach(BookFilter.allCases, id: \.self) { filter in
                       Text(filter.rawValue).tag(filter)
                   }
               }
               .pickerStyle(SegmentedPickerStyle())
               .padding()
                
                HStack {
                    Text("Books Visible:")
                        .padding(.leading)
                    
                    Spacer()
                    
                    Text("\(filteredBooks.count) / \(books.count)")
                        .padding(.trailing)
                }
                
                List {
                    ForEach(Array(filteredBooks.enumerated()), id: \.element.id) { index, book in
                        let currentBookIndex = index
                        NavigationLink {
                            BookView(book: book)
                        } label: {
                            VStack {
                                HStack {
                                    VStack {
                                        Text(book.title)
                                            .fontWeight(.bold)
                                            .font(.title)
                                        Text(book.author.name + " " + book.author.surname)
                                            .font(.caption)
                                            .padding(.bottom)
                                    }
                                }
                                
                                if (book.currentPage == 1) {
                                    HStack {
                                        Image(systemName: "book.closed.circle.fill")
                                            .foregroundStyle(.gray)
                                        Text("Not Started")
                                        Spacer()
                                    }
                                }
                                else if (book.currentPage == book.numPages) {
                                    HStack {
                                        Image(systemName: "books.vertical.circle.fill")
                                            .foregroundStyle(.green)
                                        Text("Completed")
                                        Spacer()
                                    }
                                }
                                else {
                                    HStack {
                                        Image(systemName: "book.circle.fill")
                                            .foregroundStyle(.blue)
                                        Text("In Progress")
                                        Spacer()
                                    }
                                }
                                HStack {
                                    let progressValue = Double(book.getStatus())
                                    let totalPages = Double(100)
                                    
                                    ProgressView(String(book.getStatus()) + "%", value: progressValue, total: totalPages)
                                        .progressViewStyle(LinearProgressViewStyle())
                                    Spacer()
                                    Text(book.getTimeLeft(readingSpeed: readingSpeed))
                                }
                                .padding()
                                HStack {
                                    Text("Slide to edit/delete >>")
                                        .foregroundStyle(.gray)
                                        .font(.footnote)
                                    Spacer()
                                }
                            }
                            .swipeActions (edge: .leading, allowsFullSwipe: false) {
                                Button {
                                    editBook()
                                } label: {
                                    Label("Edit", systemImage: "pencil")
                                }
                                .tint(.blue)
                                
                                Button {
                                    deleteBook(bookIndex: currentBookIndex)
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                                .tint(.red)
                            }
                        }
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Delete All") {
                        showingClearAlert = true
                    }
                }
                ToolbarItem {
                    Button(action: addBook) {
                        Text("Add Book")
                            .fontWeight(.bold)
                    }
                }
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: setSpeed) {
                        Text("Set Speed")
                        Image(systemName: "gauge.medium")
                    }
                }
            }
            .alert(isPresented: $showingClearAlert) {
                Alert(
                    title: Text("Confirm Action"),
                    message: Text("Are you sure you want to delete all books? This action cannot be undone."),
                    primaryButton: .destructive(Text("Delete")) {
                        deleteAllBooks()
                    },
                    secondaryButton: .cancel()
                )
            }
            .sheet(isPresented: $addBookPopUp) {
                AddBookPopUpView(showingPopUp: $addBookPopUp)
                    .presentationDetents([.fraction(2/3)])
            }
            .sheet(isPresented: $editBookPopUp) {
                let book = books[currentBookIndex]
                EditBookPopUpView(
                    title: book.title,
                    pubYear: String(book.pubYear),
                    numPages: String(book.numPages),
                    price: String(book.price),
                    authorName: String(book.author.name),
                    authorSurname: String(book.author.surname),
                    bookIndex: currentBookIndex,
                    showingPopUp: $editBookPopUp
                )
                .presentationDetents([.fraction(2/3)])
            }
            .sheet(isPresented: $speedPopUp) {
                VStack {
                    Text("Adjust Reading Speed")
                    Slider(value: $readingSpeed, in: 0.5...5.0, step: 0.5)
                        .onChange(of: readingSpeed) {
                        UserDefaults.standard.set(readingSpeed, forKey: "readingSpeed")
                    }
                    Text("\(readingSpeed, specifier: "%.1f") pages per minute")
                        .padding()
                    Button("Done") {
                        speedPopUp = false
                    }
                    .padding()
                }
                .padding()
                .presentationDetents([.height(200)])
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
    
    private func editBook() {
        editBookPopUp.toggle()
    }

    private func deleteBook(bookIndex: Int) {
        withAnimation {
            modelContext.delete(books[bookIndex])
        }
    }
    
    private func deleteAllBooks() {
        withAnimation {
            for book in books {
                modelContext.delete(book)
            }
            
            do {
                try modelContext.save()
            } catch {
                print("Error clearing books: \(error.localizedDescription)")
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Book.self, inMemory: true)
}
