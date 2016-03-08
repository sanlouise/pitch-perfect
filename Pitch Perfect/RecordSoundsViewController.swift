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
    
    class RecordedAudio: NSObject{
        var filePathUrl: NSURL!
        var title: String!
        
        init(filePathUrl: NSURL, title: String) {
            
            self.filePathUrl = filePathUrl
            self.title = title
        }
    }
    
    var pauseImage: UIImage!
    var resumeImage: UIImage!
    
    @IBOutlet var recordButton: UIButton!
    @IBOutlet var recordingLabel: UILabel!
    @IBAction func recordAudio(sender: AnyObject) {
        recordButton.enabled = false
        stopRecordingButton.hidden = false
        stopRecordingButton.enabled = true
        pauseRecording.hidden = false
        recordingLabel.text = "Recording"
        
        
        // Create a path to the mp3 file, here it is the document directory.
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        let recordingName = "my_audio.wav"

        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        
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
            recordedAudio = RecordedAudio(filePathUrl: recorder.url, title: recorder.url.lastPathComponent!)
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
    
    
    @IBAction func stopRecording(sender: AnyObject) {
        
        recordButton.enabled = true
        stopRecordingButton.enabled = false
        pauseRecording.hidden = true
        recordingLabel.text = "Tap to Record"
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    @IBOutlet var stopRecordingButton: UIButton!
    @IBOutlet var pauseRecording: UIButton!
    @IBAction func doPauseRecording(sender: UIButton) {
        
        if (audioRecorder.recording) {
            audioRecorder.pause()
            recordingLabel.text = "Paused"
            pauseRecording.setImage(resumeImage, forState: UIControlState.Normal)
        } else {
            audioRecorder.record()
            recordingLabel.text = "Recording"
            pauseRecording.setImage(pauseImage, forState: UIControlState.Normal)
        }
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stopRecordingButton.enabled = false
        pauseImage = UIImage(named: "Pause")
        resumeImage = UIImage(named: "Resume")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
}

