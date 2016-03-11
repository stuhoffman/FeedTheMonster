//
//  ViewController.swift
//  FeedTheMonster
//
//  Created by Stuart Hoffman on 3/11/16.
//  Copyright © 2016 Stuart Hoffman. All rights reserved.
//

import UIKit

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
    
    var penalties = 0
    var timer: NSTimer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        foodImg.dropTarget = monsterImg
        heartImg.dropTarget = monsterImg
        
        penalty1img.alpha = DIM_ALPHA
        penalty2img.alpha = DIM_ALPHA
        penalty3img.alpha = DIM_ALPHA
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "itemDroppedOnCharacter:", name: "onTargetDropped", object: nil)
        startTimer()
    }

    func itemDroppedOnCharacter(notif: AnyObject) {
        print("Item dropped on character")
    }

    func startTimer() {
        if timer != nil {
            timer.invalidate()
        }
        
        timer = NSTimer.scheduledTimerWithTimeInterval(3.0, target: self, selector: "changeGameState", userInfo: nil, repeats: true)
    }
    
    func changeGameState() {
        penalties++
        
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
    
    func gameOver() {
        timer.invalidate()
        monsterImg.playDeathAnimation()
    }
}

