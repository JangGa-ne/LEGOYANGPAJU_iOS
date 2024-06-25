//
//  MediaPlayerViewController.swift
//  legoyang_client
//
//  Created by Busan Dynamic on 2023/05/17.
//

import UIKit
import AVKit

class MediaPlayerViewController: AVPlayerViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showsPlaybackControls = true
        
//        delegate = self
        
        if AVPictureInPictureController.isPictureInPictureSupported() {
            allowsPictureInPicturePlayback = true
        }
        
        player?.play()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        guard let delegate = UIViewController.MainViewControllerDelegate else { return }
        
        delegate.MediaPlayMode = false
    }
}

extension UIViewController {
    
    func setPlayer(linkUrl: String = "") {
        
        guard let delegate = UIViewController.MainViewControllerDelegate else { return }

        delegate.MediaPlayMode = true

        let player = AVPlayer(url: URL(string: linkUrl)!)

        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        playerViewController.delegate = self

        if AVPictureInPictureController.isPictureInPictureSupported() {
            playerViewController.allowsPictureInPicturePlayback = true
        }

        present(playerViewController, animated: true) { player.play() }
    }
}

extension UIViewController: AVPlayerViewControllerDelegate {
    
    public func playerViewControllerShouldAutomaticallyDismissAtPictureInPictureStart(_ playerViewController: AVPlayerViewController) -> Bool {
        return true
    }
    
    public func playerViewController(_ playerViewController: AVPlayerViewController, restoreUserInterfaceForPictureInPictureStopWithCompletionHandler completionHandler: @escaping (Bool) -> Void) {
        
        if let delegate = UIViewController.MainViewControllerDelegate { delegate.MediaPlayMode = false }
        
        let currentViewController = navigationController?.visibleViewController
        if currentViewController != playerViewController {
            currentViewController?.present(playerViewController, animated: true, completion: nil)
        }
    }
}

extension UIViewController {
    
    private static var playerBackgroundView = UIMainView()
    private static var playerBackgroundViewFrame: CGRect = .zero
    private static var playerPanGesture = UIPanGestureRecognizer()
    private static var playerView = UIView()
    private static var playerDismissButton = UIButton()
    private static var playerReizeButton = UIButton()
    private static var playerLayer = AVPlayerLayer()
    
    private static var playing: Bool = false
    private static var player = AVPlayer()
    private static var fullScreen: Bool = false
    
    private static var playBackView = UIView()
    private static var back10Button = UIButton()
    private static var playPauseButton = UIButton()
    private static var go10Button = UIButton()
    
    func setPipMediaPlayer(title: String = "", linkUrl: String = "", width: CGFloat = 0.0, height: CGFloat = 0.0, animated: Bool = true) {
        
        guard let delegate = UIViewController.MainViewControllerDelegate else { return }
        
        UIViewController.playerBackgroundView.frame = CGRect(x: 20, y: UIApplication.shared.statusBarFrame.height+20, width: width, height: height)
        UIViewController.playerBackgroundViewFrame = CGRect(x: 20, y: UIApplication.shared.statusBarFrame.height+20, width: width, height: height)
        UIViewController.playerBackgroundView.backgroundColor = .black
        UIViewController.playerBackgroundView.layer.cornerRadius = 10
        UIViewController.playerPanGesture = UIPanGestureRecognizer(target: self, action: #selector(viewPanGesture(_:)))
        UIViewController.playerBackgroundView.addGestureRecognizer(UIViewController.playerPanGesture)
        UIViewController.playerBackgroundView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewTapGesture(_:))))
//        if let subView = UIViewController.appDelegate.window?.subviews.first(where: { $0 is UIMainView }) {
//            subView.removeFromSuperview()
//        }
        for view in UIViewController.appDelegate.window?.subviews ?? [] {
            if view is UIMainView { view.removeFromSuperview() }
        }
        if animated { UIViewController.appDelegate.window?.addSubview(UIViewController.playerBackgroundView) }
        
        UIViewController.playerView.frame = UIViewController.playerBackgroundView.bounds
        UIViewController.playerView.backgroundColor = .clear
        UIViewController.playerView.layer.cornerRadius = 10
        UIViewController.playerView.clipsToBounds = true
        UIViewController.playerBackgroundView.addSubview(UIViewController.playerView)
        
        UIViewController.player = AVPlayer(url: URL(string: linkUrl)!)
        UIViewController.player.rate = 1
        
        UIViewController.playerLayer.frame = UIViewController.playerBackgroundView.bounds
        UIViewController.playerLayer.player = UIViewController.player
        UIViewController.playerView.layer.addSublayer(UIViewController.playerLayer)
        
        UIViewController.playing = true
        UIViewController.player.play()
        
        UIViewController.playerDismissButton.frame = CGRect(x: UIViewController.playerBackgroundView.bounds.maxX-40, y: 10, width: 25, height: 25)
        UIViewController.playerDismissButton.setImage(UIImage(named: "exit"), for: .normal)
        UIViewController.playerDismissButton.addTarget(self, action: #selector(dismissButton(_:)), for: .touchUpInside)
        UIViewController.playerBackgroundView.addSubview(UIViewController.playerDismissButton)
        
        UIViewController.playBackView.frame = UIViewController.playerBackgroundView.bounds
        UIViewController.playBackView.backgroundColor = .black.withAlphaComponent(0.3)
        UIViewController.playBackView.alpha = 1.0
        UIViewController.playerView.addSubview(UIViewController.playBackView)
        
        UIViewController.playerReizeButton.frame = CGRect(x: 10, y: 10, width: 25, height: 25)
        UIViewController.playerReizeButton.setImage(UIImage(named: "pictureinpicture"), for: .normal)
        UIViewController.playerReizeButton.alpha = 1.0
        UIViewController.playerReizeButton.addTarget(self, action: #selector(playerReizeButton(_:)), for: .touchUpInside)
        UIViewController.playerView.addSubview(UIViewController.playerReizeButton)
        
        UIViewController.back10Button.frame = CGRect(x: UIViewController.playerView.frame.midX-65, y: UIViewController.playerView.frame.midY-15, width: 30, height: 30)
        UIViewController.back10Button.setImage(UIImage(named: "playerBack10"), for: .normal)
        UIViewController.back10Button.alpha = 1.0
        UIViewController.back10Button.tag = 0
        UIViewController.back10Button.addTarget(self, action: #selector(playBackButton(_:)), for: .touchUpInside)
        UIViewController.playBackView.addSubview(UIViewController.back10Button)
        
        UIViewController.playPauseButton.frame = CGRect(x: UIViewController.playerView.frame.midX-15, y: UIViewController.playerView.frame.midY-15, width: 30, height: 30)
        UIViewController.playPauseButton.setImage(UIImage(named: "playerPause"), for: .normal)
        UIViewController.playPauseButton.alpha = 1.0
        UIViewController.playPauseButton.tag = 1
        UIViewController.playPauseButton.addTarget(self, action: #selector(playBackButton(_:)), for: .touchUpInside)
        UIViewController.playBackView.addSubview(UIViewController.playPauseButton)
        
        UIViewController.go10Button.frame = CGRect(x: UIViewController.playerView.frame.midX+35, y: UIViewController.playerView.frame.midY-15, width: 30, height: 30)
        UIViewController.go10Button.setImage(UIImage(named: "playerGo10"), for: .normal)
        UIViewController.go10Button.alpha = 1.0
        UIViewController.go10Button.tag = 2
        UIViewController.go10Button.addTarget(self, action: #selector(playBackButton(_:)), for: .touchUpInside)
        UIViewController.playBackView.addSubview(UIViewController.go10Button)
        
        DispatchQueue.main.asyncAfter(deadline: .now()+3) {
            UIView.animate(withDuration: 1) {
                UIViewController.playBackView.alpha = 0.0
                UIViewController.playerReizeButton.alpha = 0.0
            }
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: .AVPlayerItemDidPlayToEndTime, object: UIViewController.player.currentItem)
        
        delegate.MediaPlayMode = true
    }
    
    @objc func viewPanGesture(_ sender: UIPanGestureRecognizer) {
        
        guard let view = sender.view, !UIViewController.fullScreen else { return }
        
        let transition = sender.translation(in: view)
        let changedX = view.center.x + transition.x
        let changedY = view.center.y + transition.y
        view.center = CGPoint(x: changedX, y: changedY)
        
        sender.setTranslation(.zero, in: view)
    }
    
    @objc func viewTapGesture(_ sender: UITapGestureRecognizer) {
        
        if UIViewController.playBackView.alpha == 0.0 {
            
            var timer = Timer()
            timer.invalidate()
            timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(noTouch), userInfo: nil, repeats: false)
            
            UIView.animate(withDuration: 0.5) {
                UIViewController.playBackView.alpha = 1.0
                UIViewController.playerReizeButton.alpha = 1.0
            }
            
        } else {
            UIView.animate(withDuration: 0.5) {
                UIViewController.playBackView.alpha = 0.0
                UIViewController.playerReizeButton.alpha = 0.0
            }
        }
    }
    
    @objc func noTouch() {
        UIView.animate(withDuration: 0.5) {
            UIViewController.playBackView.alpha = 0.0
            UIViewController.playerReizeButton.alpha = 0.0
        }
    }
    
    @objc func dismissButton(_ sender: UIButton) {
        
        UIViewController.player.pause()
        
        if let delegate = UIViewController.MainViewControllerDelegate { delegate.MediaPlayMode = false }
        if let subView = UIViewController.appDelegate.window?.subviews.first(where: { $0 is UIMainView }) {
            subView.removeFromSuperview()
        }
    }

    @objc func playBackButton(_ sender: UIButton) {
        
        let currentTime = UIViewController.player.currentTime()
            
        if sender.tag == 0 {
            UIViewController.player.seek(to: CMTimeSubtract(currentTime, CMTime(seconds: 10, preferredTimescale: currentTime.timescale)))
        } else if sender.tag == 1 {
            if UIViewController.playing {
                UIViewController.playing = false
                UIViewController.playPauseButton.setImage(UIImage(named: "playerPlay"), for: .normal)
                UIViewController.player.pause()
            } else {
                UIViewController.playing = true
                UIViewController.playPauseButton.setImage(UIImage(named: "playerPause"), for: .normal)
                UIViewController.player.play()
            }
        } else if sender.tag == 2 {
            UIViewController.player.seek(to: CMTimeAdd(currentTime, CMTime(seconds: 10, preferredTimescale: currentTime.timescale)))
        }
    }
    
    @objc func playerDidFinishPlaying() {
        UIViewController.playing = true
        UIViewController.playPauseButton.setImage(UIImage(named: "playerPause"), for: .normal)
        UIViewController.player.seek(to: .zero)
        UIViewController.player.play()
    }
    
    @objc func playerReizeButton(_ sender: UIButton) {
        
        if !UIViewController.fullScreen {
            UIViewController.fullScreen = true
            UIViewController.playerPanGesture.isEnabled = false
            UIViewController.playerBackgroundView.frame = UIScreen.main.bounds
            UIViewController.playerReizeButton.frame = CGRect(x: 10, y: UIApplication.shared.statusBarFrame.height+10, width: 25, height: 25)
            UIViewController.playerDismissButton.frame = CGRect(x: UIViewController.playerBackgroundView.bounds.maxX-40, y: UIApplication.shared.statusBarFrame.height+10, width: 25, height: 25)
        } else {
            UIViewController.fullScreen = false
            UIViewController.playerPanGesture.isEnabled = true
            UIViewController.playerBackgroundView.frame = UIViewController.playerBackgroundViewFrame
            UIViewController.playerReizeButton.frame = CGRect(x: 10, y: 10, width: 25, height: 25)
            UIViewController.playerDismissButton.frame = CGRect(x: UIViewController.playerBackgroundView.bounds.maxX-40, y: 10, width: 25, height: 25)
        }
        
        UIViewController.playerView.frame = UIViewController.playerBackgroundView.bounds
        UIViewController.playerLayer.frame = UIViewController.playerBackgroundView.bounds
        UIViewController.playBackView.frame = UIViewController.playerBackgroundView.bounds
        
        UIViewController.back10Button.frame = CGRect(x: UIViewController.playerView.frame.midX-65, y: UIViewController.playerView.frame.midY-15, width: 30, height: 30)
        UIViewController.playPauseButton.frame = CGRect(x: UIViewController.playerView.frame.midX-15, y: UIViewController.playerView.frame.midY-15, width: 30, height: 30)
        UIViewController.go10Button.frame = CGRect(x: UIViewController.playerView.frame.midX+35, y: UIViewController.playerView.frame.midY-15, width: 30, height: 30)
    }
}
