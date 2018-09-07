//
//  ViewController.swift
//  PickYourPitch
//
//  Created by 10.12 on 2018/8/22.
//  Copyright © 2018 10.12. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    // MARK: Properties
    var audioRecorder: AVAudioRecorder!
    var recordedAudio: RecordedAudio!

    
    // MARK: Outlets
    
    @IBOutlet weak var recordingInProgress: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    // MARK: Life Cycle
    override func viewWillAppear(_ animated: Bool) {
        // Hide the stop button, enable the record button
        stopButton.isHidden = true
        recordingInProgress.isHidden = true
        recordButton.isEnabled = true
        
    }
    
    // MARK: Acitons
    @IBAction func recordAudio(_ sender: UIButton) {
        // Update the UI
        recordButton.isEnabled = false
        stopButton.isHidden = false
        recordingInProgress.isHidden = false
        
        // Setup audio session
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)
        } catch _ {
        }
        
        // Creat a name for the file.
        let filename = "usersVocie.wav"
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) [0] as String
        let pathArray = [dirPath, filename]
        let fileURL = URL(string: pathArray.joined(separator: "/"))
        
        do {
            // Initialize and prepare the recorder
            audioRecorder = try AVAudioRecorder(url: fileURL!, settings: [String: AnyObject]())
        } catch _ {
        }
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        
    }
    
    @IBAction func stopAudio(_ sender: UIButton) {
        recordingInProgress.isHidden = true
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setActive(false)
        } catch _ {
            
        }
    }
    
    // MARK: audio recorder did finished
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        
        if flag {
            recordedAudio = RecordedAudio(filePathUrl: recorder.url, title: recorder.url.pathExtension)
            self.performSegue(withIdentifier: "stopRecording", sender: self)
        } else {
            print("Recording was not successful")
            recordButton.isEnabled = true
            stopButton.isHidden = true
        }
    }
    
    // MARK: Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            let playSoundsVC: PlaySoundsViewController = segue.destination as! PlaySoundsViewController
            let data = recordedAudio
            playSoundsVC.receivedAudio = data
        }
    }

}

