import UIKit
import AVFoundation

protocol recordedAudioURLDelegate {
  var recordedAudioURL: URL? { get }
}

class PlaySoundsViewController: UIViewController {
//
//  // MARK: Outlets
//  @IBOutlet weak var slowButton: UIButton!
//  @IBOutlet weak var highPitchButton: UIButton!
//  @IBOutlet weak var fastButton: UIButton!
//  @IBOutlet weak var lowPitchButton: UIButton!
//  @IBOutlet weak var echoButton: UIButton!
//  @IBOutlet weak var reverbButton: UIButton!
//  @IBOutlet weak var stopButton: UIButton!
//

//  var recordedAudioURL: URL!
//  var audioFile: AVAudioFile!
//  var audioEngine: AVAudioEngine!
//  var audioPlayerNode: AVAudioPlayerNode!
//  var stopTimer: Timer!

  var delegate: recordedAudioURLDelegate?

//  enum ButtonType: Int {
//    case slow = 0, fast, highPitch, lowPitch, reverb, echo
//  }
//
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white

//    setupAudio()
  }
//
//  override func viewWillAppear(_ animated: Bool) {
//    super.viewWillAppear(animated)
//    configureUI(.notPlaying)
//  }
//
//  // MARK: Actions
//  @IBAction func playSoundForButton(_ sender: UIButton) {
//    print(sender.tag)
//    switch(ButtonType(rawValue: sender.tag)!) {
//    case .slow:
//      playSound(rate: 0.5)
//    case .fast:
//      playSound(rate: 1.5)
//    case .highPitch:
//      playSound(pitch: 1000)
//    case .lowPitch:
//      playSound(pitch: -1000)
//    case .echo:
//      playSound(echo: true)
//    case .reverb:
//      playSound(reverb: true)
//    }
//    configureUI(.playing)
//  }
//
//  @IBAction func stopButtonPressed(_ sender: AnyObject) {
//    stopAudio()
//  }
}
