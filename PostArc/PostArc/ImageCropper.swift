import SwiftUI
import CropViewController

struct ImageCropper: UIViewControllerRepresentable {
    @Binding var images: [UIImage]
    @Binding var selectedImage: UIImage?
    @Environment(\.presentationMode) private var presentationMode

    func makeUIViewController(context: Context) -> CropViewController {
        let cropViewController = CropViewController(croppingStyle: .default, image: selectedImage ?? UIImage())
        cropViewController.delegate = context.coordinator
        return cropViewController
    }

    func updateUIViewController(_ uiViewController: CropViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, CropViewControllerDelegate {
        var parent: ImageCropper

        init(_ parent: ImageCropper) {
            self.parent = parent
        }

        func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
            parent.images.append(image) // Append the cropped image to the images array
            parent.selectedImage = nil // Reset selected image to allow for another selection
            parent.presentationMode.wrappedValue.dismiss()
        }

        func cropViewController(_ cropViewController: CropViewController, didFinishCancelled cancelled: Bool) {
            // Clear the selected image and dismiss the crop view
            parent.selectedImage = nil
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}
