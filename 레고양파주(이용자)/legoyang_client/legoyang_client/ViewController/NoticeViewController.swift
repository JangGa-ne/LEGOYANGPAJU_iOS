//
//  NoticeViewController.swift
//  legoyang_client
//
//  Created by Busan Dynamic on 2023/04/26.
//

import UIKit
import FirebaseFirestore

class NoticeListCell: UITableViewCell {
    
    @IBOutlet weak var typeImageView: UIImageView!
    @IBOutlet weak var mainTltleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var dotView: UIView!
}

class NoticeViewController: UIViewController {

    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) { return .darkContent } else { return .default }
    }
    
    @IBAction func backButton(_ sender: UIButton) { navigationController?.popViewController(animated: true) }
    
    @IBOutlet weak var listView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIViewController.NoticeViewControllerDelegate = self
        
        listView.separatorStyle = .none
        listView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        listView.delegate = self; listView.dataSource = self
    }
}

extension NoticeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if UIViewController.appDelegate.NoticeListObject.count > 0 { return UIViewController.appDelegate.NoticeListObject.count } else { return 0 }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let data = UIViewController.appDelegate.NoticeListObject[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoticeListCell_1", for: indexPath) as! NoticeListCell
        
        if data.type == "review" {
            cell.typeImageView.image = UIImage(named: "legopangpang2")
        } else if data.type == "legonggu" {
            cell.typeImageView.image = UIImage(named: "legonggu2")
        } else {
            cell.typeImageView.image = UIImage(named: "logo2")
        }
        
        cell.mainTltleLabel.text = data.title
        cell.subTitleLabel.text = data.body
        
        if data.readOrNot != "true" { cell.dotView.isHidden = false } else { cell.dotView.isHidden = true }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let data = UIViewController.appDelegate.NoticeListObject[indexPath.row]
        
        let DispatchGroup = DispatchGroup()
        
        DispatchGroup.enter()
        DispatchQueue.global().async {
            
            if data.readOrNot != "true" {
                
                let params: [String: Any] = [
                    "noti_list": [
                        data.receiveTime: [
                            "body": data.body,
                            "data": data.data,
                            "readornot": "true",
                            "receive_time": data.receiveTime,
                            "title": data.title,
                            "type": data.type
                        ]
                    ]
                ]
                
                Firestore.firestore().collection("member").document(UIViewController.appDelegate.MemberId).setData(params, merge: true) { _ in
                    DispatchGroup.leave()
                }
            } else {
                DispatchGroup.leave()
            }
        }
        
        DispatchGroup.notify(queue: .main) {
            
            if data.type == "review" {
                
                if let delegate = UIViewController.TabBarControllerDelegate {
                    let segue = delegate.storyboard?.instantiateViewController(withIdentifier: "CouponViewController") as! CouponViewController
                    segue.position = 1
                    delegate.navigationController?.pushViewController(segue, animated: true)
                }
                
            } else if data.type == "legonggu" {
                
                let segue = self.storyboard?.instantiateViewController(withIdentifier: "VC_DETAIL2") as! VC_DETAIL2
                segue.position = indexPath.item
                self.navigationController?.pushViewController(segue, animated: true)
            }
        }
    }
}
