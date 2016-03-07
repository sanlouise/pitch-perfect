//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Sandra Adams-Hallie on Mar/6/16.
//  Copyright © 2016 Sandra Adams-Hallie. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio!
    
    @IBOutlet var recordingLabel: UILabel!
    @IBAction func recordAudio(sender: AnyObject) {
        
        // When recording, disable Recording Button and enable Stop Recording Button.
        recordButton.enabled = false
        stopRecordingButton.enabled = true
        recordingLabel.text = "Recording"
        
        
//         Create a path to the mp3 file, here it is the document directory.
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        
        //Use this code to store the recorded audiofiles with their creation date. This is not optimal for storage, however.
//        let currentDateTime = NSDate()
//        let formatter = NSDateFormatter()
//        formatter.dateFormat = "ddMMyyyy-HHmmss"
//        let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
        
        let recordingName = "my_audio.wav"
        
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        print(filePath)
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        
        try! audioRecorder = AVAudioRecorder(URL: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        
        
    }
    // Recorder refers to the actual file recorded on the phone
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        if (flag) {
            
            // Save the recorded audio
            recordedAudio = RecordedAudio()
            recordedAudio.filePathUrl = recorder.url
            recordedAudio.title = recorder.url.lastPathComponent
            
            // Perform the segue
          self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
            
        } else {
            
            print("Oops, the recording was not successful")
            stopRecordingButton.hidden = true
            recordButton.enabled = true
        }
        
    }
    
    // To pass data to the next Controller.
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier == "stopRecording") {
            
            let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            let data = sender as! RecordedAudio
            playSoundsVC.receivedAudio = data

        }
        
    }
    
    
    @IBOutlet var recordButton: UIButton!
    @IBAction func stopRecording(sender: AnyObject) {
        
        recordButton.enabled = true
        stopRecordingButton.enabled = false
        recordingLabel.text = "Tap to Record"
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
        
    }
    
    @IBOutlet var stopRecordingButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // When the view has loaded, disable the Stop Recording button.
        stopRecordingButton.enabled = false
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    


}

