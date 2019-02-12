//import UIKit
//import AVFoundation
//
//class NEWRecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
//
//  var audioRecorder: AVAudioRecorder!
//  var recordingLabel: UILabel!
//  var recordButton: UIButton?
//  var stopRecordingButton: UIButton?
//
//  override func viewDidLoad() {
//    super.viewDidLoad()
//    view.backgroundColor = .white
//    configureUIComponent()
//
//    //    stopRecordingButton.isEnabled = false
//  }
//
//  //  func setupButton(_ enabled: Bool) {
//  //    stopRecordingButton.isEnabled = enabled
//  //    recordButton.isEnabled = !enabled
//  //  }
//
//  @objc func recordAudio(_ sender: UIButton) {
//    recordingLabel.text = "Recording in progress"
//    //    setupButton(true)
//
//    let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
//    let recordingName = "recordedVoice.wav"
//    let pathArray = [dirPath, recordingName]
//    let filePath = URL(string: pathArray.joined(separator: "/"))
//
//    let session = AVAudioSession.sharedInstance()
//    try! session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)
//
//    try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
//    audioRecorder.delegate = self
//    audioRecorder.isMeteringEnabled = true
//    audioRecorder.prepareToRecord()
//    audioRecorder.record()
//  }
//
//  @objc func stopRecording(_ sender: UIButton) {
//    //    setupButton(false)
//    recordingLabel.text = "Tap to Record"
//    audioRecorder.stop()
//    let audioSession = AVAudioSession.sharedInstance()
//    try! audioSession.setActive(false)
//  }
//
//  func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
//    if flag {
//      performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
//    } else {
//      print("not successful")
//    }
//  }
//
//  //  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//  //    if segue.identifier == "stopRecording" {
//  //      let playSoundsVC = segue.destination as! PlaySoundsViewController
//  //      let recordedAudioURL = sender as! URL
//  //      playSoundsVC.recordedAudioURL = recordedAudioURL
//  //    }
//  //  }
//
//
//
//  func configureUIComponent() {
//    makeButton()
//    makeLabel()
//  }
//
//
//  func makeButton() {
//
//    recordButton = UIButton(frame: CGRect(x: 0, y: 0, width: 64, height: 64))
//    recordButton?.addTarget(self, action: #selector(recordAudio), for: .touchUpInside)
//
//    let recordButtonImage = UIImage(named: "RecordButton")
//    recordButton?.setImage(recordButtonImage, for: .normal)
//
//
//    stopRecordingButton = UIButton(frame: CGRect(x: 100, y: 100, width: 40, height: 40))
//    stopRecordingButton?.addTarget(self, action: #selector(stopRecording), for: .touchUpInside)
//
//    guard let recordButton = recordButton, let stopRecordingButton = stopRecordingButton else { return }
//    self.view.addSubview(recordButton)
//    self.view.addSubview(stopRecordingButton)
//  }
//
//  func makeLabel() {
//    recordingLabel = UILabel(frame: CGRect(x: 200, y: 200, width: 200, height: 200))
//    recordingLabel?.textAlignment = NSTextAlignment.center
//
//    //    guard let recordingLabel = recordingLabel else { return }
//    self.view.addSubview(recordingLabel)
//  }
//
//}
