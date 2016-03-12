//
//  ViewController.swift
//  FeedTheMonster
//
//  Created by Stuart Hoffman on 3/11/16.
//  Copyright © 2016 Stuart Hoffman. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    @IBOutlet weak var monsterImg: MonsterImg!
    @IBOutlet weak  var foodImg: DragImg!
    @IBOutlet weak var heartImg: DragImg!
    @IBOutlet var penalty1img: UIImageView!
    @IBOutlet var penalty2img: UIImageView!
    @IBOutlet var penalty3img: UIImageView!
    let DIM_ALPHA: CGFloat = 0.2
    let OPAQUE: CGFloat = 1.0
    let MAX_PENALTIES = 3
    let MUSIC_VOLUME: Float = 0.1
    
    var penalties = 0
    var timer: NSTimer!
    var monsterHappy = false
    var currentItem: UInt32 = 0
    
    var musicPlayer: AVAudioPlayer!
    var sfxBite: AVAudioPlayer!
    var sfxHeart: AVAudioPlayer!
    var sfxDeath: AVAudioPlayer!
    var sfxSkull: AVAudioPlayer!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        foodImg.dropTarget = monsterImg
        heartImg.dropTarget = monsterImg
        
        penalty1img.alpha = DIM_ALPHA
        penalty2img.alpha = DIM_ALPHA
        penalty3img.alpha = DIM_ALPHA
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "itemDroppedOnCharacter:", name: "onTargetDropped", object: nil)
        
        do {
            try musicPlayer = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("cave-music", ofType: "mp3")!))
            
            try sfxBite = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("bite", ofType: "wav")!))

            try sfxHeart = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("heart", ofType: "wav")!))

            try sfxDeath = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("death", ofType: "wav")!))

            try sfxSkull  = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("skull", ofType: "wav")!))

            musicPlayer.prepareToPlay()
            musicPlayer.play()
            musicPlayer.volume = MUSIC_VOLUME
            sfxBite.prepareToPlay()
            sfxBite.volume = MUSIC_VOLUME
            sfxDeath.prepareToPlay()
            sfxDeath.volume = MUSIC_VOLUME
            sfxHeart.prepareToPlay()
            sfxHeart.volume = MUSIC_VOLUME
            sfxSkull.prepareToPlay()
            sfxSkull.volume = MUSIC_VOLUME
            
        } catch let err as NSError {
            print(err.debugDescription)
        }
        startTimer()
    }

    func itemDroppedOnCharacter(notif: AnyObject) {
        monsterHappy = true
        startTimer()
        
        foodImg.alpha = DIM_ALPHA
        foodImg.userInteractionEnabled = false
        
        heartImg.alpha = DIM_ALPHA
        heartImg.userInteractionEnabled = false
        
        if currentItem == 0 {
            sfxHeart.play()
        } else if currentItem  == 1 {
            sfxBite.play()
        }
    }

    func startTimer() {
        if timer != nil {
            timer.invalidate()
        }
        
        timer = NSTimer.scheduledTimerWithTimeInterval(3.0, target: self, selector: "changeGameState", userInfo: nil, repeats: true)
    }
    
    func changeGameState() {
        
        if !monsterHappy {

            penalties++
            sfxSkull.play()
            
            if penalties == 1 {
                penalty1img.alpha = OPAQUE
                penalty2img.alpha = DIM_ALPHA
                penalty3img.alpha = DIM_ALPHA
            } else if penalties == 2 {
                penalty1img.alpha = OPAQUE
                penalty2img.alpha = OPAQUE
                penalty3img.alpha = DIM_ALPHA
                
            } else if penalties >= 3 {
                penalty1img.alpha = OPAQUE
                penalty2img.alpha = OPAQUE
                penalty3img.alpha = OPAQUE
            } else {
                penalty1img.alpha = DIM_ALPHA
                penalty2img.alpha = DIM_ALPHA
                penalty3img.alpha = DIM_ALPHA
                
            }
            
            if penalties >= MAX_PENALTIES {
                gameOver()
            }
            
        }
        
        let rand = arc4random_uniform(2)
        //toggles which item is avalilable or not
        if rand == 0 {
            foodImg.alpha = DIM_ALPHA
            foodImg.userInteractionEnabled = false
            
            heartImg.alpha = OPAQUE
            heartImg.userInteractionEnabled = true
        } else {
            foodImg.alpha = OPAQUE
            foodImg.userInteractionEnabled = true
            
            heartImg.alpha = DIM_ALPHA
            heartImg.userInteractionEnabled = false
            
        }
        currentItem = rand
        monsterHappy = false
    }
    
    func gameOver() {
        timer.invalidate()
        monsterImg.playDeathAnimation()
        sfxDeath.play()
    }
}

