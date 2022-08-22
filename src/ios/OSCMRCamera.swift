class OSCMRCamera: NSObject {
    private let handler: OSCMRHandlerDelegate
    
    init(handler: OSCMRHandlerDelegate) {
        self.handler = handler
    }
}

extension OSCMRCamera: OSCMRActionDelegate {
    func takePicture(with options: OSCMRPictureOptions) {
        if options.sourceType == .photoLibrary {
            self.handler.choosePicture(with: options)
        }
    }
}
