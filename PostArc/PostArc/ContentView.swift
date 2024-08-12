import SwiftUI

struct ContentView: View {
    @StateObject private var postcardData = PostcardData()
    @State private var isImagePickerPresented = false
    @State private var isImageCropperPresented = false
    @State private var selectedImage: UIImage?

    var body: some View {
        NavigationView {
            VStack {
                if postcardData.postcards.isEmpty {
                    Text("No postcards yet")
                        .font(.headline)
                        .padding()
                } else {
                    List {
                        ForEach($postcardData.postcards) { $postcard in
                            NavigationLink(destination: PostcardDetailView(postcard: $postcard)) {
                                Image(uiImage: postcard.image)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 200)
                                    .padding()
                            }
                        }
                        .onDelete(perform: deletePostcard)
                    }
                }
                Button(action: {
                    isImagePickerPresented = true
                }) {
                    Text("Add Postcard")
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
                    ImagePicker(selectedImage: $selectedImage)
                }
                .sheet(isPresented: $isImageCropperPresented, onDismiss: {
                    if selectedImage == nil {
                        isImagePickerPresented = true
                    } else if let croppedImage = selectedImage {
                        postcardData.addPostcard(croppedImage)
                    }
                }) {
                    ImageCropper(image: $selectedImage)
                }
            }
            .navigationTitle("Postcard Album")
            .toolbar {
                EditButton()
            }
        }
    }

    private func deletePostcard(at offsets: IndexSet) {
        postcardData.deletePostcard(at: offsets)
    }
}
