import SwiftUI

struct ContentView: View {
    @StateObject private var postcardData = PostcardData()
    @State private var isImagePickerPresented = false
    @State private var isImageCropperPresented = false
    @State private var selectedImage: UIImage?
    @State private var images: [UIImage] = [] // To store multiple images
    @State private var selectedPostcard: Postcard?

    var body: some View {
        NavigationStack {
            VStack {
                if postcardData.postcards.isEmpty {
                    Text("No postcards yet")
                        .font(.headline)
                        .padding()
                } else {
                    List {
                        ForEach(postcardData.postcards) { postcard in
                            Button(action: {
                                selectedPostcard = postcard
                            }) {
                                Image(uiImage: postcard.images.first ?? UIImage())
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 200)
                                    .padding()
                                    .background(Color.white)
                                    .cornerRadius(10)
                                    .shadow(radius: 5)
                            }
                            .buttonStyle(PlainButtonStyle())
                            .background(
                                NavigationLink(
                                    destination: PostcardDetailView(postcard: Binding(
                                        get: {
                                            postcardData.postcards.first(where: { $0.id == postcard.id }) ?? postcard
                                        },
                                        set: { newPostcard in
                                            if let index = postcardData.postcards.firstIndex(where: { $0.id == newPostcard.id }) {
                                                postcardData.postcards[index] = newPostcard
                                            }
                                        }
                                    )),
                                    isActive: Binding<Bool>(
                                        get: { selectedPostcard == postcard },
                                        set: { _ in }
                                    )
                                ) {
                                    EmptyView()
                                }
                                .hidden()
                            )
                        }
                    }
                }
                Button(action: {
                    if images.count < 2 { // Check if less than 2 images are added
                        isImagePickerPresented = true
                    } else {
                        // Optionally, show an alert or message that only 2 images are allowed
                        print("Only 2 images allowed")
                    }
                }) {
                    Text("Add Postcard")
                        .padding()
                        .background(images.count < 2 ? Color.blue : Color.gray) // Disable if limit reached
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding()
                .sheet(isPresented: $isImagePickerPresented, onDismiss: {
                    if selectedImage != nil && images.count < 2 {
                        isImageCropperPresented = true
                    }
                }) {
                    ImagePicker(selectedImage: $selectedImage)
                }
                .sheet(isPresented: $isImageCropperPresented, onDismiss: {
                    if let croppedImage = selectedImage, images.count < 2 {
                        images.append(croppedImage)
                    }
                    if images.count == 2 {
                        postcardData.addPostcard(images)
                        images.removeAll() // Clear images after saving to Postcard
                    }
                }) {
                    ImageCropper(images: $images, selectedImage: $selectedImage)
                }
            }
            .navigationTitle("Postcard Album")
            .toolbar {
                EditButton()
            }
        }
    }
}
