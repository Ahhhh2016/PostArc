//
//  ContentView.swift
//  PostArc
//
//  Created by Yixuan Liu on 8/12/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var postcardData = PostcardData()
    @State private var isImagePickerPresented = false
    @State private var isImageCropperPresented = false
    @State private var selectedImage: UIImage?

    var body: some View {
        NavigationView {
            VStack {
                if postcardData.images.isEmpty {
                    Text("No postcards yet")
                        .font(.headline)
                        .padding()
                } else {
                    ScrollView {
                        ForEach(postcardData.images, id: \.self) { image in
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 200)
                                .padding()
                        }
                    }
                }
                Button(action: {
                    isImagePickerPresented = true
                }) {
                    Text("Add Postcards")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding()
                .sheet(isPresented: $isImagePickerPresented, onDismiss: {
                    if selectedImage != nil {
                        isImageCropperPresented = true
                    }
                }) {
                    ImagePicker(images: $postcardData.images, selectedImage: $selectedImage)
                }
                .sheet(isPresented: $isImageCropperPresented, onDismiss: {
                    // If cropping is canceled, re-present the image picker
                    if selectedImage == nil {
                        isImagePickerPresented = true
                    } else if let croppedImage = selectedImage {
                        // Save the cropped image if cropping was successful
                        postcardData.addImage(croppedImage)
                    }
                }) {
                    ImageCropper(image: $selectedImage)
                }
            }
            .navigationTitle("Postcard Album")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
