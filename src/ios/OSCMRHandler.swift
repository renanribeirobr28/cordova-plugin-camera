import PhotosUI
import UIKit

class OSCMRHandler: NSObject {
    private let permissionsBehaviour: OSCMRPermissions
    
    private let viewController: UIViewController
    private let pickerViewController: PHPickerViewController
    
    init(permissionsBehaviour: OSCMRPermissions, viewController: UIViewController) {
        self.permissionsBehaviour = permissionsBehaviour
        self.viewController = viewController
        
        var config = PHPickerConfiguration()
        config.filter = .images
        self.pickerViewController = PHPickerViewController(configuration: config)
        
        super.init()
        
        // Observe photo library changes
        PHPhotoLibrary.shared().register(self)
        self.pickerViewController.delegate = self
    }
}

extension OSCMRHandler: OSCMRHandlerDelegate {
    func choosePicture(with options: OSCMRPictureOptions) {
        self.permissionsBehaviour.checkPermissions(for: .readWrite) { authorizationStatus in
            switch authorizationStatus {
            case .limited:
                self.showAlertViewController()
            case .authorized:
                self.viewController.present(self.pickerViewController, animated: true)
            default:
                break
            }
        }
    }
    
    private func showAlertViewController() {
        let alertController = UIAlertController(
            title: Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String, message: "Random message.", preferredStyle: .alert
        )
        
        let continueAction = UIAlertAction(title: "Continue", style: .default) { _ in
            self.viewController.present(self.pickerViewController, animated: true)
        }
        let changeAction = UIAlertAction(title: "Change Current Selection", style: .default) { _ in
            PHPhotoLibrary.shared().presentLimitedLibraryPicker(from: self.viewController)
        }
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { _ in
            guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else { return }
            UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
            print("Go to Settings App.")
        }
        alertController.addAction(continueAction)
        alertController.addAction(changeAction)
        alertController.addAction(settingsAction)
        
        self.viewController.present(alertController, animated: true)
    }
}

extension OSCMRHandler: PHPhotoLibraryChangeObserver {
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        DispatchQueue.main.async {
            self.viewController.present(self.pickerViewController, animated: true)
        }
    }
}

extension OSCMRHandler: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        self.pickerViewController.dismiss(animated: true)
        
        print("Go to new screen with the new selection.")
    }
}
