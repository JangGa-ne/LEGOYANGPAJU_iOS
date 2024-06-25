//
//  EventDetailViewController.swift
//  legoyang_client
//
//  Created by Busan Dynamic on 2023/06/05.
//

import UIKit
import FirebaseFirestore

class EventDetailGridCell: UICollectionViewCell {
    
    @IBOutlet weak var couponImageView: UIImageView!
}

class EventDetailViewController: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) { return .darkContent } else { return .default }
    }
    
    var root: Bool = false
    var position: Int = 0
    var first: Bool = true
    
    var eventId: String = ""
    var eventInviterObject: eventInviterData = eventInviterData()
    var couponType: String = "olive"
    let couponImage: [String: Any] = ["olive": "event_oliveyoung", "naver": "event_naver", "lotte": "event_lotte"]
    let couponName: [String: Any] = ["olive": "올리브영 5,000원", "naver": "네이버페이 5,000원", "lotte": "롯데상품권 5,000원"]
    
    @IBAction func backButton(_ sender: UIButton) { navigationController?.popViewController(animated: true) }
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var inviterView: UIView!
    @IBOutlet weak var highlightView_1: UIView!
    @IBOutlet weak var inviteeView: UIView!
    @IBOutlet weak var highlightView_2: UIView!
    
    @IBOutlet weak var inviterStackView: UIStackView!
    @IBOutlet weak var inviterScrollView: UIScrollView!
    
    @IBOutlet weak var inviterMainTitleLabel: UILabel!
    @IBOutlet weak var inviterSubTitleLabel: UILabel!
    @IBOutlet weak var inviterSubContentLabel: UILabel!
    
    @IBOutlet weak var gridView: UICollectionView!
    @IBOutlet weak var inviterPresentImageView: UIImageView!
    @IBOutlet weak var inviterButton: UIButton!
    
    @IBOutlet weak var inviterFooterView: UIView!
    @IBOutlet weak var inviterFooterButton: UIButton!
    
    @IBOutlet weak var inviteeStackView: UIStackView!
    @IBOutlet weak var inviteeScrollView: UIScrollView!
    
    @IBOutlet weak var inviteeMainTitleLabel: UILabel!
    @IBOutlet weak var inviteeSubTitleLabel: UILabel!
    @IBOutlet weak var inviteeSubContentLabel: UILabel!
    
    @IBOutlet weak var InviteeBackgroundView: UIMainView!
    @IBOutlet weak var InviteePresentImageView: UIImageView!
    @IBOutlet weak var inviteePresentLabel: UILabel!
    @IBOutlet weak var inviteeButton: UIButton!
    
    @IBOutlet weak var inviteeFooterView: UIMainView!
    @IBOutlet weak var inviteeImageView_1: UIImageView!
    @IBOutlet weak var inviteeImageView_2: UIImageView!
    @IBOutlet weak var inviteeFooterButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIViewController.EventDetailViewControllerDelegate = self
        
        setEventCode()
        
        inviterView.tag = 0; inviterView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(positionGesture(_:))))
        inviteeView.tag = 1; inviteeView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(positionGesture(_:))))
        
        if position == 0 {
            highlightView_1.isHidden = false
            highlightView_2.isHidden = true
            inviterStackView.isHidden = false
            inviteeStackView.isHidden = true
        } else if !root && (eventInviterObject.inviterCode == "") {
            setAlert(title: "", body: "이벤트 참여는 카카오톡으로 받은 초대장을 통해 참여하실 수 있습니다.", style: .alert, time: 2); position = 0
        } else if position == 1 {
            highlightView_1.isHidden = true
            highlightView_2.isHidden = false
            inviterStackView.isHidden = true
            inviteeStackView.isHidden = false
            InviteePresentImageView.image = UIImage(named: couponImage[UIViewController.appDelegate.shareData["coupon_type"] as? String ?? ""] as? String ?? "event_oliveyoung")
            inviteePresentLabel.text = couponName[UIViewController.appDelegate.shareData["coupon_type"] as? String ?? ""] as? String ?? "올리브영 5,000원"
        }
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal; layout.minimumLineSpacing = 20; layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: UIScreen.main.bounds.width/2-120, bottom: 0, right: UIScreen.main.bounds.width/2-120)
        gridView.setCollectionViewLayout(layout, animated: false, completion: nil)
        gridView.delegate = self; gridView.dataSource = self
        
        inviterButton.roundCorners(corners: [.layerMinXMaxYCorner, .layerMaxXMaxYCorner], radius: 10)
        inviterButton.tag = 0; inviterButton.addTarget(self, action: #selector(inviteButton(_:)), for: .touchUpInside)
        
        inviterFooterButton.tag = 0; inviterFooterButton.addTarget(self, action: #selector(footerButton(_:)), for: .touchUpInside)
        
        inviteeButton.roundCorners(corners: [.layerMinXMaxYCorner, .layerMaxXMaxYCorner], radius: 10)
        inviteeButton.tag = 1; inviteeButton.addTarget(self, action: #selector(inviteButton(_:)), for: .touchUpInside)
        
        inviteeFooterView.isHidden = true
        inviteeFooterButton.tag = 1; inviteeFooterButton.addTarget(self, action: #selector(footerButton(_:)), for: .touchUpInside)
        
        loadingData()
    }
    
    func setEventCode() {
        
        if UIViewController.appDelegate.MemberObject.code == "" {
            
            var code: String = ""
            let letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"
            
            for _ in 0 ..< 5 {
                let index = Int.random(in: 0 ..< letters.count)
                let letter = letters[letters.index(letters.startIndex, offsetBy: index)]
                code.append(letter)
            }
            
            let DispatchGroup = DispatchGroup()
            
            DispatchGroup.enter()
            DispatchQueue.global().async {
                
                Firestore.firestore().collection("member").whereField("code", isEqualTo: code).getDocuments { responses, error in
                    if responses?.count ?? 0 == 0 { DispatchGroup.leave() } else { self.loadingData() }
                }
            }
            
            DispatchGroup.notify(queue: .main) {
                
                Firestore.firestore().collection("member").document(UIViewController.appDelegate.MemberId).setData(["code": code], merge: true) { error in
                    if error == nil { UIViewController.appDelegate.MemberObject.code = code }
                }
            }
        }
    }
    
    @objc func positionGesture(_ sender: UITapGestureRecognizer) {
        
        guard let sender = sender.view else { return }
        
        position = sender.tag
        
        if sender.tag == 0 {
            
            highlightView_1.isHidden = false
            highlightView_2.isHidden = true
            inviterStackView.isHidden = false
            inviteeStackView.isHidden = true
            
        } else if !root && (eventInviterObject.inviterCode == "") {
            setAlert(title: "", body: "이벤트 참여는 카카오톡으로 받은 초대장을 통해 참여하실 수 있습니다.", style: .alert, time: 2); position = 0
        } else if sender.tag == 1 {
            
            highlightView_1.isHidden = true
            highlightView_2.isHidden = false
            inviterStackView.isHidden = true
            inviteeStackView.isHidden = false
            
            loadingData2()
        }
    }
    
    func loadingData2() {
        
        if eventInviterObject.inviterCode == "" { return }
// 이벤트 참여중일때
        InviteePresentImageView.image = UIImage(named: couponImage[eventInviterObject.couponType] as? String ?? "event_oliveyoung")
        inviteePresentLabel.text = couponName[eventInviterObject.couponType] as? String ?? "올리브영 5,000원"
        
        if first { first = false
            
            let blockLabel = UILabel()
            blockLabel.frame = InviteeBackgroundView.bounds
            blockLabel.backgroundColor = .black.withAlphaComponent(0.3)
            blockLabel.layer.cornerRadius = 10
            blockLabel.clipsToBounds = true
            blockLabel.textColor = .white
            blockLabel.textAlignment = .center
            blockLabel.font = .boldSystemFont(ofSize: 24)
            blockLabel.text = "현재 이벤트 참여중 입니다!"
            blockLabel.alpha = 1.0
            InviteeBackgroundView.addSubview(blockLabel)
        }
        
        inviteeFooterView.isHidden = false
        
        switch eventInviterObject.writeCount {
        case 0:
            inviteeImageView_1.image = UIImage(named: "legopangpang2_off")
            inviteeImageView_2.image = UIImage(named: "legopangpang2_off")
        case 1:
            inviteeImageView_1.image = UIImage(named: "legopangpang2")
            inviteeImageView_2.image = UIImage(named: "legopangpang2_off")
        case 2:
            inviteeImageView_1.image = UIImage(named: "legopangpang2")
            inviteeImageView_2.image = UIImage(named: "legopangpang2")
            inviteeFooterButton.backgroundColor = .systemRed
            inviteeFooterButton.setTitle("이벤트 참여완료!", for: .normal)
        default:
            break
        }
    }
    
    @objc func inviteButton(_ sender: UIButton) {
        
        if sender.tag == 0 {
            
            let imageUrl = "https://firebasestorage.googleapis.com/v0/b/legoyangpaju.appspot.com/o/event%2FKakaoTalk_Photo_2023-06-19-18-24-44%20002.png?alt=media&token=fa606bf9-c0d7-4c0e-b8a0-ef7960580507"
            let params = "recommender=\(UIViewController.appDelegate.MemberId)&code=abcde123&type=event&event_id=event_reward&inviter_from=\(UIViewController.appDelegate.MemberId)&inviter_code=\(UIViewController.appDelegate.MemberObject.code)&coupon_type=\(couponType)"
// 카카오톡으로 초대장 보내기
            setShare(title: "레고양파주에서 10,000원 나눠받는 선물 이벤트", description: "리워드 이벤트에 초대 받았습니다!", imageUrl: imageUrl, params: params)
            
        } else if sender.tag == 1 {
            if UIViewController.appDelegate.MemberId == "" {
                S_NOTICE("로그인 (!)"); segueViewController(identifier: "LoginAAViewController")
            } else if root && (eventInviterObject.inviterCode == "") {
                setEventInvite()
            }
        }
    }
    
    func setEventInvite() {
        
        var invitee: Bool = false
        let shareDict = UIViewController.appDelegate.shareData
        let timestamp = "\(self.setKoreaTimestamp())"
        
        Firestore.firestore().collection("event").document("event_reward").getDocument { response, error in
            
            guard let response = response, response.exists else { return }
            
            let dict = response.data() ?? [:]
            
            let proceeding = dict["proceeding"] as? String ?? ""
            let maximumPeopleCount = dict["maximum_people_count"] as? Int ?? 0
            let participantsCount = dict["participants_count"] as? Int ?? 0
            
            if proceeding != "true" {
                self.setAlert(title: "", body: "현재 이벤트 진행중이 아닙니다.", style: .alert, time: 2)
            } else if maximumPeopleCount <= participantsCount {
                self.setAlert(title: "", body: "이벤트 제한 인원이 초과되었습니다.", style: .alert, time: 2)
            } else {
                
                let DispatchGroup = DispatchGroup()
                
                DispatchGroup.enter()
                DispatchQueue.global().async {
// 카카오톡으로 진입 후 초대자 번호로 내가 이미 참여하고 있는지 검색 및 확인
                    Firestore.firestore().collection(self.eventId).document(shareDict["inviter_from"] as? String ?? "").getDocument { response, error in
                        
                        guard let response = response, response.exists else { return }
                        
                        for data in response.data()?["invite_to"] as? Array<Any> ?? [] {
                            
                            let dict = data as? [String: Any] ?? [:]
                            if dict["invitee_id"] as? String ?? "" == UIViewController.appDelegate.MemberId { invitee = true; break }
                        }
                        
                        DispatchGroup.leave()
                    }
                }
                
                if invitee { return }
                
                DispatchGroup.enter()
                DispatchQueue.global().async {
                    
                    var nick: String = ""
                    
                    if UIViewController.appDelegate.MemberObject.nick == "" {
                        nick = UIViewController.appDelegate.MemberObject.name
                    } else {
                        nick = UIViewController.appDelegate.MemberObject.nick
                    }
                    
                    let inviteTo: [[String: Any]] = [[
                        "coupon_type": shareDict["coupon_type"] as? String ?? "",
                        "finish_time": "",
                        "invitee_id": UIViewController.appDelegate.MemberId,
                        "invitee_nick": nick,
                        "progress_step": "0",
                        "start_time": timestamp,
                        "write_count": 0
                    ]]
// 초대자에 참여자가 있는경우 update
                    let post = Firestore.firestore().collection(self.eventId).document(shareDict["inviter_from"] as? String ?? "")
                    post.updateData(["invite_to": FieldValue.arrayUnion(inviteTo)]) { error in
                        if error != nil {
// 없는 경우 set
                            post.setData(["invite_to": inviteTo], merge: true) { _ in DispatchGroup.leave() }
                        } else {
                            DispatchGroup.leave()
                        }
                    }
                }
                
                DispatchGroup.enter()
                DispatchQueue.global().async {
                    
                    let params: [String: Any] = [
                        "coupon_type": shareDict["coupon_type"] as? String ?? "",
                        "finish_time": "",
                        "inviter_code": shareDict["inviter_code"] as? String ?? "",
                        "inviter_from": shareDict["inviter_from"] as? String ?? "",
                        "progress_step": "0",
                        "review_url": [],
                        "start_time": timestamp,
                        "write_count": 0
                    ]
// 참여자 set
                    Firestore.firestore().collection(self.eventId).document(UIViewController.appDelegate.MemberId).setData(params, merge: true) { _ in
                        DispatchGroup.leave()
                    }
                }
                
                DispatchGroup.enter()
                DispatchQueue.global().async {
// 카운트 update
                    Firestore.firestore().collection("event").document(self.eventId).updateData(["participants_count": participantsCount+1]) { _ in
                        self.loadingData()
                    }
                }
            }
        }
    }
    
    @objc func footerButton(_ sender: UIButton) {
        
        if sender.tag == 0 {
            
            let segue = storyboard?.instantiateViewController(withIdentifier: "MyEventViewContoller") as! MyEventViewContoller
            segue.eventInviterObject = eventInviterObject
            navigationController?.pushViewController(segue, animated: true)
            
        } else if (sender.tag == 1) && (eventInviterObject.writeCount != 2) {
            
            navigationController?.popViewController(animated: true) {
                if let delegate = UIViewController.TabBarControllerDelegate {
                    delegate.selectedIndex = 1
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setBackSwipeGesture(true)
        
        UIViewController.MyEventViewControllerDelegate = nil
    }
}

extension EventDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EventDetailGridCell_1", for: indexPath) as! EventDetailGridCell
        
        cell.couponImageView.image = UIImage(named: ["event_oliveyoung", "event_naver", "event_lotte"][indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 240, height: 150)
    }
}

extension EventDetailViewController: UIScrollViewDelegate {
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        if scrollView == gridView {
            
            let pageWidth = 240+20
            let currentOffset = scrollView.contentOffset.x
            let targetOffset = targetContentOffset.pointee.x
            var newTargetOffset: CGFloat = 0
            
            if targetOffset > currentOffset {
                newTargetOffset = ceil(currentOffset / CGFloat(pageWidth)) * CGFloat(pageWidth)
            } else {
                newTargetOffset = floor(currentOffset / CGFloat(pageWidth)) * CGFloat(pageWidth)
            }
            
            if newTargetOffset < 0 {
                newTargetOffset = 0
            } else if newTargetOffset > scrollView.contentSize.width {
                newTargetOffset = scrollView.contentSize.width
            }
            
            targetContentOffset.pointee.x = currentOffset
            scrollView.setContentOffset(CGPoint(x: newTargetOffset, y: 0), animated: true)
            
        } else {
            targetContentOffset.pointee = targetContentOffset.pointee
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView == gridView {
            
            let pageWidth = CGFloat(240+20)
            let currentPage = Int((gridView.contentOffset.x+pageWidth/2)/pageWidth)
            
            if currentPage < 3 { couponType = ["olive", "naver", "lotte"][currentPage] }
            inviterPresentImageView.image = UIImage(named: couponImage[couponType] as? String ?? "event_olivyoung")
        }
    }
}
