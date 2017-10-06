//
//  ViewController.swift
//  MyApp33
//
//  Created by 謝尚霖 on 2017/10/6.
//  Copyright © 2017年 謝尚霖. All rights reserved.
//

import UIKit
import Speech

class ViewController: UIViewController {
    var audioEngine = AVAudioEngine()
    let speedRecog = SFSpeechRecognizer(locale: Locale(identifier: "zh-TW"))
    var request = SFSpeechAudioBufferRecognitionRequest()
    var recogTask: SFSpeechRecognitionTask? = nil
    
    
    @IBOutlet weak var textV: UITextView!
    @IBOutlet weak var start: UIButton!
    @IBOutlet weak var lab: UILabel!
    
    
    @IBAction func dostart(_ sender: Any) {
        
        if audioEngine.isRunning {
            //中斷
            audioEngine.stop()
            request.endAudio()
            
            
        }else{
            //開始錄
            audioEngine = AVAudioEngine()
            startRecording()
            
        }
        
        
        
    }
    
    
    func startRecording(){
        
        // 處理目前正在辨識中的任務
        if recogTask != nil {
            recogTask?.cancel()
            recogTask = nil
            
            
        }
        
        let audioSession = AVAudioSession.sharedInstance()
        
        do{
            try audioSession.setCategory(AVAudioSessionCategoryRecord)
            try audioSession.setMode(AVAudioSessionModeMeasurement)
            try audioSession.setActive(true, with: .notifyOthersOnDeactivation)
            
            request = SFSpeechAudioBufferRecognitionRequest()
            request.shouldReportPartialResults = true
            
            let inputNode = audioEngine.inputNode
            
            speedRecog?.recognitionTask(with: request, resultHandler: { (result, error) in
                if result != nil{
//                    self.lab.text = result?.bestTranscription.formattedString
                    
                    self.textV.text = result?.bestTranscription.formattedString
                }
            })
            
            let recordingFormat = inputNode.outputFormat(forBus: 0)
            inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat, block: { (buffer, when) in
                self.request.append(buffer)
            })
            
            
            audioEngine.prepare()
            do {
            try audioEngine.start()
            }catch{
                
                print("error2: \(error)")
            }
            
            
            
            
        }catch{
            print("error: \(error)")
        }
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SFSpeechRecognizer.requestAuthorization { (status) in
            switch status {
            case .authorized:
                print("OK")
            case .denied:
                print("xx")
            default:
                print("other")
            }
        }
        
    }

    


}

