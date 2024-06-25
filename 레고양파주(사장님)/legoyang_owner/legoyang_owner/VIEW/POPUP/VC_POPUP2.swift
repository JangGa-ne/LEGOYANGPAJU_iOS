//
//  VC_POPUP2.swift
//  legoyang_owner
//
//  Created by 장 제현 on 2022/12/11.
//

import UIKit

class CC_POPUP2: UICollectionViewCell {
    
    override var isSelected: Bool {
        didSet{
            if isSelected {
                layer.borderColor = UIColor.black.cgColor; layer.borderWidth = 2
            } else {
                layer.borderColor = UIColor.clear.cgColor; layer.borderWidth = 2
            }
        }
    }
}

class VC_POPUP2: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }
    
    var COLOR_DATA: String = ""
    
    @IBAction func BACK_B(_ sender: UIButton) { dismiss(animated: true, completion: nil) }
    
    @IBOutlet weak var NAVI_L: UILabel!
    @IBOutlet weak var COLLECTIONVIEW: UICollectionView!
    @IBOutlet weak var SUBMIT_B: UIButton!
    
    override func loadView() {
        super.loadView()
        
        let LAYOUT = UICollectionViewFlowLayout()
        LAYOUT.scrollDirection = .horizontal; LAYOUT.minimumLineSpacing = 10; LAYOUT.minimumInteritemSpacing = 0
        LAYOUT.sectionInset = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30)
        COLLECTIONVIEW.setCollectionViewLayout(LAYOUT, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        COLLECTIONVIEW.delegate = self; COLLECTIONVIEW.dataSource = self; COLLECTIONVIEW.allowsMultipleSelection = false
        
        SUBMIT_B.addTarget(self, action: #selector(SUBMIT_B(_:)), for: .touchUpInside)
    }
    
    @objc func SUBMIT_B(_ sender: UIButton) {
        
        if COLOR_DATA == "" {
            S_NOTICE("색상 미선택(!)")
        } else {
            if let BVC = UIViewController.VC3_STORE_EDIT_DEL {
                BVC.COLOR = COLOR_DATA
                BVC.QUOTE_LEFT_I.image = UIImage(named: QUOTE_REFT[COLOR_DATA] ?? "quote_left0")
                BVC.QUOTE_RIGHT_I.image = UIImage(named: QUOTE_RIGHT[COLOR_DATA] ?? "quote_right0")
            }; dismiss(animated: true, completion: nil)
        }
    }
}

extension VC_POPUP2: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if QUOTE_REFT.count > 0 { return QUOTE_REFT.count } else { return 0 }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let CELL = collectionView.dequeueReusableCell(withReuseIdentifier: "CC_POPUP2", for: indexPath) as! CC_POPUP2
        CELL.backgroundColor = UIColor(hex: Array(QUOTE_REFT.keys)[indexPath.item], alpha: 1.0)
        
        return CELL
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let CELL = collectionView.dequeueReusableCell(withReuseIdentifier: "CC_POPUP2", for: indexPath) as! CC_POPUP2
        CELL.isSelected = true; COLOR_DATA = Array(QUOTE_REFT.keys)[indexPath.item]
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.height, height: collectionView.frame.height)
    }
}
