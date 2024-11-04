//
//  BookView.swift
//  ReadingApp
//
//  Created by alumno on 25/10/24.
//

import SwiftUI

struct BookView: View {
    @ObservedObject var book: Book
    @State var currentPage: Int
    @State var viewInfoPopUp = false
    @State var goToPagePopUp = false
    
    init(book: Book) {
        self.book = book
        self.currentPage = book.currentPage
    }
    
    var body: some View {
        VStack {
            Spacer()
            
            Text("This is page \(currentPage) of \(book.title) by \(book.author.name) \(book.author.surname).")
                .padding()
                .multilineTextAlignment(.center)
            
            Spacer()
            
            HStack {
                Button(action: previousPage) {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text("Prev")
                    }
                    .font(.subheadline)
                }
                .disabled(currentPage <= 1)
                .buttonStyle(PlainButtonStyle())
                .padding()
                .background(currentPage > 1 ? Color.blue : Color.gray)
                .foregroundColor(.white)
                .cornerRadius(8)
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Text("\(currentPage) / \(book.numPages)")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .center)
                
                Button(action: nextPage) {
                    HStack {
                        Text("Next")
                        Image(systemName: "chevron.right")
                    }
                    .font(.subheadline)
                }
                .disabled(currentPage >= book.numPages)
                .buttonStyle(PlainButtonStyle())
                .padding()
                .background(currentPage < book.numPages ? Color.blue : Color.gray)
                .foregroundColor(.white)
                .cornerRadius(8)
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .padding(.horizontal)
            .padding(.bottom)
        }
        .onChange(of: currentPage) {
            book.updatePage(page: currentPage)
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    viewInfoPopUp.toggle()
                } label: {
                    Text("View Info")
                        .fontWeight(.bold)
                }
            }
            ToolbarItem {
                Button("Go To Page") {
                    goToPagePopUp.toggle()	
                }
            }
        }
        .sheet(isPresented: $viewInfoPopUp) {
            VStack {
                Text("Book Information")
                    .fontWeight(.bold)
                VStack {
                    Text("Title: \(book.title)")
                        .multilineTextAlignment(.leading)
                    Text("Publication Year: \(String(book.pubYear))")
                        .multilineTextAlignment(.leading)
                    Text("Price: \(String(format: "%.2f", book.price))")
                        .multilineTextAlignment(.leading)
                    Text("Author: \(book.author.name) \(book.author.surname)")
                        .multilineTextAlignment(.leading)
                }
            }
            .presentationDetents([.height(200)])
            .presentationDragIndicator(.visible)
        }
        .sheet(isPresented: $goToPagePopUp) {
            VStack {
                Text("Go To Page")
                Slider(value: Binding(
                    get: { Double(currentPage) },
                    set: { newValue in
                        currentPage = Int(newValue)
                        book.updatePage(page: currentPage)
                    }
                ), in: 1...Double(book.numPages), step: 1)
                Text("\(currentPage) / \(book.numPages)")
                    .padding()
                Button("Done") {
                    goToPagePopUp = false
                }
                .padding()
            }
            .padding()
            .presentationDetents([.height(300)])
        }
    }
    
    private func previousPage() {
        if currentPage > 1 {
            currentPage -= 1
        }
    }

    private func nextPage() {
        if currentPage < book.numPages {
            currentPage += 1
        }
    }
}
