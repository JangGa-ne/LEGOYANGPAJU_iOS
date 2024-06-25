//
//  MyEventViewController.swift
//  legoyang_client
//
//  Created by Busan Dynamic on 2023/06/15.
//

import UIKit

class MyEventListCell: UITableViewCell {
    
    @IBOutlet weak var nickLabel: UILabel!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var inviteeImageView_1: UIImageView!
    @IBOutlet weak var inviteeImageView_2: UIImageView!
    @IBOutlet weak var couponImageView: UIImageView!
}

class MyEventViewContoller: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) { return .darkContent } else { return .default }
    }
    
    var eventInviterObject: eventInviterData = eventInviterData()
    
    @IBAction func backButton(_ sender: UIButton) { navigationController?.popViewController(animated: true) }
    
    @IBOutlet weak var eventCountLabel: UILabel!
    @IBOutlet weak var inviteView: UIView!
    
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var listView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIViewController.MyEventViewControllerDelegate = self
        
        eventCountLabel.text = "\(eventInviterObject.inviteTo.count)"
        inviteView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(inviteView(_:))))
        
        refreshButton.addTarget(self, action: #selector(refreshButton(_:)), for: .touchUpInside)
        
        listView.separatorStyle = .none
        listView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        listView.delegate = self; listView.dataSource = self
    }
    
    @objc func inviteView(_ sender: UITapGestureRecognizer) {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func refreshButton(_ sender: UIButton) {
        if let delegate = UIViewController.EventDetailViewControllerDelegate {
            delegate.loadingData()
        }
    }
}

extension MyEventViewContoller: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if eventInviterObject.inviteTo.count > 0 { return eventInviterObject.inviteTo.count } else { return 0 }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let data = eventInviterObject.inviteTo[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyEventListCell_1", for: indexPath) as! MyEventListCell
        
        cell.nickLabel.text = data.inviteeNick
        
        switch data.writeCount {
        case 0:
            cell.stateLabel.text = "이벤트 참여중"
            cell.inviteeImageView_1.image = UIImage(named: "legopangpang3_off")
            cell.inviteeImageView_2.image = UIImage(named: "legopangpang3_off")
        case 1:
            cell.stateLabel.text = "이벤트 참여중"
            cell.inviteeImageView_1.image = UIImage(named: "legopangpang3")
            cell.inviteeImageView_2.image = UIImage(named: "legopangpang3_off")
        case 2:
            cell.stateLabel.text = "이벤트 참여완료"
            cell.inviteeImageView_1.image = UIImage(named: "legopangpang3")
            cell.inviteeImageView_2.image = UIImage(named: "legopangpang3")
        default:
            break
        }
        
        cell.couponImageView.image = UIImage(named: ["olive": "event_oliveyoung", "naver": "event_naver", "lotte": "event_lotte"][data.couponType] ?? "event_oliveyoung")
        
        return cell
    }
}
