//
//  Demo1.swift
//  demoswiftui
//
//  Created by Gabriele Cipolloni on 12/04/23.
//

import SwiftUI
import UIKit

struct Demo1 : View {
    
    @SwiftUI.State private var pizze: Int = 0
    @SwiftUI.State private var cokes: Int = 0
    @SwiftUI.State private var address: String = ""
    @SwiftUI.State private var premiumDelivery: Bool = false
    @SwiftUI.State private var showSheet: Bool = false
    
    let pizzaPrice: Double = 11.50
    let cokePrice: Double = 2.50
    let premiumDeliveryPrice: Double = 8.0
    
    var finalPrice: Double {
        (Double(pizze) * pizzaPrice) + (Double(cokes) * cokePrice)
        + (premiumDelivery ? Double(premiumDeliveryPrice) : 0)
    }
    
    var books: [Book] = [
        Book.init(title: "Clean Code", link: "https://amzn.to/2YqSuEu",
                  image: UIImage(named: "jon-snow")!),
        Book.init(title: "Elegant Objects", link: "https://amzn.to/32N4dg0",
                  image: UIImage(named: "jon-snow")!),
        Book.init(title: "Design Patterns", link: "https://amzn.to/2YkHCZ2",
                  image: UIImage(named: "jon-snow")!)
    ]
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                List(books, id: \.title, rowContent: { item in
                    NavigationLink(destination: Text(item.title)) {
                        HStack {
                            Image(uiImage: item.image).resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 120, height: 160)
                                .cornerRadius(8)
                                .shadow(radius: 10)
                            
                            VStack(alignment: .leading) {
                                Text(item.title).fontWeight(.bold)
                                Text(item.link).font(.callout)
                            }
                        }.padding([.top, .bottom], 10)
                    }
                }).navigationBarTitle("Books")
                    .navigationBarItems(trailing: Button(action: {
                        self.showSheet.toggle()
                    }, label: {
                        Text("Search")
                    }))
                
                
                /*
                ZStack {
                    Image("jon-snow")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .blur(radius: 10, opaque: true)
                    
                    Image("jon-snow")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                        .shadow(radius: 10)
                }
                
                Spacer()
                 */
                
                /*
                HStack {
                    Text("Menu")
                       .font(.largeTitle)
                       .padding(.bottom, 20)
                    Spacer()
                    Button("Reset", action: {
                        self.pizze = 0
                        self.cokes = 0
                        self.address = ""
                        self.premiumDelivery = false
                    })
                }
                Stepper(value: $pizze,
                        in: 0...10,
                        label: {
                    Text("Pizza Margherita")
                    Text("\(pizze)")
                })
                Stepper(value: $cokes,
                        in: 0...10,
                        label: {
                    Text("Cokes")
                    Text("\(cokes)")
                })
                HStack {
                    Text("Prezzo finale")
                    Spacer()
                    Text("\(format(x: finalPrice))")
                }
                
                if (finalPrice > 0) {
                    VStack {
                        Text("Indirizzo di spedizione")
                        TextField("Via...", text: $address)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        Toggle(isOn: $premiumDelivery, label: {
                            Text("Spedizione prioritaria")
                        })
                    }
                }
                 */
                
            }
            //.padding()
            //.edgesIgnoringSafeArea(.top)
        
        }.sheet(isPresented: $showSheet, content: {
            VStack {
                Text("Hello World!")
                Spacer()
                Button(action: {
                    self.showSheet.toggle()
                }, label: {
                    Text("Close")
                })
            }.padding()
        })
    }
    
    func format(x: Double) -> String {
        String(format: "%.2f", x)
    }
    
}

struct Book {
    let title: String
    let link: String
    let image: UIImage
}

#if DEBUG
struct Demo1_Preview : PreviewProvider {
    static var previews: some View {
        Demo1()
    }
}
#endif
