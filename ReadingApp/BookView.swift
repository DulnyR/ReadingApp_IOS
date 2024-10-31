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
