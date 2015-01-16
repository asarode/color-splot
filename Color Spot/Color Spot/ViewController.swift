//
//  ViewController.swift
//  Color Spot
//
//  Created by Arjun Sarode on 1/3/15.
//  Copyright (c) 2015 asarode. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var madeByLabel: UILabel!
    @IBOutlet weak var highScoreLabel: UILabel!
    override func viewDidLoad() {
        var barButton = UIBarButtonItem()
        barButton.title = "Quit"
        self.navigationItem.backBarButtonItem = barButton
        self.navigationController?.navigationBarHidden = true
        
        if UIDevice.currentDevice().modelName == "iPhone 4s" {
            madeByLabel.hidden = true
        }
        
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidAppear(animated: Bool) {
        
        var appDel : AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        
        var context : NSManagedObjectContext = appDel.managedObjectContext!
        
        let request = NSFetchRequest(entityName: "HighScore")
        request.returnsObjectsAsFaults = false
        let results : NSArray = context.executeFetchRequest(request, error: nil)!
        if  results.count > 0 {
            let highScore: Int = results[0].valueForKey("score") as Int
            highScoreLabel.text = "High Score: \(highScore)"
            
        } else {
            var baseHighScore: AnyObject = NSEntityDescription.insertNewObjectForEntityForName("HighScore", inManagedObjectContext: context)
            baseHighScore.setValue(300, forKey: "score")
            context.save(nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

