//
//  BookView.swift
//  ReadingApp
//
//  Created by alumno on 25/10/24.
//

import SwiftUI

struct BookView: View {
    var book: Book
    
    var body: some View {
        VStack {
            Text(book.getPageContent())
                .padding()
            
            HStack {
                Button(action: previousPage) {
                    Text("Previous")
                }
                .disabled(book.currentPage <= 1) // Disable if on the first page
                
                Spacer()
                
                Button(action: nextPage) {
                    Text("Next")
                }
                .disabled(book.currentPage >= book.numPages) // Disable if on the last page
            }
            .padding()
        }
    }
    
    private func previousPage() {
        if book.currentPage > 1 {
            updatedBook.currentPage -= 1
        }
    }

    private func nextPage() {
        if book.currentPage < book.numPages {
            updatedBook.currentPage += 1
        }
    }
}
