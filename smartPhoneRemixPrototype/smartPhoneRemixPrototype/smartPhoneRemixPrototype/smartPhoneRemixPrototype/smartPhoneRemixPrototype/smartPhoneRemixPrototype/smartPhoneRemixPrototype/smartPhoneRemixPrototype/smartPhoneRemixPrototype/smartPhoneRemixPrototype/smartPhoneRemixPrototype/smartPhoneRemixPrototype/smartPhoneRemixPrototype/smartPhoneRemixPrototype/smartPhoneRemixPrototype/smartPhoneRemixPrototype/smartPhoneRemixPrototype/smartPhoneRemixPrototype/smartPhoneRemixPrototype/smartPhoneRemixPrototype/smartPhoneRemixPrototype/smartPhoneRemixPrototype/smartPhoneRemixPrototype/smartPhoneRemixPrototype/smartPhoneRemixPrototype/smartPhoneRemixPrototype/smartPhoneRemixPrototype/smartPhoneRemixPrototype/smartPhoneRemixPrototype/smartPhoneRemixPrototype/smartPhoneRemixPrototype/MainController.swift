//
//  ViewController.swift
//  smartPhoneRemixPrototype
//
//  Created by Adam Shechter on 7/15/16.
//  Copyright © 2016 Adam Shechter. All rights reserved.
//

import UIKit
import AudioKit

class MainController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        AudioInit()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    func AudioInit()
    {
        let loop1 = AKAudioPlayer("loop1.mp3")
        var timePitch = AKTimePitch(loop1)
        loop1.looping = true
        timePitch.rate = 2.0
        timePitch.pitch = -400.0
        timePitch.overlap = 8.0
        
        AudioKit.output = timePitch
        AudioKit.start()
        loop1.play()
    }
}

