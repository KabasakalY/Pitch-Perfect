//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Yıldıray Kabasakal on 15.02.2023.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate{

    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordLabel: UILabel!
    var audioRecorder : AVAudioRecorder!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        stopButton.isEnabled = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func recordButtonAction(_ sender: Any) {
        recordButton.isEnabled = false
        stopButton.isEnabled = true
        recordLabel.text = "Recording..."
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
                let recordingName = "recordedVoice.wav"
                let pathArray = [dirPath, recordingName]
                let filePath = URL(string: pathArray.joined(separator: "/"))

                let session = AVAudioSession.sharedInstance()
                try! session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)

                try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
                audioRecorder.delegate = self
                audioRecorder.isMeteringEnabled = true
                audioRecorder.prepareToRecord()
                audioRecorder.record()

    }
    
    @IBAction func stopButtonAction(_ sender: Any) {
        recordButton.isEnabled = true
        stopButton.isEnabled = false
        recordLabel.text = "Tap to Record!"
        
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
   
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        
        if flag {
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        }
        else{
            print("Recording was not successful")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording"{
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
    
    
}

