//
//  GameViewController.swift
//  Color Spot
//
//  Created by Arjun Sarode on 1/3/15.
//  Copyright (c) 2015 asarode. All rights reserved.
//

import UIKit
import CoreData

class GameViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    // ======================================
    // PROPERTIES
    // ======================================
    var targetColor : UIColor!
    var targetHue : CGFloat = 0
    var targetSaturation : CGFloat = 0
    var targetBrightness : CGFloat = 0
    var colorTweakOrder = [0,1,2,3,4,5,6,7,8]
    var score = 0
    var triesLeft = 10

    // ======================================
    // OUTLETS
    // ======================================
    @IBOutlet weak var scoreView: UIView!
    @IBOutlet weak var finalScoreLabel: UILabel!
    @IBOutlet weak var triesStaticLabel: UILabel!
    @IBOutlet weak var triesLabel: UILabel!
    @IBOutlet weak var targetColorLabel: UILabel!
    @IBOutlet weak var colorCollectionView: UICollectionView!
    @IBOutlet weak var highScoreNotifyLabel: UILabel!
    @IBOutlet weak var bannerView: UIView!
    @IBOutlet weak var popupBackgroundView: UIView!
    @IBOutlet weak var scoreStatic: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    
    // ======================================
    // VIEW METHODS
    // ======================================
    override func viewDidLoad() {
        
        if UIDevice.currentDevice().modelName == "iPhone 4s" {
            targetColorLabel.hidden = true
        }
        
        resetGame()
        
        popupBackgroundView.backgroundColor = UIColor.clearColor()
    
        styleScoreView()
        
        super.viewDidLoad()
        colorCollectionView.registerClass(ColorCell.self, forCellWithReuseIdentifier: "ColorCell")
        
    }
    
    override func viewDidAppear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    // ======================================
    // COLLECTION VIEW METHODS
    // ======================================
    func collectionView(colorCollectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return colorTweakOrder.count
        
    }
    
    func collectionView(colorCollectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = colorCollectionView.dequeueReusableCellWithReuseIdentifier("ColorCell", forIndexPath: indexPath) as ColorCell
        let tweakedColor = getTweakedColor(colorTweakOrder[indexPath.item])
        
        cell.styleCollectionCell(tweakedColor)
        
        return cell
        
    }
    
    func collectionView(colorCollectionView: UICollectionView!, layout collectionViewLayout: UICollectionViewLayout!, sizeForItemAtIndexPath indexPath: NSIndexPath!) -> CGSize {
        let width = colorCollectionView.frame.width
        let height = colorCollectionView.frame.height
        
        return CGSize(width: width/3 - 13.3, height: height/3 - 13.3)
        
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = self.colorCollectionView.cellForItemAtIndexPath(indexPath)!
        let originalColor = cell.layer.backgroundColor
        
        if !originalColor.equals(UIColor.clearColor().CGColor) {
            UIView.animateWithDuration(0.25, animations: {() -> Void in
                cell.layer.backgroundColor = UIColor.clearColor().CGColor
                cell.layer.borderColor = originalColor
                return
            })
        }
        
        if colorTweakOrder[indexPath.item] == 0 {
            
            if triesLeft == 1 {
                roundOver()
            } else {
                // ANIMATE TRANSITION TO NEXT ROUND
                popupBackgroundView.alpha = 0
                popupBackgroundView.hidden = false
                UIView.animateWithDuration(0.5, animations: {
                    self.popupBackgroundView.alpha = 1
                    self.popupBackgroundView.backgroundColor = self.targetColor
                    return
                    }, completion: { finished in
                        self.roundOver()
                })
            }

        } else {
            if colorTweakOrder[indexPath.item] == 6 || colorTweakOrder[indexPath.item] == 1 {
                score += 25
            } else {
                score += 10
            }
            
            scoreLabel.text = "\(score)"
        }
    }
    
    // ======================================
    // ACTIONS
    // ======================================
    @IBAction func playAgainClicked(sender: UIButton) {
        resetGame()
    }
    @IBAction func rateAppButtonClick(sender: UIButton) {
        UIApplication.sharedApplication().openURL(NSURL(string : "https://itunes.apple.com/app/id955809214")!);

    }
    @IBAction func shareButtonClick(sender: UIButton) {
        let firstActivityItem = "Hey, I just scored \(score) points on Color Splot! Download it and see if you can beat me!"
        
        let secondActivityItem : NSURL = NSURL(string: "https://itunes.apple.com/app/id955809214")!
        
        let activityViewController : UIActivityViewController = UIActivityViewController(
            activityItems: [firstActivityItem, secondActivityItem], applicationActivities: nil)
        
        activityViewController.excludedActivityTypes = [
            UIActivityTypePostToWeibo,
            UIActivityTypePrint,
            UIActivityTypeAssignToContact,
            UIActivityTypeSaveToCameraRoll,
            UIActivityTypeAddToReadingList,
            UIActivityTypePostToFlickr,
            UIActivityTypePostToVimeo,
            UIActivityTypePostToTencentWeibo
        ]
        
        self.presentViewController(activityViewController, animated: true, completion: nil)

    }
    
    // ======================================
    // STYLE METHODS
    // ======================================
    func styleScoreView() -> Void {
        scoreView.layer.cornerRadius = 10
        scoreView.layer.shadowColor = UIColor.blackColor().CGColor
        scoreView.layer.shadowOffset = CGSize(width: 0, height: 10)
        scoreView.layer.shadowOpacity = 0.4
        scoreView.layer.shadowRadius = 5
    }

    // ======================================
    // HELPER METHODS
    // ======================================
    func roundOver() -> Void {
        triesLeft--
        self.scoreLabel.text = "\(score)"
        self.triesLabel.text = "\(triesLeft)"
        
        if triesLeft == 0 {
            
            checkHighScoreAndUpdate()
            
            finalScoreLabel.text = "\(score)"
            
            self.popupBackgroundView.backgroundColor = UIColor(red: 1, green: 0.051, blue: 0.325, alpha: 0.85)
            popupBackgroundView.hidden = false
            scoreView.alpha = 0
            scoreView.hidden = false
            self.view.bringSubviewToFront(scoreView)
            
            // ANIMATE SHOWING FINAL SCORE VIEW
            UIView.animateWithDuration(0.5, animations: {
                self.popupBackgroundView.alpha = 1
                return
                }, completion: { finished in
                    UIView.animateWithDuration(0.5, animations: {
                        self.scoreView.alpha = 1
                        return
                    })
            })
            
        } else {
            
            UIView.animateWithDuration(0.25, animations: {
                self.popupBackgroundView.backgroundColor = UIColor.clearColor()
                return
                }, completion: { finished in
                    self.popupBackgroundView.hidden = true
            })
            
            targetColor = UIColor().generateRandomColor()
            targetColor.getHue(&targetHue, saturation: nil, brightness: nil, alpha: nil)
            targetColor.getHue(nil, saturation: &targetSaturation, brightness: nil, alpha: nil)
            targetColor.getHue(nil, saturation: nil, brightness: &targetBrightness, alpha: nil)
            
            colorTweakOrder = [0,1,2,3,4,5,6,7,8]
            colorTweakOrder.shuffle()
            
            updateBannerAndTargetText()
            colorCollectionView.reloadData()
        }
    }

    func checkHighScoreAndUpdate() -> Void {
        var appDel : AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        
        var context : NSManagedObjectContext = appDel.managedObjectContext!
        
        let request = NSFetchRequest(entityName: "HighScore")
        request.returnsObjectsAsFaults = false
        let results : NSArray = context.executeFetchRequest(request, error: nil)!
        
        var highScore = results[0].valueForKey("score") as Int
        
        if score > highScore {
            results[0].setValue(score, forKey: "score")
            highScoreNotifyLabel.text = "NEW HIGH SCORE!"
        } else {
            highScoreNotifyLabel.text = "Your score"
        }
    }
    
    func getTweakedColor(tweak: Int) -> UIColor {
        
        var tweakHue : CGFloat = self.targetHue
        var tweakSaturation : CGFloat = self.targetSaturation
        var tweakBrightness : CGFloat = self.targetBrightness
        var tweakedColor : UIColor!
        var tweakIncrement : CGFloat = 0
        var tweakIncrementMinor : CGFloat = 0
        
        if (triesLeft > 5) {
            tweakIncrement = 0.15
            tweakIncrementMinor = 0.07
        } else if (triesLeft > 1) {
            tweakIncrement = 0.07
            tweakIncrementMinor = 0.04
        } else {
            tweakIncrement = 0.05
            tweakIncrementMinor = 0.03
        }
        
        
        switch tweak {
        case 0:
            break
        case 1:
            tweakHue += tweakIncrementMinor
        case 2:
            tweakSaturation += tweakIncrement
        case 3:
            tweakBrightness += tweakIncrement
        case 4:
            tweakHue -= tweakIncrement
        case 5:
            tweakSaturation -= tweakIncrement
        case 6:
            tweakBrightness -= tweakIncrementMinor
        case 7:
            tweakHue += tweakIncrementMinor
            tweakBrightness += tweakIncrementMinor
        case 8:
            tweakHue -= tweakIncrementMinor
            tweakSaturation += tweakIncrementMinor
        default:
            break
        }
        
        if tweakHue > 1.0 {
            tweakHue = 1.0
        }
        
        if tweakHue < 0.0 {
            tweakHue = 0.0
        }
        
        if tweakSaturation > 1.0 {
            tweakSaturation = 1.0
        }
        
        if tweakSaturation < 0.0 {
            tweakSaturation = 0.0
        }
        
        if tweakBrightness > 1.0 {
            tweakBrightness = 1.0
        }
        
        if tweakBrightness < 0.0 {
            tweakBrightness = 0.0
        }
        
        
        tweakedColor = UIColor(hue: tweakHue, saturation: tweakSaturation, brightness: tweakBrightness, alpha: 1)
        
        return tweakedColor
    }
    
    func updateBannerAndTargetText() -> Void {
        bannerView.backgroundColor = targetColor
        targetColorLabel.textColor = targetColor
        targetColorLabel.text = "\(targetColor.getHexStringFromColor())"
        
        if targetColor.isLightColor() {
            triesStaticLabel.textColor = UIColor(red: 0.29, green: 0.29, blue: 0.29, alpha: 1)
            triesLabel.textColor = UIColor(red: 0.29, green: 0.29, blue: 0.29, alpha: 1)
            scoreStatic.textColor = UIColor(red: 0.29, green: 0.29, blue: 0.29, alpha: 1)
            scoreLabel.textColor = UIColor(red: 0.29, green: 0.29, blue: 0.29, alpha: 1)
        } else {
            triesStaticLabel.textColor = UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 1)
            triesLabel.textColor = UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 1)
            scoreStatic.textColor = UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 1)
            scoreLabel.textColor = UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 1)
        }
    }
    
    func updateTargetColor() -> Void {
        targetColor = UIColor().generateRandomColor()
        targetColor.getHue(&targetHue, saturation: nil, brightness: nil, alpha: nil)
        targetColor.getHue(nil, saturation: &targetSaturation, brightness: nil, alpha: nil)
        targetColor.getHue(nil, saturation: nil, brightness: &targetBrightness, alpha: nil)
    }

    
    func resetGame() {
        
        UIView.animateWithDuration(0.25, animations: {
            self.popupBackgroundView.alpha = 0
            self.scoreView.alpha = 0
            return
            }, completion: { finished in
                self.scoreView.hidden = true
                self.popupBackgroundView.hidden = true
        })
        
        score = 0
        triesLeft = 10
        colorTweakOrder = [0,1,2,3,4,5,6,7,8]
        
        scoreLabel.text = "\(score)"
        triesLabel.text = "\(triesLeft)"

        updateTargetColor()
        updateBannerAndTargetText()
        colorTweakOrder.shuffle()
        
        colorCollectionView.backgroundColor = self.view.backgroundColor
        colorCollectionView.reloadData()
        
    }

}
