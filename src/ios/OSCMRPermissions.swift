import Photos

class OSCMRPermissions: NSObject {
    func checkPermissions(for accessLevel: PHAccessLevel, _ completion: @escaping (PHAuthorizationStatus) -> Void) {
        let authorizationStatus = PHPhotoLibrary.authorizationStatus(for: accessLevel)
        if authorizationStatus == .notDetermined {
            PHPhotoLibrary.requestAuthorization(for: accessLevel) { completion($0) }
        } else {
            completion(authorizationStatus)
        }
    }
}
