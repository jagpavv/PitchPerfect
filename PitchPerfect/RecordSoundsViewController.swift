import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

  var audioRecorder: AVAudioRecorder!
  var recordingLabel: UILabel!
  var recordButton: UIButton!
  var stopRecordingButton: UIButton!
  var isRecording = false
  var url: URL?

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    makeButton()
    setupButtons(isRecording)
  }

    func setupButtons(_ enabled: Bool) {
      if enabled {
        recordingLabel.text = "Recording in progress"
      } else {
        recordingLabel.text = "Tap to Record"
      }
      stopRecordingButton.isEnabled = enabled
      recordButton.isEnabled = !enabled
    }

  @objc func recordAudio(_ sender: UIButton) {
    isRecording = true
    setupButtons(isRecording)

    let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
    let recordingName = "recordedVoice.wav"
    let pathArray = [dirPath, recordingName]
    let filePath = URL(string: pathArray.joined(separator: "/"))

    let session = AVAudioSession.sharedInstance()
    try! session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)

    try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
    audioRecorder.delegate = self
    audioRecorder.isMeteringEnabled = true
    audioRecorder.prepareToRecord()
    audioRecorder.record()
  }

  @objc func stopRecording(_ sender: UIButton) {
    isRecording = true
    setupButtons(isRecording)

    audioRecorder.stop()
    let audioSession = AVAudioSession.sharedInstance()
    try! audioSession.setActive(false)
  }

  func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
    if flag {
      let PlaySoundsVC = PlaySoundsViewController()
      PlaySoundsVC.delegate = self
      url = audioRecorder.url
      navigationController?.pushViewController(PlaySoundsVC, animated: true)
    } else {
      print("not successful")
    }
  }

  func makeButton() {
    let recordButton = UIButton()
    recordButton.addTarget(self, action: #selector(recordAudio), for: .touchUpInside)
    let recordButtonImage = UIImage(named: "Record")
    recordButton.setImage(recordButtonImage, for: .normal)
    self.view.addSubview(recordButton)

    let recordingLabel = UILabel()
    recordingLabel.textAlignment = NSTextAlignment.center
    recordingLabel.text = "Tap to record"
    recordingLabel.sizeToFit()
    self.view.addSubview(recordingLabel)

    let stopRecordingButton = UIButton()
    stopRecordingButton.addTarget(self, action: #selector(stopRecording), for: .touchUpInside)
    let stopRecordingButtonImage = UIImage(named: "Stop")
    stopRecordingButton.setImage(stopRecordingButtonImage, for: .normal)
    self.view.addSubview(stopRecordingButton)

    recordButton.translatesAutoresizingMaskIntoConstraints = false
    recordButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
    recordButton.heightAnchor.constraint(equalToConstant: 100).isActive = true
    recordButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
    recordButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
    self.recordButton = recordButton

    recordingLabel.translatesAutoresizingMaskIntoConstraints = false
    recordingLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 100).isActive = true
    recordingLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
    recordingLabel.centerXAnchor.constraint(equalTo: recordButton.centerXAnchor).isActive = true
    recordingLabel.centerYAnchor.constraint(equalTo: recordButton.bottomAnchor, constant: 8).isActive = true
    self.recordingLabel = recordingLabel

    stopRecordingButton.translatesAutoresizingMaskIntoConstraints = false
    stopRecordingButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
    stopRecordingButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    stopRecordingButton.centerXAnchor.constraint(equalTo: recordingLabel.centerXAnchor).isActive = true
    stopRecordingButton.centerYAnchor.constraint(equalTo: recordingLabel.lastBaselineAnchor, constant: 16).isActive = true
    self.stopRecordingButton = stopRecordingButton
  }
}

// MARK: - recordedAudioURLDelegate
extension RecordSoundsViewController: recordedAudioURLDelegate {
  var recordedAudioURL: URL? {
    return url
  }
}
