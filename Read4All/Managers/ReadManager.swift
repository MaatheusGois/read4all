//
//  ReadManager.swift
//  Read4All
//
//  Created by Matheus Gois on 03/05/23.
//

import AVKit

final class ReadTextManager: NSObject, ObservableObject {

    @Published var synthesizer = AVSpeechSynthesizer()
    @Published var speechUtterance: AVSpeechUtterance?
    @Published var isSpeaking: Bool = false
    @Published var totalSpeak: Float = .init(DataStorage.lastText.count)
    @Published var currentSpeak: Float = .init(DataStorage.lastTime)

    override init() {
        super.init()
        synthesizer.delegate = self
    }

    func read(
        text: String
    ) {
        let text = text.getInRange(DataStorage.lastTime)
        speechUtterance = .init(string: text)
        speechUtterance?.rate = 1
        speechUtterance?.pitchMultiplier = 4
        speechUtterance?.voice = AVSpeechSynthesisVoice(language: "pt-BR")
        if let speechUtterance {
            synthesizer.stopSpeaking(at: .immediate)
            synthesizer.speak(speechUtterance)
            isSpeaking = true
        }
    }

    func toggle() {
        synthesizer.isSpeaking ? pause() : play()
    }

    func pause() {
        synthesizer.pauseSpeaking(at: .word)
        isSpeaking = false
    }

    func play() {
        synthesizer.continueSpeaking()
        isSpeaking = true
    }

    func stop() {
        pause()
        DataStorage.lastTime = .zero
        speechUtterance = nil
        synthesizer.stopSpeaking(at: .immediate)
    }

    func reset() {
        stop()
        totalSpeak = .init(DataStorage.lastText.count)
        currentSpeak = .init(DataStorage.lastTime)
    }

    func volume(_ volume: Float) {
        speechUtterance?.volume = volume
    }
}

extension ReadTextManager: AVSpeechSynthesizerDelegate {
    func speechSynthesizer(
        _ synthesizer: AVSpeechSynthesizer,
        willSpeakRangeOfSpeechString characterRange: NSRange,
        utterance: AVSpeechUtterance
    ) {
        DataStorage.lastTime += 1
    }
}

extension String {
    var count: Int { split(separator: " ").count }

    func getInRange(_ range: Int) -> Self {
        var array = split(separator: " ").map { String($0) }
        array = Array(array[range..<array.count])
        return array.joined(separator: " ")
    }
}
