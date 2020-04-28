//
//  popupViewController.swift
//  videoTransmissionProject
//
//  Created by 吳尚霖 on 4/22/20.
//  Copyright © 2020 SamWu. All rights reserved.
//

import UIKit

class popupViewController: UIViewController {    
    var cameraList: Dictionary<String,Any>? = [:]
    fileprivate var camArray : Array<list> = []
    @IBOutlet var cameraTableView: UITableView!
    
    @IBAction func dissmissVC(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(cameraList!.count>0){
            camArray = cameraList!["list"] as! Array<list>
        }
        tableViewInit()
    }
    
    fileprivate func tableViewInit() {
        cameraTableView.delegate = self
        cameraTableView.dataSource = self
        cameraTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
}
extension popupViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return camArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = camArray[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.presentCameraList(id: camArray[indexPath.row].id! , name: camArray[indexPath.row].name! , vcString: "observeCamera" )
        dismiss(animated: true, completion: nil)
    }
    
    
}
