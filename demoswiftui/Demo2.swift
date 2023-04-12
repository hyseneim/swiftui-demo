//
//  Demo1.swift
//  demoswiftui
//
//  Created by Gabriele Cipolloni on 12/04/23.
//

import SwiftUI
import UIKit
import Combine

struct Demo2 : View {
    
    var books: [Book2] = []
    
    var body: some View {
        NavigationView {
            ScrollView {
                HStack {
                    Text("Total")
                    Spacer()
                    Text("0.0€").font(.title)
                }
                
                ForEach(books) { book in
                    BookRow(book: book)
                }
            }.padding()
        }
    }
    
}

class Book2: Identifiable {
    
    let id: String = UUID().uuidString
    let title: String
    let image: UIImage
    let author: String
    let description: String
    let price: Double
    
    var selected: Bool = false
    
    var priceText: String {
        String(format: "%.2f", price) + "€"
    }
    
    init(title: String, image: UIImage, author: String, description: String, price: Double) {
        self.title = title
        self.image = image
        self.author = author
        self.description = description
        self.price = price
    }
}

extension Book2 {
    static func mocks() -> [Book2] {
        [
            Book2(title: "Hello World!", image: UIImage(named: "jon-snow")!, author:
                    "Gabriele", description: "Hello", price: 10),
            Book2(title: "Hello World!", image: UIImage(named: "jon-snow")!, author:
                    "Gabriele2", description: "Hello", price: 15),
            Book2(title: "Hello World!", image: UIImage(named: "jon-snow")!, author:
                    "Gabriele3", description: "Hello", price: 20),
            Book2(title: "Hello World!", image: UIImage(named: "jon-snow")!, author:
                    "Gabriele4", description: "Hello", price: 25),
            Book2(title: "Hello World!", image: UIImage(named: "jon-snow")!, author:
                    "Gabriele5", description: "Hello", price: 30)
        ]
    }
}

struct BookRow: View {
    let book: Book2
    
    var body: some View {
        HStack {
            Image(uiImage: book.image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 100, height: 100, alignment: .top)
                .clipShape(Circle())
                .shadow(radius: 20)
            VStack(alignment: .leading) {
                Text(book.title).fontWeight(.bold).lineLimit(nil)
                Text(book.author).font(.caption).lineLimit(2)
            }
            Spacer()
            Button(action: {
                
            }, label: {
                Text(book.priceText)
                    .accentColor(Color.white)
                    .padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
            }).background(Color.black).cornerRadius(100)
        }
    }
}

#if DEBUG
struct BookRow_Preview: PreviewProvider {
    static var previews: some View {
        BookRow(book: Book2.mocks()[0])
    }
}

struct Demo2_Preview : PreviewProvider {
    static var previews: some View {
        Demo2(books: Book2.mocks())
    }
}
#endif
