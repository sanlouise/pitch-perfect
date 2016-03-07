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

    
    //Declare variable audioPlayer.
    var audioPlayer:AVAudioPlayer!
    
    // To pass the recording from the other Controller.
    var receivedAudio:RecordedAudio!
    
    var audioEngine:AVAudioEngine!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Create a path to the file. NSBundle.mainBUndle returns the path where the app is located. pathForResource gives the path to the folder where the mp3 file is located.
        
//        if var filePath = NSBundle.mainBundle().pathForResource("movie_quote", ofType: "mp3"){
//            // This converts the string to NSURL, as is suggested in the documentation.
//            let filePathUrl = NSURL.fileURLWithPath(filePath)
//        }else {
//            print("The filePath is empty.")
//        }
        
        // Initialize AVAudioPlayer.
        audioPlayer = try! AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl)
        audioPlayer.enableRate = true
        audioEngine = AVAudioEngine()
    }


    @IBAction func playSlowAudio(sender: UIButton) {
        
        // Use AVAudioPlayer.
        audioPlayer.stop()
        //Leaving this line out will not reset the mp3 back to the beginning.
        audioPlayer.currentTime = 0.0
        audioPlayer.rate = 0.5
        audioPlayer.play()
        
    }
    
    
    @IBAction func playFastAudio(sender: UIButton) {
        
        audioPlayer.stop()
        audioPlayer.currentTime = 0.0
        audioPlayer.rate = 2.0
        audioPlayer.play()
        
    }
    
    
    @IBAction func playChipMunkAudio(sender: UIButton) {
        playAudioWithVariablePitch(1000)
    }
        
  
    func playAudioWithVariablePitch(pitch: Float){
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
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
    
    

    @IBAction func stopAudio(sender: UIButton) {
        audioPlayer.stop()
    }
    



    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
