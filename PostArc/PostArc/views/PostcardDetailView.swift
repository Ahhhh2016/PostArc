import SwiftUI

struct PostcardDetailView: View {
    @Binding var postcard: Postcard
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var postcardData: PostcardData
    @State private var isEditing = true

    var body: some View {
        VStack {
            ForEach(postcard.images, id: \.self) { image in
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                    .padding()
            }

            if isEditing {
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
            } else {
                VStack(alignment: .leading) {
                    Text("From: \(postcard.fromWhere)")
                        .padding(.bottom, 4)
                    Text("To: \(postcard.toWhere)")
                        .padding(.bottom, 4)
                    Text("From Who: \(postcard.fromWho)")
                        .padding(.bottom, 4)
                    Text("To Who: \(postcard.toWho)")
                        .padding(.bottom, 4)
                    Text("Description: \(postcard.description)")
                        .padding(.bottom, 4)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .navigationTitle("Postcard Details")
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                if isEditing {
                    Button("Save") {
                        // Save the changes and exit edit mode
                        postcardData.updatePostcard(postcard, fromWhere: postcard.fromWhere, toWhere: postcard.toWhere, fromWho: postcard.fromWho, toWho: postcard.toWho, description: postcard.description,
                            date: postcard.date)
                        isEditing.toggle()
                    }
                } else {
                    Button("Edit") {
                        // Enter edit mode
                        isEditing.toggle()
                    }
                }
            }

            if !isEditing {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Delete") {
                        // Delete the postcard and dismiss the view
                        if let index = postcardData.postcards.firstIndex(of: postcard) {
                            postcardData.deletePostcard(at: IndexSet(integer: index))
                        }
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(.red)
                }
            }
        }
    }
}

//struct PostcardDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        PostcardDetailView(postcard: .constant(Postcard(image: UIImage())))
//            .environmentObject(PostcardData())
//    }
//}


struct PostcardDetailView_Previews: PreviewProvider {
    static var previews: some View {
        // Create an array of sample images for the preview
        let sampleImages = [
            UIImage(named: "sampleImage1") ?? UIImage(),
            UIImage(named: "sampleImage2") ?? UIImage()
        ]
        
        PostcardDetailView(postcard: .constant(Postcard(images: sampleImages, fromWhere: "Paris", toWhere: "New York", fromWho: "Alice", toWho: "Bob", description: "Greetings from Paris!", date: Date())))
            .environmentObject(PostcardData())
    }
}
