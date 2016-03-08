//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Sandra Adams-Hallie on Mar/7/16.
//  Copyright © 2016 Sandra Adams-Hallie. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController{

    var audioPlayer:AVAudioPlayer!
    var audioPlayerEcho:AVAudioPlayer!
    var receivedAudio:RecordedAudio!
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!
    var audioPlayerNode: AVAudioPlayerNode!

    @IBOutlet var stopAudioButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        audioPlayer = try! AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl)
        audioPlayer.enableRate = true
        audioEngine = AVAudioEngine()
        audioFile = try! AVAudioFile(forReading: receivedAudio.filePathUrl)
    }
    
    func playAudioRate(audioPlaybackRate rate: float_t) {
        stopAudio(self)
        audioPlayer.enableRate = true
        stopAudioButton.enabled = true
        audioPlayer.rate = rate
        audioPlayer.currentTime = 0.0
        audioPlayer.play()
    }

    @IBAction func playSlowAudio(sender: UIButton) {
        playAudioRate(audioPlaybackRate: 0.5)
    }
    
    @IBAction func playFastAudio(sender: UIButton) {
        playAudioRate(audioPlaybackRate: 2.0)

    }
    
    @IBAction func playChipMunkAudio(sender: UIButton) {
        playAudioWithVariablePitch(1000)
    }
    
    func playAudioWithVariablePitch(pitch: Float){
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        //Node for playing audio.
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        let changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        try! audioEngine.start()
        
        audioPlayerNode.play()
    }
    
    @IBAction func playDarthvaderAudio(sender: UIButton) {
        playAudioWithVariablePitch(-1000)
    }
    
    
    @IBAction func playEchoAudio(sender: UIButton) {
        
        let audioEcho = AVAudioUnitDistortion()
        
        //Configures the audio distortion unit by loading a distortion preset.
        audioEcho.loadFactoryPreset(AVAudioUnitDistortionPreset.MultiEcho2)
        audioEcho.preGain = -10
        audioEcho.wetDryMix = 99
        
        playAudioWithEchoEffect(audioEcho)
    }
    
    // Invoke this method for playEchoAudio.
    private func playAudioWithEchoEffect(audioUnit: AVAudioUnit) {

        stopAudio(self)
        
        //Node for playing audio.
        audioPlayerNode = AVAudioPlayerNode()

        audioEngine.attachNode(audioPlayerNode)
        audioEngine.attachNode(audioUnit)
        
        audioEngine.connect(audioPlayerNode, to: audioUnit, format: nil)
        audioEngine.connect(audioUnit, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        try! audioEngine.start()
    
        stopAudioButton.enabled = true
        audioPlayerNode.play()
        
    }

    // To effectively refactor this code.
    @IBAction func stopAudio(sender: AnyObject) {
        audioEngine.stop()
        audioPlayer.stop()
        audioEngine.reset()
        audioPlayer.currentTime = 0
        stopAudioButton.enabled = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
