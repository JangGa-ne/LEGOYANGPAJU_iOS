//
//  EventViewController.swift
//  legoyang_client
//
//  Created by Busan Dynamic on 2023/06/05.
//

import UIKit
import FirebaseFirestore

class EventGridCell: UICollectionViewCell {
    
    @IBOutlet weak var eventView: UIView!
    @IBOutlet weak var mainTitleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var subContentLabel: UILabel!
}

class EventViewController: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) { return .darkContent } else { return .default }
    }
    
    var eventObject: [eventData] = []
    
    @IBAction func backButton(_ sender: UIButton) { navigationController?.popViewController(animated: true) }
    
    @IBOutlet weak var gridView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIViewController.EventViewControllerDelegate = self
        
        loadingData()
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical; layout.minimumLineSpacing = 20; layout.minimumInteritemSpacing = 20
        layout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        gridView.setCollectionViewLayout(layout, animated: false, completion: nil)
        gridView.delegate = self; gridView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setBackSwipeGesture(true)
        
        UIViewController.EventDetailViewControllerDelegate = nil
    }
}

extension EventViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if eventObject.count > 0 { return eventObject.count } else { return 0 }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let data = eventObject[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EventGridCell_1", for: indexPath) as! EventGridCell
        
        cell.mainTitleLabel.text = data.explain1
        cell.subTitleLabel.text = data.explain2
        cell.subContentLabel.text = data.displayPeriod
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let data = eventObject[indexPath.row]
        if data.eventId == "event_reward" {
            let segue = storyboard?.instantiateViewController(withIdentifier: "EventDetailViewController") as! EventDetailViewController
            segue.eventId = data.eventId
            navigationController?.pushViewController(segue, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width-40, height: 240)
    }
}

