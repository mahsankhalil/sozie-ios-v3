//
//  RequestImagePickerController.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 10/17/19.
//  Copyright © 2019 Danial Zahid. All rights reserved.
//

import UIKit
import AVKit
protocol CaptureManagerDelegate: class {
    func processCapturedImage(image: UIImage)
}
class RequestImagePickerController: UIViewController {
    @IBOutlet weak var sampleImageView: UIImageView!
    @IBOutlet weak var imageViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var cameraViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var textViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var intensityLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var usePhotoButton: UIButton!
    @IBOutlet weak var retakeButton: UIButton!
    @IBOutlet weak var camerView: UIView!
    var previewLayer: AVCaptureVideoPreviewLayer!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var howToButton: UIButton!
    @IBOutlet weak var captureButton: UIButton!
    var captureSession: AVCaptureSession?
    weak var delegate: CaptureManagerDelegate?
    var currentImage: UIImage?
    var photoIndex: Int?
    var overlayImageView: UIImageView?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        hideShowSampleImageView()
        var topPadding: CGFloat! = 0.0
        var bottomPadding: CGFloat! = 0.0
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.keyWindow
            topPadding = window?.safeAreaInsets.top ?? 0.0
            bottomPadding = window?.safeAreaInsets.bottom ?? 0.0
        }
        imageViewHeightConstraint.constant = (UIScreen.main.bounds.size.width/9.0)*16.0
        cameraViewHeightConstraint.constant = (UIScreen.main.bounds.size.width/9.0)*16.0
        captureSession = AVCaptureSession()
        guard let captureDevice = AVCaptureDevice.default(for: .video),
            let input = try? AVCaptureDeviceInput(device: captureDevice) else {return}
        captureSession?.addInput(input)
        captureSession?.startRunning()
//        let offset = topPadding + bottomPadding + 64.0 + 90
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
        previewLayer.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: cameraViewHeightConstraint.constant)
        previewLayer.videoGravity = .resizeAspectFill
        camerView.layer.addSublayer(previewLayer)
        overlayImageView = UIImageView(image: UIImage(named: "Canvas-Camera"))
        overlayImageView?.frame.size.height = UIScreen.main.bounds.size.height - 140.0
        overlayImageView?.frame.size.width = (overlayImageView?.frame.size.height)! * (9.0/16.0)
        overlayImageView?.center.x = UIScreen.main.bounds.size.width/2.0
        overlayImageView?.center.y = (UIScreen.main.bounds.size.height - 90.0 - bottomPadding)/2.0
        overlayImageView?.layer.borderWidth = 1.0
        overlayImageView?.layer.borderColor = UIColor.white.cgColor
        if let imageView = overlayImageView {
            camerView.addSubview(imageView)
        }
        let subView = self.createOverlay(frame: previewLayer.frame, xOffset: 10, yOffset: topPadding, radius: 10)
        camerView.addSubview(subView)
//        let faceImageView = UIImageView(image: UIImage(named: "Face"))
//        let feetImageView = UIImageView(image: UIImage(named: "Feet"))
//        faceImageView.frame.origin = CGPoint(x: ((UIScreen.main.bounds.size.width - faceImageView.frame.size.width)/2.0), y: topPadding)
//        camerView.addSubview(faceImageView)
//        feetImageView.frame.origin = CGPoint(x: ((UIScreen.main.bounds.size.width - feetImageView.frame.size.width)/2.0), y: cameraViewHeightConstraint.constant - 90 - 92)
//        camerView.addSubview(feetImageView)
        let output = AVCaptureVideoDataOutput()
        output.videoSettings = ([kCVPixelBufferPixelFormatTypeKey as AnyHashable: kCVPixelFormatType_32BGRA] as! [String: Any])
        output.setSampleBufferDelegate(self, queue: DispatchQueue.main)
        captureSession?.addOutput(output)
//        addGridOnView()
        textViewWidthConstraint.constant = overlayImageView?.frame.size.width ?? 0
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let _ = photoIndex {
//            self.perform(#selector(showPosePopup), with: nil, afterDelay: 1.0)
            showPosePopup()
        }
    }
    @objc func showPosePopup() {
        let popUpInstnc = PosePopupVC.instance(photoIndex: photoIndex)
        let popUpVC = PopupController
            .create(self)
            .show(popUpInstnc)
        let options = PopupCustomOption.layout(.top)
        _ = popUpVC.customize([options])
        popUpVC.updatePopUpSize()
        popUpInstnc.closeHandler = { []  in
            popUpVC.dismiss()
        }
    }
    func hideShowSampleImageView() {
//        self.sampleImageView.isHidden = false
//        if let index = photoIndex {
//            switch index {
//            case 0:
//                self.sampleImageView.image = UtilityManager.genderRespectedFrontImage()
//            case 1:
//                self.sampleImageView.image = UtilityManager.genderRespectedBackImage()
//            case 2:
//                self.sampleImageView.image = UtilityManager.genderRespectedSideImage()
//            default:
//                self.sampleImageView.isHidden = true
//            }
//        } else {
//            self.sampleImageView.isHidden = true
//        }
        self.sampleImageView.isHidden = true
    }
//    func addGridOnView() {
//        let xPosition = UIScreen.main.bounds.width/3
//        let firstVertLine = UIView(frame: CGRect(x: xPosition, y: 0.0, width: 0.5, height: previewLayer.frame.height))
//        let secondVertLine = UIView(frame: CGRect(x: 2*xPosition, y: 0.0, width: 0.5, height: previewLayer.frame.height))
//        let yPosition = previewLayer.frame.height/3
//        let firstHorLine = UIView(frame: CGRect(x: 0, y: yPosition, width: UIScreen.main.bounds.width, height: 0.5))
//        let secondHorLine = UIView(frame: CGRect(x: 0, y: 2*yPosition, width: UIScreen.main.bounds.width, height: 0.5))
//
//        firstVertLine.backgroundColor = UIColor.white
//        secondVertLine.backgroundColor = UIColor.white
//        firstHorLine.backgroundColor = UIColor.white
//        secondHorLine.backgroundColor = UIColor.white
//
//        camerView.addSubview(firstVertLine)
//        camerView.addSubview(secondVertLine)
//        camerView.addSubview(firstHorLine)
//        camerView.addSubview(secondHorLine)
//    }
    func createOverlay(frame: CGRect,
                       xOffset: CGFloat,
                       yOffset: CGFloat,
                       radius: CGFloat) -> UIView {
        // Step 1
        let overlayView = UIView(frame: frame)
        overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        // Step 2
        let path = CGMutablePath()
        path.addRect(CGRect(origin: .zero, size: overlayView.frame.size))
        path.addRect(overlayImageView!.frame)
        // Step 3
        let maskLayer = CAShapeLayer()
        maskLayer.backgroundColor = UIColor.black.cgColor
        maskLayer.path = path
        // For Swift 4.0
        maskLayer.fillRule = CAShapeLayerFillRule.evenOdd
        // For Swift 4.2
        maskLayer.fillRule = .evenOdd
        // Step 4
        overlayView.layer.mask = maskLayer
        overlayView.clipsToBounds = true
        return overlayView
    }
    @IBAction func userPhotoButtonTapped(_ sender: Any) {
        if let image = currentImage {
            delegate?.processCapturedImage(image: image)
            self.dismiss(animated: true, completion: nil)
        }
    }
    @IBAction func retakeButtonTapped(_ sender: Any) {
        captureSession?.startRunning()
        self.imageView.isHidden = true
        if let index = photoIndex, index < 3 {
            self.sampleImageView.isHidden = false
        }
        self.captureButton.isHidden = false
        self.howToButton.isHidden = false
        self.cancelButton.isHidden = false
        self.retakeButton.isHidden = true
        self.usePhotoButton.isHidden = true
    }
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func poseButtonTapped(_ sender: Any) {
        showPosePopup()
    }
    @IBAction func captureButtontapped(_ sender: Any) {
        captureSession?.stopRunning()
        self.imageView.image = currentImage
        self.sampleImageView.isHidden = true
        self.imageView.isHidden = false
        self.captureButton.isHidden = true
        self.howToButton.isHidden = true
        self.cancelButton.isHidden = true
        self.retakeButton.isHidden = false
        self.usePhotoButton.isHidden = false
    }
    @IBAction func howToButtonTaapped(_ sender: Any) {
        showPosePopup()
//        if let session = captureSession {
//            //Indicate that some changes will be made to the session
//            session.beginConfiguration()
//            //Remove existing input
//            guard let currentCameraInput: AVCaptureInput = session.inputs.first else {
//                return
//            }
//            session.removeInput(currentCameraInput)
//            //Get new input
//            var newCamera: AVCaptureDevice! = nil
//            if let input = currentCameraInput as? AVCaptureDeviceInput {
//                if input.device.position == .back {
//                    newCamera = cameraWithPosition(position: .front)
//                } else {
//                    newCamera = cameraWithPosition(position: .back)
//                }
//            }
//            //Add input to session
//            var err: NSError?
//            var newVideoInput: AVCaptureDeviceInput!
//            do {
//                newVideoInput = try AVCaptureDeviceInput(device: newCamera)
//            } catch let err1 as NSError {
//                err = err1
//                newVideoInput = nil
//            }
//            if newVideoInput == nil || err != nil {
//                print("Error creating capture device input: \(err?.localizedDescription ?? "Error")")
//            } else {
//                session.addInput(newVideoInput)
//            }
//            //Commit all the configuration changes at once
//            session.commitConfiguration()
//        }
    }
    func cameraWithPosition(position: AVCaptureDevice.Position) -> AVCaptureDevice? {
        let discoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .unspecified)
        for device in discoverySession.devices where device.position == position {
            return device
        }
        return nil
    }
    func getImageFromSampleBuffer(sampleBuffer: CMSampleBuffer) -> UIImage? {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return nil
        }
//        let cameraImage = CIImage(cvPixelBuffer: pixelBuffer)
//        let image = UIImage(ciImage: cameraImage)
//        CVPixelBufferUnlockBaseAddress(pixelBuffer, .readOnly)
//        return image
        CVPixelBufferLockBaseAddress(pixelBuffer, .readOnly)
        let baseAddress = CVPixelBufferGetBaseAddress(pixelBuffer)
        let width = CVPixelBufferGetWidth(pixelBuffer)
        let height = CVPixelBufferGetHeight(pixelBuffer)
        let bytesPerRow = CVPixelBufferGetBytesPerRow(pixelBuffer)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedFirst.rawValue | CGBitmapInfo.byteOrder32Little.rawValue)
        guard let context = CGContext(data: baseAddress, width: width, height: height, bitsPerComponent: 8, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo.rawValue) else {
            return nil
        }
        guard let cgImage = context.makeImage() else {
            return nil
        }
        let image = UIImage(cgImage: cgImage, scale: 1, orientation: .right)
        CVPixelBufferUnlockBaseAddress(pixelBuffer, .readOnly)
        return self.cropToPreviewLayer(originalImage: image)
    }
    func cropToPreviewLayer(originalImage: UIImage) -> UIImage {
        let outputRect = previewLayer.metadataOutputRectConverted(fromLayerRect: overlayImageView!.frame)
        var cgImage = originalImage.cgImage!
        let width = CGFloat(cgImage.width)
        let height = CGFloat(cgImage.height)
        let cropRect = CGRect(x: outputRect.origin.x * width, y: outputRect.origin.y * height, width: outputRect.size.width * width, height: outputRect.size.height * height)
        cgImage = cgImage.cropping(to: cropRect)!
        let croppedUIImage = UIImage(cgImage: cgImage, scale: 1.0, orientation: originalImage.imageOrientation)
        return croppedUIImage
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension RequestImagePickerController: AVCaptureVideoDataOutputSampleBufferDelegate {
//    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputSampleBuffer sampleBuffer: CMSampleBuffer!, from connection: AVCaptureConnection!) {
//        guard let outputImage = getImageFromSampleBuffer(sampleBuffer: sampleBuffer) else {
//            return
//        }
//        delegate?.processCapturedImage(image: outputImage)
//    }
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let outputImage = getImageFromSampleBuffer(sampleBuffer: sampleBuffer) else {
            return
        }
        currentImage = outputImage
//        let rawMetadata = CMCopyDictionaryOfAttachments(allocator: nil, target: sampleBuffer, attachmentMode: CMAttachmentMode(kCMAttachmentMode_ShouldPropagate))
//        let metadata = CFDictionaryCreateMutableCopy(nil, 0, rawMetadata) as NSMutableDictionary
//        let exifData = metadata.value(forKey: "{Exif}") as? NSMutableDictionary
//        let fNumber: Double = exifData?["FNumber"] as! Double
//        let exposureTime: Double = exifData?["ExposureTime"] as! Double
//        let isoSpeedRatingsArray = exifData!["ISOSpeedRatings"] as? NSArray
//        let isoSpeedRatings: Double = isoSpeedRatingsArray![0] as! Double
//        let calibrationConstant: Double = 50
        //Calculating the luminosity
//        let luminosity: Double = (calibrationConstant * fNumber * fNumber ) / ( exposureTime * isoSpeedRatings )
//        intensityLabel.text = String(luminosity)
//        print(luminosity)
    }
}
