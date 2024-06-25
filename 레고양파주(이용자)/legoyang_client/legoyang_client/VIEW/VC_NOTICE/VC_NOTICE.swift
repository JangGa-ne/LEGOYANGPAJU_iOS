//
//  VC_NOTICE.swift
//  legoyang_client
//
//  Created by 장 제현 on 2023/01/26.
//

import UIKit

class TC_NOTICE: UITableViewCell {
    
    @IBOutlet weak var READ_V: UIView!
    @IBOutlet weak var SUBJECT_L: UILabel!
    @IBOutlet weak var CONTENTS_L: UILabel!
}

class VC_NOTICE: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) { return .darkContent } else { return .default }
    }
    
    @IBAction func BACK_B(_ sender: UIButton) { navigationController?.popViewController(animated: true) }
    
    @IBOutlet weak var TABLEVIEW: UITableView!
    
    override func loadView() {
        super.loadView()
        
        UIViewController.VC_NOTICE_DEL = self
        
        TABLEVIEW.separatorStyle = .none
        TABLEVIEW.contentInset = UIEdgeInsets(top: 50, left: 0, bottom: 20, right: 0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TABLEVIEW.delegate = self; TABLEVIEW.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setBackSwipeGesture(true)
    }
}

extension VC_NOTICE: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if UIViewController.appDelegate.MemberObject.noticeList.count > 0 { return UIViewController.appDelegate.MemberObject.noticeList.count } else { return 0 }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let data = UIViewController.appDelegate.MemberObject.noticeList[indexPath.item]
        let CELL = tableView.dequeueReusableCell(withIdentifier: "TC_NOTICE_1", for: indexPath) as! TC_NOTICE
        
        if data.readOrNot == "true" { CELL.READ_V.isHidden = true } else { CELL.READ_V.isHidden = false }
        CELL.SUBJECT_L.text = data.title
        CELL.CONTENTS_L.text = data.body
        
        return CELL
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let data = UIViewController.appDelegate.MemberObject.noticeList[indexPath.item]
        
        SET_NOTICE(NAME: "읽음처리", AC_TYPE: "member", TIMESTAMP: data.receiveTime)
        
        if data.type == "legonggu" {
            
//            let VC = storyboard?.instantiateViewController(withIdentifier: "VC_DETAIL2") as! VC_DETAIL2
//            VC.OBJ_NOTICE = UIViewController.appDelegate.MemberObject.NOTI_LIST; VC.OBJ_POSITION = indexPath.item
//            navigationController?.pushViewController(VC, animated: true)
            
            let segue = storyboard?.instantiateViewController(withIdentifier: "VC_DETAIL2") as! VC_DETAIL2
            segue.position = indexPath.item
            navigationController?.pushViewController(segue, animated: true)
        } else if data.type == "legopangpang" {
            
            
        }
    }
}
