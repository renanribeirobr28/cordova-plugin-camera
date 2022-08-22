struct OSCMRPictureOptions {
    let quality: Int
    let destinationType: DestinationType
    let encodingType: EncodingType
    let targetHeight: Int
    let targetWidth: Int
    let correctOrientation: Bool
    let sourceType: SourceType
    let allowEdit: Bool
}

extension OSCMRPictureOptions {
    enum DestinationType: Int {
        case dataURL
        case fileURI
        case nativeURI
    }
    
    enum EncodingType: Int {
        case jpeg
        case png
    }
    
    enum SourceType: Int {
        case photoLibrary
        case camera
    }
}
