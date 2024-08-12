//
//  PostcardDetailView.swift
//  PostArc
//
//  Created by Yixuan Liu on 8/12/24.
//

import SwiftUI

struct PostcardDetailView: View {
    @Binding var postcard: Postcard

    var body: some View {
        VStack {
            Image(uiImage: postcard.image)
                .resizable()
                .scaledToFit()
                .frame(height: 200)
                .padding()

            TextField("From Where", text: $postcard.fromWhere)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            TextField("To Where", text: $postcard.toWhere)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            TextField("From Who", text: $postcard.fromWho)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            TextField("To Who", text: $postcard.toWho)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            TextField("Description", text: $postcard.description)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
        }
        .navigationTitle("Postcard Details")
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    // Any additional save logic if needed
                    
                }
                Button("Edit") {
                    
                }
                Button("Delete") {
                    
                }
            }
        }
    }
}

struct PostcardDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PostcardDetailView(postcard: .constant(Postcard(image: UIImage())))
    }
}

