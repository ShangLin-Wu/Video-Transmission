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

weak var delegate:ViewControllerDelegate?

class ViewController: UIViewController {
    var cameraName:String!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(notificationReceiver), name: Notification.Name("APINotification"), object: nil)
        
        delegate = self
}
    // MARK: - Notification Receiver
    @objc func notificationReceiver(notification:NSNotification){
        DispatchQueue.main.async {
            let dic = notification.object as! Dictionary<String, Any>
            
            if let res = dic[CAMERA_SET_API_NAME] as? cameraResponse{
                self.handleCameraSet(res: res)
            }
            else if let res = dic[CAMERA_LIST_API_NAME] as? cameraResponseArr{
                self.handleCameraList(res: res)
            }
            else if let res = dic[CAMERA_DELETE_API_NAME] as? cameraResponse{
                self.handleCameraDelete(res: res)
            }
        }
    }
    
    // MARK: -  Notification Handler
    func handleCameraSet(res:cameraResponse){
           if(res.status == 0){
            let vc = settingCameraViewController.init(vcString: "setCamera", cameraID: (res.result?.id)!, cameraName: cameraName!)
            requestAccessFunc(vc)
           }
    }
                        
    func handleCameraList(res:cameraResponseArr){
        if(res.status == 0){
            if(res.result.count > 0){
                let vc = popupViewController()
                vc.cameraList = res.result
                self.present(vc, animated: true, completion: nil)
            }
        }
    }
    
    func handleCameraDelete(res:cameraResponse){
        
    }
    
    // MARK: - IBAction
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
                self.cameraName = text
                let req = cameraSet.init(name: text,reqName: CAMERA_SET_API_NAME)
                apiAgent.doCameraName(req: req)
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

// MARK: - requestAccessFunc
extension ViewController: ViewControllerDelegate{
    func presentCameraList(id: String, name: String, vcString: String) {
        let vc = settingCameraViewController.init(vcString:vcString,cameraID: id,cameraName:name)
        self.requestAccessFunc(vc)
    }
}

// MARK: - check camera access and pushViewController
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

extension UIView{
    func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.duration = 0.6
        animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0 ]
        layer.add(animation, forKey: "shake")
    }
}
