//
//  AgreementViewController.swift
//  legoyang_client
//
//  Created by 장 제현 on 2023/05/07.
//

import UIKit

class AgreementListCell: UITableViewCell {
    
    @IBOutlet weak var agreeView: UIView!
    @IBOutlet weak var checkImageView: UIImageView!
    @IBOutlet weak var mainTitleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
}

class AgreementViewController: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) { return .darkContent } else { return .default }
    }
    
    @IBOutlet weak var headerView: UIView!
    @IBAction func backButton(_ sender: UIButton) { navigationController?.popViewController(animated: true) }

    @IBOutlet weak var listView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        listView.separatorStyle = .none
        listView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        listView.delegate = self; listView.dataSource = self
    }
}

extension AgreementViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "AgreementListCell_1", for: indexPath) as! AgreementListCell
        
        return cell
    }
}
