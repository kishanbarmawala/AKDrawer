
//
//  SearchTextField.swift
//  AKDrawer
//
//  Created by Kishan Barmawala on 26/08/19.
//  Copyright © 2019 Gatisofttech. All rights reserved.
//

import UIKit
import Speech
import AVKit

protocol AKSearchDelegate {
    func textFieldSearch(result: String)
}


@available(iOS 10.0, *)
class SearchTextField: UITextField, UITextFieldDelegate, SFSpeechRecognizerDelegate {
    
    var searchDelegate: AKSearchDelegate?
    private let tempViewL = UIView()
    private let tempViewR = UIView()
    private let btnSearch : UIButton = {
        let tempBtn = UIButton(type: .custom)
        tempBtn.addTarget(self, action: #selector(voiceTapped(_:)), for: .touchUpInside)
        return tempBtn
    }()
    private let searchBtnImage = UIImage(named: "mic_icon")
    private let searchImageView = UIImageView(image: #imageLiteral(resourceName: "search_b"))
    private var checkForSearchBtn = Bool()
    
    let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
    var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    var recognitionTask: SFSpeechRecognitionTask?
    let audioEngine = AVAudioEngine()
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        delegate = self
//        btnSearch.addTarget(self, action: #selector(voiceTapped(_:)), for: .touchUpInside)
//        createBorder()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        delegate = self
        self.addTarget(self, action: #selector(didChangeValueOfSearch(_:)), for: .editingChanged)
//        btnSearch.addTarget(self, action: #selector(voiceTapped(_:)), for: .touchUpInside)
        self.returnKeyType = .done
        self.leftView = tempViewL
        self.leftViewMode = .always
        self.rightView = tempViewR
        self.rightViewMode = .always
        setupSpeech()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        tempViewL.frame = CGRect(x: self.frame.origin.x, y: 0, width: self.frame.height, height: self.frame.height)
        searchImageView.frame = CGRect(x: 12, y: 10, width: tempViewL.frame.width - 24, height: tempViewL.frame.height - 20)
        
        tempViewR.frame = CGRect(x: self.frame.width - self.frame.height, y: 0, width: self.frame.height, height: self.frame.height)
        btnSearch.frame = CGRect(x: 0, y: 2, width: tempViewR.frame.width, height: tempViewR.frame.height - 4)
        btnSearch.imageView?.contentMode = .scaleAspectFit
        btnSearch.imageEdgeInsets = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 4)
        btnSearch.setImage(searchBtnImage, for: .normal)
        
        searchImageView.contentMode = .scaleAspectFit
        tempViewL.addSubview(searchImageView)
        tempViewR.addSubview(btnSearch)
        
        self.layer.cornerRadius = frame.height / 2
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.black.cgColor
        
        self.layoutIfNeeded()
        self.layoutSubviews()
        self.updateConstraintsIfNeeded()
        
        let Device = UIDevice.current
        let iosVersion = NSString(string: Device.systemVersion).doubleValue
        
        let iOS10 = iosVersion >= 10
//        btnSearch.addTarget(self, action: #selector(voiceTapped(_:)), for: .touchUpInside)
        if !iOS10 {
            btnSearch.isHidden = true
            self.rightViewMode = .never
        }
    }
    
    @objc func didChangeValueOfSearch(_ sText: UITextField) {
        searchDelegate?.textFieldSearch(result: sText.text!)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.endEditing(true)
        return true
    }
    
    @objc func voiceTapped(_ sender: UIButton) {
        self.endEditing(true)
        
        if checkForSearchBtn {
            checkForSearchBtn = false
            stopRecognizing()
        } else {
            checkForSearchBtn = true
            
            let pulse = CASpringAnimation(keyPath: "transform.scale")
            pulse.duration = 0.6
            pulse.fromValue = 0.95
            pulse.toValue = 1.2
            pulse.autoreverses = true
            pulse.repeatCount = Float.infinity
            pulse.initialVelocity = 1.5
            pulse.damping = 3.0
            
            btnSearch.layer.add(pulse, forKey: "pulse")
            
            if audioEngine.isRunning {
                self.stopRecognizing()
            } else {
                self.startRecognizing()
            }
        }
        
        
        
    }
    
    
    func setupSpeech() {
        
        self.speechRecognizer?.delegate = self
        
        SFSpeechRecognizer.requestAuthorization { (authStatus) in
            DispatchQueue.main.async {
                if authStatus == .authorized {
                    //print("Good to go!")
                } else {
                    //print("Transcription permission was declined.")
                }
            }
        }
    }
    
    @objc func startRecognizing() {
        
        if self.recognitionTask != nil {
            self.recognitionTask?.cancel()
            self.recognitionTask = nil
            
        }
        
        self.recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        let inputNode = audioEngine.inputNode
        
        guard let recognitionRequest = recognitionRequest else {
            fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
        }
        self.recognitionTask = SFSpeechRecognitionTask()
        recognitionRequest.shouldReportPartialResults = true
        
        self.recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in
            
            var isFinal = false
            
            if result != nil {
                isFinal = !result!.isFinal
                if !isFinal {
                    self.text = result?.bestTranscription.formattedString
                    self.searchDelegate?.textFieldSearch(result: self.text!)
                    self.checkForSearchBtn = false
                    self.layoutIfNeeded()
                    self.layoutSubviews()
                    self.updateConstraintsIfNeeded()
                }
                self.stopRecognizing()
            }
            
            if error != nil || isFinal {
                
                inputNode.removeTap(onBus: 0)
                self.stopRecognizing()
            }
        })
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
            self.recognitionRequest?.append(buffer)
        }
        self.audioEngine.prepare()
        
        do {
            try self.audioEngine.start()
        } catch {
            print("audioEngine couldn't start because of an error.")
        }
    }
    
    func stopRecognizing() {
        if audioEngine.isRunning {
            audioEngine.stop()
            recognitionRequest?.endAudio()
            recognitionTask = nil
            recognitionRequest = nil
            btnSearch.layer.removeAnimation(forKey: "pulse")
        }
    }
    
}
