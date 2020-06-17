//
//  VideoPickerVC.swift
//  Sozie
//
//  Created by Zaighum Ghazali Khan on 6/15/20.
//  Copyright © 2020 Danial Zahid. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
protocol CustomVideoRecorderDelegate: class {
    func customImagePickerController(_ picker: VideoPickerVC, didFinishPickingMediaWithInfo info: [String: Any])
}
class VideoPickerVC: UIViewController {
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var howToButton: UIButton!
    @IBOutlet weak var captureButton: UIButton!
    var timer: Timer!
    var count = 20
    var session: AVCaptureSession?
    var input: AVCaptureDeviceInput?
    var micInput: AVCaptureDeviceInput?
    var videoFileOutput: AVCaptureMovieFileOutput?
    var previewLayer: AVCaptureVideoPreviewLayer?
    weak var delegate: CustomVideoRecorderDelegate!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupVideoCapture()
    }
    func getDevice(position: AVCaptureDevice.Position) -> AVCaptureDevice? {
        return AVCaptureDevice.default(.builtInWideAngleCamera, for: AVMediaType.video, position: position)
    }
    @objc func update() {
        if self.count > 0 {
            self.count = self.count - 1
        } else {
            self.videoFileOutput?.stopRecording()
            self.timer.invalidate()
            self.captureButton.setImage(UIImage(named: "Record"), for: .normal)
        }
    }
    func setupVideoCapture() {
        self.session = AVCaptureSession()
        let camera = getDevice(position: .back)
        let micDevice: AVCaptureDevice? = {
            return AVCaptureDevice.default(for: .audio)
        }()
        do {
            micInput = try AVCaptureDeviceInput(device: micDevice!)
        } catch _ as NSError {
        }
        do {
            input = try AVCaptureDeviceInput(device: camera!)
        } catch let error as NSError {
            print(error)
            input = nil
        }
        session?.sessionPreset = AVCaptureSession.Preset.medium
        if session?.canAddInput(input!) == true {
            session?.addInput(input!)
            if (session?.canAddInput(micInput!))! {
                session?.addInput(micInput!)
            }
            previewLayer = AVCaptureVideoPreviewLayer(session: session!)
            previewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
            previewLayer?.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
            previewLayer?.frame = self.cameraView.bounds
            self.cameraView.layer.addSublayer(previewLayer!)
            session?.startRunning()
        }
    }
    func startRecording() {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(update), userInfo: nil, repeats: true)
        //        sessionQueue.async {
        let recordingDelegate: AVCaptureFileOutputRecordingDelegate? = self
        self.videoFileOutput = AVCaptureMovieFileOutput()
        self.session?.addOutput(self.videoFileOutput!)
        let documentsURL: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let filePath = documentsURL.appendingPathComponent("temp11.mp4")
        do {
            try FileManager.default.removeItem(at: filePath)
        } catch {
        }
        // Do recording and save the output to the `filePath`
        self.videoFileOutput?.startRecording(to: filePath, recordingDelegate: recordingDelegate!)
    }
    func manageCroppingToSquare(filePath: URL , completion: @escaping (_ outputURL : URL?) -> ()) {
        // output file
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let outputPath = documentsURL?.appendingPathComponent("squareVideo.mov")
        if FileManager.default.fileExists(atPath: (outputPath?.path)!) {
            do {
               try FileManager.default.removeItem(atPath: (outputPath?.path)!)
            }
            catch {
                print ("Error deleting file")
            }
        }
        //input file
        let asset = AVAsset.init(url: filePath)
        print (asset)
        let composition = AVMutableComposition.init()
        composition.addMutableTrack(withMediaType: AVMediaType.video, preferredTrackID: kCMPersistentTrackID_Invalid)

        //input clip
        let clipVideoTrack = asset.tracks(withMediaType: AVMediaType.video)[0]

        //make it square
        let videoComposition = AVMutableVideoComposition()
        videoComposition.renderSize = CGSize(width: CGFloat(clipVideoTrack.naturalSize.height), height: CGFloat(clipVideoTrack.naturalSize.height))
        videoComposition.frameDuration = CMTimeMake(value: 1, timescale: 30)
        let instruction = AVMutableVideoCompositionInstruction()
        instruction.timeRange = CMTimeRangeMake(start: CMTime.zero, duration: CMTimeMakeWithSeconds(60, preferredTimescale: 30))

        //rotate to potrait
        let transformer = AVMutableVideoCompositionLayerInstruction(assetTrack: clipVideoTrack)
        let t1 = CGAffineTransform(translationX: clipVideoTrack.naturalSize.height, y: -(clipVideoTrack.naturalSize.width - clipVideoTrack.naturalSize.height) / 2)
        let t2: CGAffineTransform = t1.rotated(by: .pi/2)
        let finalTransform: CGAffineTransform = t2
        transformer.setTransform(finalTransform, at: CMTime.zero)
        instruction.layerInstructions = [transformer]
        videoComposition.instructions = [instruction]

        //exporter
        let exporter = AVAssetExportSession.init(asset: asset, presetName: AVAssetExportPresetMediumQuality)
        exporter?.outputFileType = AVFileType.mov
        exporter?.outputURL = outputPath
        exporter?.videoComposition = videoComposition

        exporter?.exportAsynchronously() {
            if exporter?.status == .completed {
                print("Export complete")
                DispatchQueue.main.async(execute: {
                    completion(outputPath)
                })
                return
            } else if exporter?.status == .failed {
                print("Export failed - \(String(describing: exporter?.error))")
            }
            completion(nil)
            return
        }
    }
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.videoFileOutput?.stopRecording()
        if timer != nil {
            self.timer.invalidate()
        }
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func howToButtonTapped(_ sender: Any) {
    }
    @IBAction func captureButtonTapped(_ sender: Any) {
        if videoFileOutput == nil {
            self.startRecording()
            (sender as! UIButton).setImage(UIImage(named: "Stop"), for: .normal)
        } else {
            if videoFileOutput?.isRecording == false {
                self.session?.removeOutput(videoFileOutput!)
                self.startRecording()
                (sender as! UIButton).setImage(UIImage(named: "Stop"), for: .normal)
            } else {
                self.videoFileOutput?.stopRecording()
                self.timer.invalidate()
                (sender as! UIButton).setImage(UIImage(named: "Record"), for: .normal)
            }
        }
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

extension VideoPickerVC: AVCaptureFileOutputRecordingDelegate {
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        if self.videoFileOutput?.isRecording == false {
            self.videoFileOutput?.stopRecording()
            self.timer.invalidate()
            if FileManager.default.fileExists(atPath: outputFileURL.path) == false {
                self.setupVideoCapture()
                return
            }
            let vidAsset = AVURLAsset(url: outputFileURL)
            let duration = vidAsset.duration
            let seconds = Float(duration.value) / Float(duration.timescale)
            if seconds < 1.0 {
                self.setupVideoCapture()
                return
            }
            self.manageCroppingToSquare(filePath: outputFileURL) { (fileURL) in
                DispatchQueue.main.async {
//                    let videoRecorded = fileURL as URL
                    var info = [String: Any]()
                    info["UIImagePickerControllerMediaURL"] = fileURL
                    UtilityManager.showMessageWith(title: "Alert!", body: "Are you sure to user this video?", in: self, okBtnTitle: "Yes", cancelBtnTitle: "No", dismissAfter: nil, leftAligned: nil) {
                        self.delegate?.customImagePickerController(self, didFinishPickingMediaWithInfo: info)
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }
        }
    }
}
