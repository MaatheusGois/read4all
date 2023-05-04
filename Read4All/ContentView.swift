//
//  ContentView.swift
//  Read4All
//
//  Created by Matheus Gois on 03/05/23.
//

import SwiftUI
import Foundation

struct ContentView: View {

    @ObservedObject var manager = ReadTextManager()

    @State var text = DataStorage.lastText
    @State var volume: Float = 0

    var body: some View {
        VStack {
            TextEditor(text: $text).onChange(of: text) { _ in
                DataStorage.lastText = text
                manager.reset()
            }

            ProgressView(value: manager.currentSpeak, total: manager.totalSpeak)

            HStack {
                Button {
                    if manager.isSpeaking {
                        manager.stop()
                    } else {
                        manager.read(text: text)
                        manager.volume(volume)
                    }
                } label: {
                    Text(manager.isSpeaking ? "Stop" : "Read")
                }

                Spacer()

                if manager.speechUtterance != nil {
                    Button {
                        manager.toggle()
                    } label: {
                        Text(manager.isSpeaking ? "Pause" : "Play")
                    }
                }
            }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
