import UIKit
import AVFoundation

// MARK: - PlaySoundsViewController: AVAudioPlayerDelegate

extension PlaySoundsViewController: AVAudioPlayerDelegate {

  // MARK: Alerts
  struct Alerts {
    static let DismissAlert = "Dismiss"
    static let RecordingDisabledTitle = "Recording Disabled"
    static let RecordingDisabledMessage = "You've disabled this app from recording your microphone. Check Settings."
    static let RecordingFailedTitle = "Recording Failed"
    static let RecordingFailedMessage = "Something went wrong with your recording."
    static let AudioRecorderError = "Audio Recorder Error"
    static let AudioSessionError = "Audio Session Error"
    static let AudioRecordingError = "Audio Recording Error"
    static let AudioFileError = "Audio File Error"
    static let AudioEngineError = "Audio Engine Error"
  }

  // MARK: PlayingState (raw values correspond to sender tags)
  enum PlayingState { case playing, notPlaying }

  // MARK: Audio Functions
  func setupAudio() {
    // initialize (recording) audio file
    do {
      audioFile = try AVAudioFile(forReading: recordedAudioURL.url as URL)
    } catch {
      showAlert(Alerts.AudioFileError, message: String(describing: error))
    }
  }

  func playSound(rate: Float? = nil, pitch: Float? = nil, echo: Bool = false, reverb: Bool = false) {
print("recordedAudioURL : \(String(describing: recordedAudioURL))")
    // initialize audio engine components
    audioEngine = AVAudioEngine()

    // node for playing audio
    audioPlayerNode = AVAudioPlayerNode()
    audioEngine.attach(audioPlayerNode)

    // node for adjusting rate/pitch
    let changeRatePitchNode = AVAudioUnitTimePitch()
    if let pitch = pitch {
      changeRatePitchNode.pitch = pitch
    }
    if let rate = rate {
      changeRatePitchNode.rate = rate
    }
    audioEngine.attach(changeRatePitchNode)

    // node for echo
    let echoNode = AVAudioUnitDistortion()
    echoNode.loadFactoryPreset(.multiEcho1)
    audioEngine.attach(echoNode)

    // node for reverb
    let reverbNode = AVAudioUnitReverb()
    reverbNode.loadFactoryPreset(.cathedral)
    reverbNode.wetDryMix = 50
    audioEngine.attach(reverbNode)

    // connect nodes
    if echo == true && reverb == true {
      connectAudioNodes(audioPlayerNode, changeRatePitchNode, echoNode, reverbNode, audioEngine.outputNode)
    } else if echo == true {
      connectAudioNodes(audioPlayerNode, changeRatePitchNode, echoNode, audioEngine.outputNode)
    } else if reverb == true {
      connectAudioNodes(audioPlayerNode, changeRatePitchNode, reverbNode, audioEngine.outputNode)
    } else {
      connectAudioNodes(audioPlayerNode, changeRatePitchNode, audioEngine.outputNode)
    }



//    AVAudioFile *file = [[AVAudioFile alloc] initForReading:_fileURL commonFormat:AVAudioPCMFormatFloat32 interleaved:NO error:nil];
//    AVAudioPCMBuffer *buffer = [[AVAudioPCMBuffer alloc] initWithPCMFormat:file.processingFormat frameCapacity:(AVAudioFrameCount)file.length];
//    [file readIntoBuffer:buffer error:&error];
//
//    [_player scheduleBuffer:buffer atTime:nil options:AVAudioPlayerNodeBufferInterrupts completionHandler:^{
//      // reminder: we're not on the main thread in here
//      dispatch_async(dispatch_get_main_queue(), ^{
//      NSLog(@"done playing, as expected!");
//      });
//      }];

    guard let buffer = AVAudioPCMBuffer(pcmFormat: audioFile!.processingFormat, frameCapacity: AVAudioFrameCount(audioFile!.length)) else {
      print("NO")
      return
    }

    do {
      try audioFile.read(into: buffer)
    } catch {
      showAlert(Alerts.AudioFileError, message: String(describing: error))
    }

    // schedule to play and start the engine!
    audioPlayerNode.stop()
    audioPlayerNode.scheduleBuffer(buffer,
                                   at: nil,
                                   options: [.interrupts],
                                   completionCallbackType: .dataPlayedBack,
                                   completionHandler: { (type) in

      var delayInSeconds: Double = 0

      if let lastRenderTime = self.audioPlayerNode.lastRenderTime, let playerTime = self.audioPlayerNode.playerTime(forNodeTime: lastRenderTime) {

        if let rate = rate {
          delayInSeconds = Double(self.audioFile.length - playerTime.sampleTime) / Double(self.audioFile.processingFormat.sampleRate) / Double(rate)
        } else {
          delayInSeconds = Double(self.audioFile.length - playerTime.sampleTime) / Double(self.audioFile.processingFormat.sampleRate)
        }
      }

      print("delay: \(delayInSeconds)")

      // schedule a stop timer for when audio finishes playing
      self.stopTimer = Timer(timeInterval: delayInSeconds, target: self, selector: #selector(PlaySoundsViewController.stopAudio), userInfo: nil, repeats: false)
      RunLoop.main.add(self.stopTimer!, forMode: RunLoop.Mode.default)
    })

    do {
      try audioEngine.start()
    } catch {
      showAlert(Alerts.AudioEngineError, message: String(describing: error))
      return
    }

    // play the recording!
    print("play")

    audioPlayerNode.play()
  }

  @objc func stopAudio() {

    if let audioPlayerNode = audioPlayerNode {
      audioPlayerNode.stop()
      print("stop")
    }

    if let stopTimer = stopTimer {
      stopTimer.invalidate()
      print("invalidate")
    }

    configureUI(.notPlaying)

    if let audioEngine = audioEngine {
      audioEngine.stop()
      audioEngine.reset()
      print("reset")

    }
  }

  // MARK: Connect List of Audio Nodes
  func connectAudioNodes(_ nodes: AVAudioNode...) {
    for x in 0..<nodes.count-1 {
      audioEngine.connect(nodes[x], to: nodes[x+1], format: audioFile.processingFormat)
    }
  }

  // MARK: UI Functions
  func configureUI(_ playState: PlayingState) {
    switch(playState) {
    case .playing:
      setPlayButtonsEnabled(false)
      stopButton.isEnabled = true
    case .notPlaying:
      setPlayButtonsEnabled(true)
      stopButton.isEnabled = false
    }
  }

  func setPlayButtonsEnabled(_ enabled: Bool) {
    slowButton.isEnabled = enabled
    highPitchButton.isEnabled = enabled
    fastButton.isEnabled = enabled
    lowPitchButton.isEnabled = enabled
    echoButton.isEnabled = enabled
    reverbButton.isEnabled = enabled
  }

  func showAlert(_ title: String, message: String) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: Alerts.DismissAlert, style: .default, handler: nil))
    self.present(alert, animated: true, completion: nil)
  }
}
