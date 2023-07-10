//
//  ScreenRecord2.swift
//  SimpleScreenRecorder
//
//  Created by 조을연 on 2023/07/06.
//

import AVFoundation

class ScreenRecordingManager2: NSObject, AVCaptureFileOutputRecordingDelegate {
    var session: AVCaptureSession!
    var movieFileOutput: AVCaptureMovieFileOutput!
 
   
    var recordingURL: URL?
    
    override init() {
        super.init()
        
        session = AVCaptureSession()
        movieFileOutput = AVCaptureMovieFileOutput()
      
            
        if session.canAddOutput(movieFileOutput) {
            session.addOutput(movieFileOutput)
        }
        
        // Configure the audio capture device and input (Soundflower)
        guard let audioDeviceUID = getBlackholeDeviceUID() else {
            print("Failed to get blackhole device UID.")
            return
        }
        
        if let audioInput = createAudioDeviceInput(with: audioDeviceUID)
        {
            if session.canAddInput(audioInput) {
                session.addInput(audioInput)
            }
        }
        else
        {
            print("Create Audio Input Failed ")
        }
       
        // Configure the capture device and input
        let displayID:CGDirectDisplayID = CGMainDisplayID()
        
        if let input = AVCaptureScreenInput(displayID: displayID)
        {
            if session.canAddInput(input)
            {
                session.addInput(input)
            }
        }
        else
        {
            print("Failed to create screen input.")
            return
        }
        
        
       
        
        print("Initialize complete")
        
    }
    
    // Helper method to get the Soundflower device UID
    func getBlackholeDeviceUID() -> String? {

        let devices = AVCaptureDevice.devices()
        
        print("capture Devices: \(devices)")
        
        
        let blackholeDevices = AVCaptureDevice.devices(for: .audio).filter { device in
            device.localizedName.contains("BlackHole")
        }
        
        return blackholeDevices.first?.uniqueID
    }
    
    // Helper method to create an AVCaptureDeviceInput for the Soundflower device
    func createAudioDeviceInput(with deviceUID: String) -> AVCaptureDeviceInput? {
        if let audioDevice = AVCaptureDevice(uniqueID: deviceUID) {
            do {
                return try AVCaptureDeviceInput(device: audioDevice)
            } catch {
                print("Failed to create audio input: \(error.localizedDescription)")
            }
        }
        return nil
    }
    
    func startSession()
    {
        session.startRunning()
        
    }
    
    func stopSession()
    {
        session.stopRunning()
    }
    
   
    
    func startRecording() {
        print("START RECORD")
        
        guard let connection = movieFileOutput.connection(with: .video) else {
            print("Failed to get a valid connection.")
            return
        }
        
        if !connection.isActive || !connection.isEnabled {
            print("Video connection is not active or enabled.")
            return
        }
        
        guard let audioConnection = movieFileOutput.connection(with: .audio) else {
            print("Failed to get a audio valid connection.")
            return
        }
        
        if !audioConnection.isActive || !audioConnection.isEnabled {
            print("Audio connection is not active or enabled.")
            return
        }
        
        //let outputURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(NSUUID().uuidString+".mp4")
        
        let outputURL =  getDownloadDirectory().appendingPathComponent(NSUUID().uuidString+".mp4")
        
        print("outputURL:\(outputURL)")
        movieFileOutput.startRecording(to: outputURL, recordingDelegate: self)
        }
    
    func stopRecording() {
        print("STOP RECORD")
        movieFileOutput.stopRecording()
    }
    

    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        print("fileOutput")
        if let error = error {
            print("Failed to stop screen recording: \(error.localizedDescription)")
            print(error)
        } else {
            print("Screen recording stopped.")
         
        }
    }
    
    func getDownloadDirectory() -> URL {
        let paths = FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        print("paths[0]:\(paths[0])")
        return documentsDirectory
    }

    
    
}





