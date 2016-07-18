//
//  ViewController.swift
//  smartPhoneRemixPrototype
//
//  Created by Adam Shechter on 7/15/16.
//  Copyright © 2016 Adam Shechter. All rights reserved.
//

import UIKit
import AudioKit
import CoreMotion

class MainController: UIViewController
{
    var samplerPlayer1 = samplerPlayer(loop: true, rate: 1.0, pitch: 1.0)
    var playFlag = false
    
    var motionSelectorSwitch = 0
    // CoreMotion motion manager
    let manager = CMMotionManager()
    
    @IBOutlet weak var pitchSliderValue: UISlider!
    @IBOutlet weak var speedSliderValue: UISlider!
    @IBOutlet weak var filterSliderValue: UISlider!
    @IBOutlet weak var volSliderValue: UISlider!
    @IBOutlet weak var fileSelectorLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var efxSliderValue: UISlider!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        accelInit()
        
    }
    

    

    
    @IBAction func pitchSlider(sender: UISlider) {
        let newPitch = Double(sender.value * 1000)
        samplerPlayer1.changePitch(newPitch)
    }
    
    @IBAction func speedSlider(sender: UISlider) {
        let newRate = Double(sender.value) + 0.03125
        samplerPlayer1.changeRate(newRate)
    }
    
    @IBAction func freqSlider(sender: UISlider) {
        let newCutoff = Double(sender.value)
        samplerPlayer1.changeFilterCutoff(newCutoff)
    }
    
    @IBAction func volSlide(sender: UISlider) {
        let newVol = Double(sender.value)
        samplerPlayer1.changeVolume(newVol)
    }
    
    @IBAction func playButton(sender: UIButton) {
        playFlag = !playFlag
        print("playButton pressed \(playFlag)")
        samplerPlayer1.playSamplerPlayer(playFlag)
    }
    
    @IBAction func sampleFileSelector(sender: UIStepper) {
        let fileSelector = Int(sender.value)
        fileSelectorLabel.text = String(fileSelector)
        samplerPlayer1.changeLoopFile(fileSelector)
        resetAllSlidersAndValues()
    }
    
    @IBAction func accelControlValueChanged(sender: UISegmentedControl) {
        print("Motion Selector Switch \(sender.selectedSegmentIndex)")
        motionSelectorSwitch = sender.selectedSegmentIndex
    }
    
    @IBAction func efxSlider(sender: UISlider) {
        let newEfx = Double(sender.value)
        samplerPlayer1.changeDelayReverb(newEfx)
    }
    
    @IBAction func resetButtonPressed(sender: UIButton) {
        resetAllSlidersAndValues()
    }
    
    func accelInit()
    {
        
        print ("acceloremeter initializing")
        manager.startAccelerometerUpdates()
        manager.accelerometerUpdateInterval = 0.1
        manager.startAccelerometerUpdatesToQueue(NSOperationQueue.mainQueue())
        {
            (data, error) in
            print (data?.acceleration.x)
            print (data?.acceleration.y)
            print (data?.acceleration.z)
            print (self.motionSelectorSwitch)
            if self.motionSelectorSwitch == 0
            {
                // Pitch and Rate controllers
                self.pitchSliderValue.value = Float((data?.acceleration.x)!)
                self.speedSliderValue.value = Float((data?.acceleration.y)!) + 1.0
            
                let newPitch = Double((data?.acceleration.x)! * 1000)
                self.samplerPlayer1.changePitch(newPitch)
            
                let newRate = Double( (data?.acceleration.y)! + 1.0) + 0.03125
                self.samplerPlayer1.changeRate(newRate)
            
            }
            else if self.motionSelectorSwitch == 1
            {
            // filter and efx controllers
                self.filterSliderValue.value = Float((data?.acceleration.x)! + 1) / 2
                self.efxSliderValue.value = Float((data?.acceleration.y)!)
                // self.volSliderValue.value =  Float((data?.acceleration.y)! + 1) / 2 * 0.75
            
                let newCutoff = Double(((data?.acceleration.x)! + 1) / 2)
                self.samplerPlayer1.changeFilterCutoff(newCutoff)
            
                let newEFX = Double((data?.acceleration.y)!)
                self.samplerPlayer1.changeDelayReverb(newEFX)
            
            }
            else if self.motionSelectorSwitch == 2
            {
                print("accelerometer off")
            }
        
        }

    }

    func resetAllSlidersAndValues()
    {
        pitchSliderValue.value = 0
        samplerPlayer1.changePitch(0)
        speedSliderValue.value = 1
        samplerPlayer1.changeRate(1)
        filterSliderValue.value = 0.5
        samplerPlayer1.changeFilterCutoff(0.5)
        volSliderValue.value = 0.375
        samplerPlayer1.changeVolume(0.375)
        efxSliderValue.value = 0
        samplerPlayer1.changeDelayReverb(0)
    }

}

