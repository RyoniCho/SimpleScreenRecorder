//
//  ScreenRecord.swift
//  SimpleScreenRecorder
//
//  Created by 조을연 on 2023/07/06.
//

import AVKit
import AVFoundation
import ReplayKit

//In App Recording (Replay Kit)
class ScreenRecordingManager: NSObject, RPScreenRecorderDelegate {
    var screenRecorder: RPScreenRecorder!
    var audioEngine: AVAudioEngine!
    var audioPlayerNode: AVAudioPlayerNode!
    var audioInputNode: AVAudioInputNode!
    var audioMixerNode: AVAudioMixerNode!
    var screenRecordingURL: URL?
    
    override init() {
        super.init()
        
        audioEngine = AVAudioEngine()
        audioPlayerNode = AVAudioPlayerNode()
        audioMixerNode = audioEngine.mainMixerNode
        
        screenRecorder = RPScreenRecorder.shared()
        screenRecorder.isMicrophoneEnabled = false // Disable microphone audio recording
       
        
        //setupAudioEngine()
    }
    
    func startRecording() {
        guard screenRecorder.isAvailable else {
            print("Screen recording is not available.")
            return
        }
        
//        do {
//            try AVAudioSession.sharedInstance().setCategory(.playback)
//            try AVAudioSession.sharedInstance().setActive(true)
//        } catch {
//            print("Failed to set up audio session: \(error.localizedDescription)")
//            return
//        }
        
        //startAudioEngine()
        
        screenRecorder.startRecording { [weak self] error in
            if let error = error {
                print("Failed to start screen recording: \(error.localizedDescription)")
            } else {
                print("Screen recording started.")
            }
        }
    }
    
   
    
    func stopRecording() {
            //stopAudioEngine()
        print("Stor recording -start")
        
        self.saveRecording()
            
//            screenRecorder.stopRecording { [weak self] previewViewController, error in
//                if let error = error {
//                    print("Failed to stop screen recording: \(error.localizedDescription)")
//                }
////                else if let previewViewController = previewViewController
////                {
////                    previewViewController.previewControllerDelegate = self
////                    self?.presentPreviewViewController(previewViewController)
////
////                }
//                else {
//                    print("save recording")
//                    self?.saveRecording()
//                }
//            }
        }
        
        func presentPreviewViewController(_ previewViewController: RPPreviewViewController) {
            // Present the preview view controller where you want to display the recording preview.
            // For example, you can present it modally:
            guard let rootViewController = NSApplication.shared.keyWindow?.contentViewController else {
                return
            }
            rootViewController.presentAsSheet(previewViewController)
        }
    // MARK: - Audio
    
    func setupAudioEngine() {
//        audioEngine.attach(audioPlayerNode)
//
//
//        audioInputNode = audioEngine.inputNode
//        let audioFormat = audioInputNode.inputFormat(forBus: 0)
//        audioEngine.connect(audioInputNode, to: audioMixerNode, format: audioFormat)
//
    }
    
    func startAudioEngine() {
        do {
            try audioEngine.start()
            audioPlayerNode.play()
        } catch {
            print("Failed to start audio engine: \(error.localizedDescription)")
        }
    }
    
    func stopAudioEngine() {
        audioPlayerNode.stop()
        audioEngine.stop()
        audioEngine.disconnectNodeOutput(audioInputNode)
    }
    func tempURL()->URL?
    {
        let directory=NSTemporaryDirectory() as NSString
        
        if directory != ""{
            let path = directory.appendingPathComponent(NSUUID().uuidString+".mp4")
            return URL(fileURLWithPath: path)
        }
        return nil
    }
    func saveRecording() {
        
        var outputURL=tempURL()
         screenRecorder.stopRecording(withOutput:outputURL!, completionHandler: { [weak self] error in
                if let error = error {
                    print("Failed to stop screen recording: \(error.localizedDescription)")
                } else {
                    print("Screen recording stopped.")
                    //self?.exportRecordingAsMP4()
                }
            })
          
//            {
//                print("Screen recording URL not found.")
//                return
//            }
//
            //self.screenRecordingURL = outputURL
        }
    
    func exportRecordingAsMP4() {
            guard let screenRecordingURL = screenRecordingURL else {
                print("Screen recording URL not found.")
                return
            }
            
            let outputURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("screenRecording.mp4")
            
            let asset = AVAsset(url: screenRecordingURL)
            let exporter = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetPassthrough)
            exporter?.outputURL = outputURL
            exporter?.outputFileType = .mp4
            
            exporter?.exportAsynchronously(completionHandler: { [weak self] in
                if let error = exporter?.error {
                    print("Failed to export screen recording as MP4: \(error.localizedDescription)")
                } else {
                    print("ScreenRecording exported as MP4: \(outputURL.absoluteString)")
                }
            })
        }
}
