//
//  settingCameraViewController.swift
//  videoTransmissionProject
//
//  Created by 吳尚霖 on 4/21/20.
//  Copyright © 2020 SamWu. All rights reserved.
//

import UIKit
import JitsiMeet
import AVFoundation

class settingCameraViewController: UIViewController{
    
    @IBOutlet var blackView: UIView!
    @IBOutlet var cameraView: UIView!
    @IBOutlet var optionView: UIView!
    @IBOutlet var soundBtn: UIButton!
    
    fileprivate var cameraId: String
    fileprivate var cameraName: String
    fileprivate var viewController: String
    var photoOutput:AVCapturePhotoOutput?
    
    //MARK: - init Function
    init(vcString: String,cameraID: String,cameraName: String) {
        cameraId = cameraID
        self.cameraName = cameraName
        viewController = vcString
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    //TODO: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        soundBtn.setImage(UIImage(named: "soundOn"), for: .normal)
        soundBtn.setImage(UIImage(named: "soundOff"), for: .selected)
        
        let flag = viewController.isEqual("observeCamera")
        blackView.isHidden = flag
        soundBtn.isHidden = !flag
        
        navigationBarItemInit()
        

        jitsiMeetInit()
                
    }
    
    @IBAction func SSSS(_ sender: Any) {
        
//        if(self.viewController != "observeCamera"){
//            let session = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: .video, position: .front)
//
//            let devices = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: .video, position: .back)
//
//            let captureSession = AVCaptureSession()
//            guard let input = try? AVCaptureDeviceInput(device: devices.devices.first!),
//                captureSession.canAddInput(input)
//                else { return }
//
//
//
//            if var nowInput = try? AVCaptureDeviceInput(device: session.devices.first!){
//
//                captureSession.beginConfiguration()
//
//                captureSession.sessionPreset = AVCaptureSession.Preset.hd1920x1080
//                captureSession.removeInput(nowInput)
//
//                if captureSession.canAddInput(input) {
//                    captureSession.addInput(input)
//                    nowInput = input
//                    photoOutput = AVCapturePhotoOutput()
//                    photoOutput?.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])], completionHandler: nil)
//                    if captureSession.canAddOutput(self.photoOutput!) { captureSession.addOutput(self.photoOutput!) }
//
//                    let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
//
//                    previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
//                    previewLayer.connection?.videoOrientation = .portrait
//
//                    view.layer.insertSublayer(previewLayer, at: 0)
//                    previewLayer.frame = cameraView.frame
//
//
//                } else {
//                    captureSession.addInput(nowInput)
//                }
//
//                captureSession.commitConfiguration()
//                captureSession.startRunning()
//
//            }
//        }
        
        
        
    }
    //MARK: - function
    fileprivate func navigationBarItemInit() {
          let backBtn = UIBarButtonItem (title: "Back", style: .plain, target: self, action:#selector(backBtnClick))
          self.navigationItem.leftBarButtonItem = backBtn
      }
      
      fileprivate func jitsiMeetInit() {
        
          let jitsiView = cameraView as! JitsiMeetView
          jitsiView.delegate = self
        
          let options = JitsiMeetConferenceOptions.fromBuilder { (builder) in
              builder.serverURL = url
              builder.room = "mmslab406mmslab406" + self.cameraId
              builder.subject = self.cameraName
            
              if(self.viewController == "observeCamera"){
                  builder.audioMuted = true
                  builder.videoMuted = true
              }
              
          }
        
       
        
//        do {
//            let input = try AVCaptureDeviceInput(device: (camera) )
//            let device = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInDualCamera], mediaType: AVMediaType.video, position: .unspecified)
//
//            AVCaptureSession().addInput(input)
//            AVCaptureSession().beginConfiguration()
//            AVCaptureSession().removeInput(input)
//            if AVCaptureSession().canAddInput(input) {
//            AVCaptureSession().addInput(input)
//            }
//            AVCaptureSession().commitConfiguration()
//        } catch let error as NSError {
//           print(error)
//        }
        jitsiView.join(options)
      }
    func switchCamera(){
        if(self.viewController != "observeCamera"){
            let session = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .back)
            
            let captureSession = AVCaptureSession()
            guard let input = try? AVCaptureDeviceInput(device: session.devices.first!),
                captureSession.canAddInput(input)
                else { return }
            
            let devices = AVCaptureDevice.DiscoverySession(deviceTypes: [ .builtInWideAngleCamera], mediaType: .video, position: .back).devices
            
            let new = try? AVCaptureDeviceInput(device: devices.first!)
            captureSession.removeInput(input)
            captureSession.addInput(new!)
            captureSession.startRunning()
        }
    }
    
    //MARK: - IBAction
    @IBAction func soundBtnClick(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected;
        let session = AVAudioSession.sharedInstance()
        if(sender.isHighlighted){
            try? session.setCategory(.playAndRecord, mode: .default ,options: .defaultToSpeaker)
            try? session.setActive(true, options: .notifyOthersOnDeactivation)
        }else{
            try? session.setActive(false, options: .notifyOthersOnDeactivation)
        }
        
    }
    
    //MARK: - 離開通話
    func leveCommunicate(){
        if(self.viewController == "setCamera"){
            let req = cameraDelete(id: cameraId)
            apiAgent.doCameraDelete(req: req)
        }
        let jitsiView = cameraView as! JitsiMeetView
        jitsiView.leave()
    }
    
    @objc func backBtnClick(){
        leveCommunicate()
    }
    
    @IBAction func hangUpBtnClick(_ sender: UIButton) {
        leveCommunicate()
    }
    
}



extension settingCameraViewController : JitsiMeetViewDelegate{
    func conferenceJoined(_ data: [AnyHashable : Any]!) {
        
    }
    func conferenceTerminated(_ data: [AnyHashable : Any]!) {
        self.navigationController?.popViewController(animated: true)
    }
}
