import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {

  // MARK: Outlets
  @IBOutlet weak var slowButton: UIButton!
  @IBOutlet weak var highPitchButton: UIButton!
  @IBOutlet weak var fastButton: UIButton!
  @IBOutlet weak var lowPitchButton: UIButton!
  @IBOutlet weak var echoButton: UIButton!
  @IBOutlet weak var reverbButton: UIButton!
  @IBOutlet weak var stopButton: UIButton!

  var recordedAudioURL: AVAudioRecorder! {
    didSet {
      print("recordedAudioURL: \(recordedAudioURL)")
    }
  }
  var audioFile: AVAudioFile! {
    didSet {
      print("audioFile: \(audioFile)")
    }
  }
  var audioEngine: AVAudioEngine! {
    didSet {
      print("audioEngine: \(audioEngine)")
    }
  }
  var audioPlayerNode: AVAudioPlayerNode! {
    didSet {
      print("audioPlayerNode: \(audioPlayerNode)")
    }
  }
  var stopTimer: Timer! {
    didSet {
      print("stopTimer: \(stopTimer)")
    }
  }

  enum ButtonType: Int {
    case slow = 0, fast, chipmunk, vader, echo, reverb
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    setupAudio()
//    playSound()

  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
//    playSound()
    configureUI(.notPlaying)
//    playSound()
  }

  // MARK: Actions
  @IBAction func playSoundForButton(_ sender: UIButton) {
    print(sender.tag)
    switch(ButtonType(rawValue: sender.tag)!) {
    case .slow:
      playSound(rate: 0.5)
    case .fast:
      playSound(rate: 1.5)
    case .chipmunk:
      playSound(pitch: 1000)
    case .vader:
      playSound(pitch: -1000)
    case .echo:
      playSound(echo: true)
    case .reverb:
      playSound(reverb: true)
    }
//    setupAudio()
//    playSound()

    configureUI(.playing)
  }

  @IBAction func stopButtonPressed(_ sender: AnyObject) {
    stopAudio()
  }
}
