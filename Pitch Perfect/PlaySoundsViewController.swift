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
        audioEngine = AVAudioEngine()
        audioFile = try! AVAudioFile(forReading: receivedAudio.filePathUrl)
    }
    
    func playAudioRate(audioPlaybackRate rate: float_t) {
        stopAudio(self)
        audioPlayer.enableRate = true
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
        stopAudio(self)
        let changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        playAudioWithEffect(changePitchEffect)
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
        
        playAudioWithEffect(audioEcho)
    }
    
    // Invoke this method for playEchoAudio.
    private func playAudioWithEffect(audioUnit: AVAudioUnit) {

        stopAudio(self)
        stopAudioButton.enabled = true
        audioPlayerNode = AVAudioPlayerNode()

        audioEngine.attachNode(audioPlayerNode)
        audioEngine.attachNode(audioUnit)
        
        audioEngine.connect(audioPlayerNode, to: audioUnit, format: nil)
        audioEngine.connect(audioUnit, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        try! audioEngine.start()
        audioPlayerNode.play()
        
    }

    @IBAction func stopAudio(sender: AnyObject) {
        audioEngine.stop()
        audioPlayer.stop()
        audioEngine.reset()
        audioPlayer.currentTime = 0
        stopAudioButton.enabled = false
    }
    
}
