import UIKit
import AVFoundation

protocol recordedAudioURLDelegate {
  var recordedAudioURL: URL { get }
}

class PlaySoundsViewController: UIViewController {

  // MARK: Outlets
  var slowButton: UIButton!
  var fastButton: UIButton!

  var highPitchButton: UIButton!
  var lowPitchButton: UIButton!
  var echoButton: UIButton!
  var reverbButton: UIButton!
  var stopButton: UIButton!

  var recordedAudioURL: URL!
  var audioFile: AVAudioFile!
  var audioEngine: AVAudioEngine!
  var audioPlayerNode: AVAudioPlayerNode!
  var stopTimer: Timer!
  var delegate: recordedAudioURLDelegate?

  enum ButtonType: Int {
    case slow = 0, fast, highPitch, lowPitch, reverb, echo
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    recordedAudioURL = delegate?.recordedAudioURL
    makePlayButtons()
    setupAudio()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    configureUI(.notPlaying)
  }

  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    stopAudio()
  }

  // MARK: Actions
  @objc func playSoundForButton(_ sender: UIButton) {
    print(sender.tag)
    switch(ButtonType(rawValue: sender.tag)!) {
    case .slow:
      playSound(rate: 0.5)
    case .fast:
      playSound(rate: 1.5)
    case .highPitch:
      playSound(pitch: 1000)
    case .lowPitch:
      playSound(pitch: -1000)
    case .echo:
      playSound(echo: true)
    case .reverb:
      playSound(reverb: true)
    }
    configureUI(.playing)
  }

  @objc func stopButtonPressed(_ sender: UIButton) {
    stopAudio()
  }

  func settingButtons(button: UIButton, imageName: String, tagId: Int) {
    button.addTarget(self, action: #selector(playSoundForButton), for: .touchUpInside)
    let image = UIImage(named: "\(imageName)")
    button.setImage(image, for: .normal)
    button.tag = tagId
  }

  func makePlayButtons() {
    let slowButton = UIButton()
    let fastButton = UIButton()
    let highPitchButton = UIButton()
    let lowPitchButton = UIButton()
    let echoButton = UIButton()
    let reverbButton = UIButton()
    let stopButton = UIButton()

    stopButton.addTarget(self, action: #selector(stopButtonPressed), for: .touchUpInside)
    let stopButtonImage = UIImage(named: "Stop")
    stopButton.setImage(stopButtonImage, for: .normal)
    stopButton.tag = 5
    self.view.addSubview(stopButton)

    stopButton.translatesAutoresizingMaskIntoConstraints = false
    stopButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
    stopButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    stopButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
    stopButton.centerYAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -60).isActive = true
    self.stopButton = stopButton


    // stackview
    let baseStackView = UIStackView()
    baseStackView.axis = NSLayoutConstraint.Axis.vertical
    baseStackView.distribution = UIStackView.Distribution.fillEqually
    baseStackView.spacing = 0
    self.view.addSubview(baseStackView)

    baseStackView.translatesAutoresizingMaskIntoConstraints = false
    baseStackView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
    baseStackView.bottomAnchor.constraint(equalTo: stopButton.topAnchor).isActive = true

    baseStackView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
    baseStackView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true

    let stackViewOne = UIStackView()
    stackViewOne.axis = NSLayoutConstraint.Axis.horizontal
    stackViewOne.alignment = UIStackView.Alignment.fill
    stackViewOne.distribution = UIStackView.Distribution.fillEqually
    stackViewOne.spacing = 0
    baseStackView.addArrangedSubview(stackViewOne)

    let stackViewTwo = UIStackView()
    stackViewTwo.axis = NSLayoutConstraint.Axis.horizontal
    stackViewTwo.alignment = UIStackView.Alignment.fill
    stackViewTwo.distribution = UIStackView.Distribution.fillEqually
    stackViewTwo.spacing = 0
    baseStackView.addArrangedSubview(stackViewTwo)

    let stackViewThree = UIStackView()
    stackViewThree.axis = NSLayoutConstraint.Axis.horizontal
    stackViewThree.alignment = UIStackView.Alignment.fill
    stackViewThree.distribution = UIStackView.Distribution.fillEqually
    stackViewThree.spacing = 0
    baseStackView.addArrangedSubview(stackViewThree)


    // buttons
    settingButtons(button: slowButton, imageName: "Slow", tagId: 0)
    stackViewOne.addArrangedSubview(slowButton)
    self.slowButton = slowButton

    settingButtons(button: fastButton, imageName: "Fast", tagId: 1)
    stackViewOne.addArrangedSubview(fastButton)
    self.fastButton = fastButton

    settingButtons(button: highPitchButton, imageName: "HighPitch", tagId: 2)
    stackViewTwo.addArrangedSubview(highPitchButton)
    self.highPitchButton = highPitchButton

    settingButtons(button: lowPitchButton, imageName: "LowPitch", tagId: 3)
    stackViewTwo.addArrangedSubview(lowPitchButton)
    self.lowPitchButton = lowPitchButton

    settingButtons(button: echoButton, imageName: "Echo", tagId: 4)
    stackViewThree.addArrangedSubview(echoButton)
    self.echoButton = echoButton

    settingButtons(button: reverbButton, imageName: "Reverb", tagId: 5)
    stackViewThree.addArrangedSubview(reverbButton)
    self.reverbButton = reverbButton
  }
}
