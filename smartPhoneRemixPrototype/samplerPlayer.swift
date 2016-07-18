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
    var playState = false
    var paramaterState: [String: Double] = ["pitch": 0.0, "rate": 0.0, "freq1": 20000.0, "freq2": 0.0, "vol": 0.5]
    
    init(loop: Bool, rate: Double, pitch: Double)
    {
        paramaterState["pitch"] = pitch
        paramaterState["rate"] = rate
        let bundle = NSBundle.mainBundle()
        let file1 = bundle.pathForResource("thriller", ofType: "wav")
        play2 = AKAudioPlayer(file1!)
        timePitch = AKTimePitch(play2)
        play2.looping = loop
        timePitch.rate = paramaterState["rate"]!
        timePitch.pitch = paramaterState["pitch"]!
        timePitch.overlap = 4.0
        filterPlayer = AKLowPassFilter(timePitch)
        filterPlayer.cutoffFrequency = paramaterState["freq1"]!
        filterPlayer.resonance = 0.0
        filterPlayer2 = AKHighPassFilter(filterPlayer)
        filterPlayer2.cutoffFrequency = paramaterState["freq2"]!
        filterPlayer2.resonance = 0.0
        AudioKit.output = filterPlayer2
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
        AudioKit.output = filterPlayer2
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
        print("filterCutoff \(cutoff)")
        if cutoff > 0.5
        // High Pass Filter Activated
        {
         
            paramaterState["freq2"] = ((cutoff - 0.5) * 2) * 7000
            print("filterplayer2 cutoff \(((cutoff - 0.5) * 2) * 7000)")
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
    
    func changeVolume(volume: Double)
    {
        paramaterState["vol"] = volume
        play2.volume = paramaterState["vol"]!
        
    }
}
