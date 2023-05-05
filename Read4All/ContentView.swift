//
//  ContentView.swift
//  Read4All
//
//  Created by Matheus Gois on 03/05/23.
//

import SwiftUI
import Foundation

struct ContentView: View {

    @StateObject var manager = ReadTextManager()

    @State var text = DataStorage.lastText

    @State private var showingAlert = false
    @State private var textSelected = false

    var body: some View {
        VStack {
            #if !os(tvOS)
            TextEditor(text: $text).onChange(of: text) { _ in
                DataStorage.lastText = text
                manager.reset()
            }
            .onReceive(NotificationCenter.default.publisher(for: NSTextView.didChangeSelectionNotification)) { obj in
                guard !textSelected else { return }
                if let textView = obj.object as? NSTextView {
                    manager.textView = textView
                    manager.hasSelectedNew = true
                    manager.setTime(textView.selectedRange().location)
                    manager.read(text: text)
                    textSelected = true
                }
            }
            #endif

            ProgressView(value: manager.currentSpeak, total: manager.totalSpeak)

            HStack {
                Button {
                    if manager.isSpeaking {
                        showingAlert = true
                    } else {
                        manager.read(text: text)
                    }
                } label: {
                    Text(manager.isSpeaking ? "Stop" : "Read")
                }.alert(
                    "Do you really want stop and reset the read?",
                    isPresented: $showingAlert
                ) {
                    Button("Reset", role: .destructive) {
                        manager.stop()
                        textSelected = false
                    }
                }

                Spacer()

                #if !os(tvOS)
                Slider(value: $manager.speed, in: 0...1) {
                    Text("Spped")
                }
                #endif
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
