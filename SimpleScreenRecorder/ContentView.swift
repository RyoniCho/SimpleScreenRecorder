//
//  ContentView.swift
//  SimpleScreenRecorder
//
//  Created by 조을연 on 2023/07/06.
//

import SwiftUI

struct ContentView: View {
    
    var manager : ScreenRecordingManager2
    var body: some View {
        
        
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
            Button(action:
            {
                print("Start Session")
                manager.startSession()
                
                
            },label:{Text("START SESSION")})
            
            Button(action:
            {
                print("stop Session")
                manager.stopSession()
                
                
            },label:{Text("STOP SESSION")})
            
            Button(action:
            {
                print("Start Recording Action")
                manager.startRecording()
                
                
            },label:{Text("START")})
            Button(action:
            {
                print("stop Recording Action")
                manager.stopRecording()
                
                
            },label:{Text("STOP")})
           
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(manager:ScreenRecordingManager2())
    }
}
