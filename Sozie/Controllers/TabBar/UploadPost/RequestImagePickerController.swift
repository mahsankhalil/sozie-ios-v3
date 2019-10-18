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
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var usePhotoButton: UIButton!
    @IBOutlet weak var retakeButton: UIButton!
    @IBOutlet weak var camerView: UIView!
    var previewLayer: AVCaptureVideoPreviewLayer!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var captureButton: UIButton!
    var captureSession: AVCaptureSession?
    weak var delegate: CaptureManagerDelegate?
    var currentImage: UIImage?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        var topPadding: CGFloat! = 0.0
        var bottomPadding: CGFloat! = 0.0
        
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.keyWindow
            topPadding = window?.safeAreaInsets.top ?? 0.0
            bottomPadding = window?.safeAreaInsets.bottom ?? 0.0
        }
        captureSession = AVCaptureSession()
        guard let captureDevice = AVCaptureDevice.default(for: .video),
            let input = try? AVCaptureDeviceInput(device: captureDevice) else {return}
        captureSession?.addInput(input)
        captureSession?.startRunning()
        let offset = topPadding + bottomPadding + 64.0 + 110
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
        previewLayer.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: (UIScreen.main.bounds.size.height - offset))
        previewLayer.videoGravity = .resizeAspectFill
        camerView.layer.addSublayer(previewLayer)
        let subView = self.createOverlay(frame: previewLayer.frame, xOffset: 10, yOffset: 10, radius: 10)
        camerView.addSubview(subView)
        let faceImageView = UIImageView(image: UIImage(named: "Face"))
        let feetImageView = UIImageView(image: UIImage(named: "Feet"))
        faceImageView.frame.origin = CGPoint(x: ((UIScreen.main.bounds.size.width - faceImageView.frame.size.width)/2.0), y: 10)
        camerView.addSubview(faceImageView)
        feetImageView.frame.origin = CGPoint(x: ((UIScreen.main.bounds.size.width - feetImageView.frame.size.width)/2.0), y: 409)
        camerView.addSubview(feetImageView)
        
        let output = AVCaptureVideoDataOutput()
        output.videoSettings = [kCVPixelBufferPixelFormatTypeKey as AnyHashable: kCVPixelFormatType_32BGRA] as! [String : Any]
        output.setSampleBufferDelegate(self, queue: DispatchQueue.main)
        captureSession?.addOutput(output)
    }
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
        path.addEllipse(in: CGRect(origin: CGPoint(x: ((UIScreen.main.bounds.size.width - 70.0)/2.0), y: yOffset), size: CGSize(width: 70, height: 91)))
        //        path.addEllipse(in: CGRect(origin: CGPoint(x: xOffset, y: yOffset), size: CGSize(width: 70, height: 91)))
        path.addRect(CGRect(origin:  CGPoint(x: ((UIScreen.main.bounds.size.width - 239.0)/2.0), y: 420), size: CGSize(width: 239, height: 69)))
        
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
        self.captureButton.isHidden = false
        self.cameraButton.isHidden = false
        self.cancelButton.isHidden = false
        self.retakeButton.isHidden = true
        self.usePhotoButton.isHidden = true
    }
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func captureButtontapped(_ sender: Any) {
        captureSession?.stopRunning()
        self.imageView.image = currentImage
        self.imageView.isHidden = false
        self.captureButton.isHidden = true
        self.cameraButton.isHidden = true
        self.cancelButton.isHidden = true
        self.retakeButton.isHidden = false
        self.usePhotoButton.isHidden = false
        
    }
    @IBAction func cameraButtonTaapped(_ sender: Any) {
        if let session = captureSession {
            //Indicate that some changes will be made to the session
            session.beginConfiguration()
            //Remove existing input
            guard let currentCameraInput: AVCaptureInput = session.inputs.first else {
                return
            }
            session.removeInput(currentCameraInput)
            //Get new input
            var newCamera: AVCaptureDevice! = nil
            if let input = currentCameraInput as? AVCaptureDeviceInput {
                if (input.device.position == .back) {
                    newCamera = cameraWithPosition(position: .front)
                } else {
                    newCamera = cameraWithPosition(position: .back)
                }
            }
            //Add input to session
            var err: NSError?
            var newVideoInput: AVCaptureDeviceInput!
            do {
                newVideoInput = try AVCaptureDeviceInput(device: newCamera)
            } catch let err1 as NSError {
                err = err1
                newVideoInput = nil
            }
            if newVideoInput == nil || err != nil {
                print("Error creating capture device input: \(err?.localizedDescription)")
            } else {
                session.addInput(newVideoInput)
            }
            //Commit all the configuration changes at once
            session.commitConfiguration()
        }
    }
    func cameraWithPosition(position: AVCaptureDevice.Position) -> AVCaptureDevice? {
        let discoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .unspecified)
        for device in discoverySession.devices {
            if device.position == position {
                return device
            }
        }
        return nil
    }
    func getImageFromSampleBuffer(sampleBuffer: CMSampleBuffer) ->UIImage? {
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
        let image = UIImage(cgImage: cgImage, scale: 1, orientation:.right)
        CVPixelBufferUnlockBaseAddress(pixelBuffer, .readOnly)
        return self.cropToPreviewLayer(originalImage: image)
    }
    func cropToPreviewLayer(originalImage: UIImage) -> UIImage {
        let outputRect = previewLayer.metadataOutputRectConverted(fromLayerRect: previewLayer.bounds)
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
    }
}
