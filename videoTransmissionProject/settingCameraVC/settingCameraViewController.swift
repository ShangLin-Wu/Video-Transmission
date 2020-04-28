//
//  settingCameraViewController.swift
//  videoTransmissionProject
//
//  Created by 吳尚霖 on 4/21/20.
//  Copyright © 2020 SamWu. All rights reserved.
//

import UIKit
import JitsiMeet

class settingCameraViewController: UIViewController{
    @IBOutlet var blackView: UIView!
    @IBOutlet var cameraView: UIView!
    fileprivate var cameraId: String
    fileprivate var cameraName: String
    fileprivate var viewController: String
    init(vcString: String,cameraID: String,cameraName: String) {
        cameraId = cameraID
        self.cameraName = cameraName
        viewController = vcString
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        let backBtn = UIBarButtonItem (title: "Back", style: .plain, target: self, action:#selector(backBtnClick))
        self.navigationItem.leftBarButtonItem = backBtn
        
        blackView.isHidden = self.viewController.isEqual("observeCamera")
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
        jitsiView.join(options)
                
    }
    
    @objc func backBtnClick(){
        
        if(self.viewController == "setCamera"){
            let req = cameraDelete(id: cameraId)
            apiAgent.doCameraDelete(req: req)
        }
        let jitsiView = cameraView as! JitsiMeetView
        jitsiView.leave()
    }
    
}

extension settingCameraViewController : JitsiMeetViewDelegate{
    func conferenceJoined(_ data: [AnyHashable : Any]!) {
        
    }
    func conferenceTerminated(_ data: [AnyHashable : Any]!) {
        self.navigationController?.popViewController(animated: true)
    }
}
