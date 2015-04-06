//
//  RecordSoundsViewController.swift
//  pitchperfect
//
//  Created by Troy Sowards on 3/10/15.
//  Copyright (c) 2015 Troy Sowards. All rights reserved.
//

import UIKit
import AVFoundation
//Declared Globally


class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {


    @IBOutlet weak var tapToRecord: UILabel!
    
    @IBOutlet weak var recordButton: UIButton!

    @IBOutlet weak var recordingInProgress: UILabel!
   
    
    @IBOutlet weak var stopRecording: UIButton!
   
    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio!
    var receivedAudio:RecordedAudio!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func recordButton(sender: UIButton) {
        stopRecording.hidden = false
        recordingInProgress.hidden = false
        recordButton.enabled = false
        tapToRecord.hidden = true
        //TODO:Record the Users Voice
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        println(filePath)
        
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        //Initialize and prepare the recorder
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }

    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if(flag){
        recordedAudio = RecordedAudio()
        recordedAudio.filePathUrl = recorder.url
        recordedAudio.title = recorder.url.lastPathComponent
        self.performSegueWithIdentifier("nextScreen", sender: recordedAudio)
        }else{
            println("Recording was not successful")
            recordButton.enabled = true
            stopRecording.hidden = true
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "nextScreen") {
            let playSoundsVC:playSoundViewController = segue.destinationViewController as playSoundViewController
            let data = sender as RecordedAudio
            playSoundsVC.receivedAudio = data
        }
    }
    
        @IBAction func stopRecording(sender: UIButton) {
        recordingInProgress.hidden = true
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
    }

}



