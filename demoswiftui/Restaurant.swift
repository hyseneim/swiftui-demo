//
//  Restaurant.swift
//  demoswiftui
//
//  Created by Gabriele Cipolloni on 12/04/23.
//

import SwiftUI

@MainActor
class RestaurantViewModel: ObservableObject {
    @Published var text = "Not updated"
    @Published var buttonText = "Update"
    @Published var counter = 0
    
    func changeText() {
        Task {
            sleep(3)
            
            DispatchQueue.main.async {
                self.text = "Text changed"
                self.buttonText = "Reset"
            }
        }
    }
}

struct Restaurant : View {
    
    @StateObject var viewModel = RestaurantViewModel()
    
    var body: some View {
        VStack(spacing: 30) {
            Text("\(viewModel.text)")
                .font(.largeTitle)
            
            Button(viewModel.buttonText) {
                viewModel.changeText()
            }
            
            Button("Tapped: \(viewModel.counter)") {
                viewModel.counter += 1
            }.foregroundColor(.orange)
            
            NestedView(viewModel: viewModel)
        }
    }
    
}

struct NestedView: View {
    
    @ObservedObject var viewModel: RestaurantViewModel
    
    var body: some View {
        Text("\(viewModel.counter)").font(.system(size: 40, weight: .bold))
    }
    
}

#if DEBUG
struct Restaurant_Preview: PreviewProvider {
    static var previews: some View {
        Restaurant()
    }
}
#endif
