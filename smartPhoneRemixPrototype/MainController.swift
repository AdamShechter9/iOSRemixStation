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
    
    
    @IBOutlet weak var pitchSliderValue: UISlider!
    @IBOutlet weak var speedSliderValue: UISlider!
    @IBOutlet weak var filterSliderValue: UISlider!
    @IBOutlet weak var volSliderValue: UISlider!
    @IBOutlet weak var fileSelectorLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    
    
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
    
    
    @IBAction func resetButtonPressed(sender: UIButton) {
        resetAllSlidersAndValues()
    }
    
    func accelInit()
    {
        let manager = CMMotionManager()
        print ("acceloremeter initializing")
        manager.startAccelerometerUpdates()
        manager.accelerometerUpdateInterval = 0.1
        manager.startAccelerometerUpdatesToQueue(NSOperationQueue.mainQueue())
        {
            (data: CMAccelerometerData?, error: NSError?) in
            print(data?.acceleration.x)
            print(data?.acceleration.y)
            print(data?.acceleration.z)
            switch self.motionSelectorSwitch
            {
            case 0:
                self.pitchSliderValue.value = Float((data?.acceleration.x)!)
                self.speedSliderValue.value = Float((data?.acceleration.y)!)
            case 1:
                self.filterSliderValue.value = Float((data?.acceleration.x)!)
                self.volSliderValue.value =  Float((data?.acceleration.y)!)
            default:
                self.pitchSliderValue.value = Float((data?.acceleration.x)!)
                self.speedSliderValue.value = Float((data?.acceleration.y)!)
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
    }

}

