//
//  ViewController.swift
//  videoTransmissionProject
//
//  Created by 吳尚霖 on 4/21/20.
//  Copyright © 2020 SamWu. All rights reserved.
//

import UIKit
import AVFoundation

let url = URL(string: "https://meet.jit.si")
let CAMERA_SET_API_NAME = "camera/set"
let CAMERA_LIST_API_NAME = "camera/list"
let CAMERA_DELETE_API_NAME = "camera/delete"

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(notificationReceiver), name: Notification.Name("APINotification"), object: nil)
    }
    
    @objc func notificationReceiver(notification:NSNotification){
        DispatchQueue.main.async {
            if let res = notification.object as? cameraResponse{
                self.handleCameraSet(res: res)
            }
            else if let res = notification.object as? cameraResponseArr{
                self.handleCameraList(res: res)
            }
        }
    }
    
    func handleCameraSet(res:cameraResponse){
           if(res.status == 0){
            let vc = settingCameraViewController.init(vcString: "setCamera", cameraID: (res.result?.id)!, cameraName: (res.result?.name)!)
            requestAccessFunc(vc)
           }
    }
                        
    func handleCameraList(res:cameraResponseArr){
        if(res.status == 0){
            if(res.result.count > 0){
                let vc = popupViewController()
                vc.cameraList = res.result
                self.navigationController?.pushViewController(vc, animated: true)
            }else{
                
            }
        }
    }
    
    @IBAction func setCameraBtnClick(_ sender: Any) {
        
        let alertController = UIAlertController(title: "攝影機名稱", message: "", preferredStyle: .alert)
        
        alertController.addTextField { (textField) in
            textField.placeholder = "請輸入攝影機名稱"
            textField.keyboardType = UIKeyboardType.phonePad
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
            self.dismiss(animated: true, completion: nil)
        })
        
        let confirmAction = UIAlertAction(title: "Confirm", style: .default, handler: { _ in
            let text = (alertController.textFields?.first?.text)!
            if(text.count>0){
                let req = cameraSet.init(name: text,reqName: CAMERA_SET_API_NAME)
                apiAgent.doCameraName(req: req)
            }else{
                alertController.message = "請先輸入名稱"
            }
        })
        alertController.addAction(cancelAction)
        alertController.addAction(confirmAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func observeCameraBtnClick(_ sender: Any) {
        let req = cameraList.init(reqName: CAMERA_LIST_API_NAME)
        apiAgent.doCameraList(req: req)
    }
    
}

extension UIViewController{
    func requestAccessFunc(_ vc:UIViewController?) {
        if AVCaptureDevice.authorizationStatus(for: .video) ==  .authorized {
            self.navigationController?.pushViewController(vc!, animated: true)
        } else {
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
                //request access again
                if granted {
                    DispatchQueue.main.async {
                        self.navigationController?.pushViewController(vc!, animated: true)
                    }
                }
                
                //request rejected
                else {
                    let alertController = UIAlertController(title: "開啟失敗", message: "請先開啟相機權限", preferredStyle: .alert)
                    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
                        self.dismiss(animated: true, completion: nil)
                    })
                    
                    // click setting
                    let okAction = UIAlertAction(title: "Setting", style: .default, handler: { _ in
                        let url = URL(string: UIApplication.openSettingsURLString)
                        if let url = url, UIApplication.shared.canOpenURL(url) {
                            if #available(iOS 10, *) {
                                UIApplication.shared.open(url, options: [:],completionHandler: {(success) in })
                            } else {
                                UIApplication.shared.openURL(url)
                            }
                        }
                    })
                    alertController.addAction(cancelAction)
                    alertController.addAction(okAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            })
        }
    }
}

