//
//  samplerPlayer.swift
//  smartPhoneRemixPrototype
//
//  Created by Adam Shechter on 7/15/16.
//  Copyright © 2016 Adam Shechter. All rights reserved.
//

import UIKit
import AudioKit

class samplerPlayer {
    var play2: AKAudioPlayer
    var timePitch: AKTimePitch
    var filterPlayer: AKLowPassFilter
    var filterPlayer2: AKHighPassFilter
    var delayUnit: AKDelay
    var reverbUnit: AKReverb
    var playState = false
    var paramaterState: [String: Double] = ["pitch": 0.0, "rate": 0.0, "freq1": 20000.0, "freq2": 0.0, "vol": 0.375, "delay": 0, "reverb": 0]
    
    init(loop: Bool, rate: Double, pitch: Double)
    {
        paramaterState["pitch"] = pitch
        paramaterState["rate"] = rate
        let bundle = NSBundle.mainBundle()
        let file1 = bundle.pathForResource("thriller", ofType: "wav")
        play2 = AKAudioPlayer(file1!)
        play2.volume = paramaterState["vol"]!
        play2.looping = loop
        timePitch = AKTimePitch(play2)
        timePitch.rate = paramaterState["rate"]!
        timePitch.pitch = paramaterState["pitch"]!
        timePitch.overlap = 4.0
        filterPlayer = AKLowPassFilter(timePitch)
        filterPlayer.cutoffFrequency = paramaterState["freq1"]!
        filterPlayer.resonance = 0.0
        filterPlayer2 = AKHighPassFilter(filterPlayer)
        filterPlayer2.cutoffFrequency = paramaterState["freq2"]!
        filterPlayer2.resonance = 0.0
        delayUnit = AKDelay(filterPlayer2)
        delayUnit.time = 0.2
        delayUnit.feedback = 0.4
        delayUnit.dryWetMix = paramaterState["delay"]!
        delayUnit.start()
        reverbUnit = AKReverb(delayUnit)
        reverbUnit.dryWetMix = paramaterState["reverb"]!
        AudioKit.output = reverbUnit
        AudioKit.start()
        print("samplePlayer Init finished")
    }
    
    func changeLoopFile(loopFile: Int)
    {
        play2.stop()
        AudioKit.stop()
        let bundle = NSBundle.mainBundle()
        switch loopFile {
        case 1:
            let file1 = bundle.pathForResource("thriller", ofType: "wav")
            play2 = AKAudioPlayer(file1!)
        case 2:
            let file2 = bundle.pathForResource("cali_love", ofType: "wav")
            play2 = AKAudioPlayer(file2!)
        case 3:
            let file3 = bundle.pathForResource("lucky", ofType: "wav")
            play2 = AKAudioPlayer(file3!)
        case 4:
            let file4 = bundle.pathForResource("magic", ofType: "wav")
            play2 = AKAudioPlayer(file4!)
        default:
            let file1 = bundle.pathForResource("thriller", ofType: "wav")
            play2 = AKAudioPlayer(file1!)
        }
        timePitch = AKTimePitch(play2)
        filterPlayer = AKLowPassFilter(timePitch)
        filterPlayer2 = AKHighPassFilter(filterPlayer)
        delayUnit = AKDelay(filterPlayer2)
        reverbUnit = AKReverb(delayUnit)
        AudioKit.output = reverbUnit
        play2.looping = true
        AudioKit.start()
        self.playSamplerPlayer(playState)
    }
    
    func playSamplerPlayer(startStop: Bool)
    {
        playState = startStop
        print("playState \(playState)")
        if playState
        {
            play2.play()
            
        }
        else
        {
            play2.stop()
        }
    }
    
    func changePitch(pitch: Double)
    {
        paramaterState["pitch"] = pitch
        timePitch.pitch = paramaterState["pitch"]!
    }
    
    func changeRate(rate: Double)
    {
        paramaterState["rate"] = rate
        timePitch.rate = paramaterState["rate"]!
    }
    
    func changeFilterCutoff(cutoff: Double)
    {
        // print("filterCutoff \(cutoff)")
        if cutoff > 0.5
        // High Pass Filter Activated
        {
         
            paramaterState["freq2"] = ((cutoff - 0.5) * 2) * 7000
            filterPlayer2.cutoffFrequency = paramaterState["freq2"]!
            if paramaterState["freq2"] > 5000
            {
                filterPlayer2.resonance = 5
            }
            else if paramaterState["freq2"] > 500
            {
                filterPlayer2.resonance = 8
            }
            else
            {
                filterPlayer2.resonance = 10
            }
            paramaterState["freq1"] = 20000
            filterPlayer.cutoffFrequency = paramaterState["freq1"]!
            filterPlayer.resonance = 0.0
        }
        else if cutoff < 0.5
        // LowPass Filter Activated
        {
            paramaterState["freq1"] = cutoff * 10000
            filterPlayer.cutoffFrequency = paramaterState["freq1"]!
            if paramaterState["freq1"] > 5000
            {
                filterPlayer.resonance = 5
            }
            else if paramaterState["freq1"] > 500
            {
                filterPlayer.resonance = 8
            }
            else
            {
                filterPlayer.resonance = 10
            }
            paramaterState["freq2"] = 0
            filterPlayer2.cutoffFrequency = paramaterState["freq2"]!
            filterPlayer2.resonance = 0.0
        }
        else
        {
            paramaterState["freq1"] = 20000
            filterPlayer.cutoffFrequency = paramaterState["freq1"]!
            filterPlayer.resonance = 0.0
            paramaterState["freq2"] = 0
            filterPlayer2.cutoffFrequency = paramaterState["freq2"]!
            filterPlayer2.resonance = 0.0
        }
        // paramaterState["freq1"] = cutoff + 30
        // filterPlayer.cutoffFrequency = paramaterState["freq1"]!
    }
    
    func changeDelayReverb(delayReverb: Double)
    {
        // print("delayReverb \(delayReverb)")
        if delayReverb > 0
        // delay activated reverb off
        {
            paramaterState["delay"] = delayReverb
            paramaterState["reverb"] = 0.0
            if delayReverb > 0.7
            {
                delayUnit.feedback = 0.6
            }
            else if delayReverb > 0.4
            {
                delayUnit.feedback = 0.5
            }
            else
            {
                delayUnit.feedback = 0.3
            }
            delayUnit.dryWetMix = paramaterState["delay"]!
            reverbUnit.dryWetMix = paramaterState["reverb"]!
        }
        else if delayReverb < 0
        // reverb activated delay off
        {
            paramaterState["reverb"] = abs(delayReverb)
            paramaterState["delay"] = 0.0
            reverbUnit.dryWetMix = paramaterState["reverb"]!
            delayUnit.dryWetMix = paramaterState["delay"]!
        }
        else
        {
            paramaterState["reverb"] = 0.0
            paramaterState["delay"] = 0.0
            reverbUnit.dryWetMix = paramaterState["reverb"]!
            delayUnit.dryWetMix = paramaterState["delay"]!
        }
    }
    
    func changeVolume(volume: Double)
    {
        paramaterState["vol"] = volume
        play2.volume = paramaterState["vol"]!
        
    }
}
