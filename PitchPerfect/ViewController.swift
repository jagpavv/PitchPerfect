import UIKit

class ViewController: UIViewController {

  @IBOutlet weak var recordingLabel: UILabel!
  @IBOutlet weak var recordButton: UIButton!
  @IBOutlet weak var stopRecordingButton: UIButton!

  override func viewDidLoad() {
    super.viewDidLoad()
    stopRecordingButton.isEnabled = false
  }

  @IBAction func recordAudio(_ sender: UIButton) {
    recordButton.isEnabled = false
    stopRecordingButton.isEnabled = true
    recordingLabel.text = "Recording in Progress"
  }

  @IBAction func stopRecording(_ sender: UIButton) {
    recordButton.isEnabled = true
    stopRecordingButton.isEnabled = false
    recordingLabel.text = "Tap to Record"
  }
  
}

