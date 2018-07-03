import UIKit
import AVFoundation
import Speech

class DictadoVC: UIViewController, AVAudioRecorderDelegate {
    
    @IBOutlet weak var tiempo: UILabel!
    
    @IBOutlet weak var botonReconocer: UIButton!
    
    @IBOutlet weak var textoReconocido: UITextView!
    
    let player = AVQueuePlayer()
    var audioPlayer : AVAudioPlayer!
    var audioRecorder: AVAudioRecorder!
    var meterTimer:Timer!
    var isAudioRecordingGranted: Bool!
    
    var flagBotonReconocer = false
    
    let audioEngine = AVAudioEngine()
    let speechRecognizer: SFSpeechRecognizer? = SFSpeechRecognizer()
    let request = SFSpeechAudioBufferRecognitionRequest()
    var recognitionTask: SFSpeechRecognitionTask?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        botonReconocer.setTitle("Escuchar", for: .normal)
        switch AVAudioSession.sharedInstance().recordPermission() {
        case AVAudioSessionRecordPermission.granted:
            isAudioRecordingGranted = true
            break
        case AVAudioSessionRecordPermission.denied:
            isAudioRecordingGranted = false
            break
        case AVAudioSessionRecordPermission.undetermined:
            AVAudioSession.sharedInstance().requestRecordPermission() { [unowned self] allowed in
                DispatchQueue.main.async {
                    if allowed {
                        self.isAudioRecordingGranted = true
                    } else {
                        self.isAudioRecordingGranted = false
                    }
                }
            }
            break
        default:
            break
        }
    }
    
    func finishAudioRecording(success: Bool) {
        
        textoReconocido.text = "Procesando lo escuchado..."
        botonReconocer.isEnabled = false
        
        audioRecorder.stop()
        audioRecorder = nil
        meterTimer.invalidate()
        
        if success {
            print("Recording finished successfully.")
        } else {
            print("Recording failed :(")
        }
        let audioFilename = getDocumentsDirectory().appendingPathComponent("audioRecording.m4a")
        let recognizer = SFSpeechRecognizer.init(locale: Locale.init(identifier: "es_PE"))
        let request = SFSpeechURLRecognitionRequest(url: audioFilename)
        recognizer?.recognitionTask(with: request, resultHandler: { (result, error) in
            if let resultado = result?.bestTranscription.formattedString {
                self.textoReconocido.text = resultado
            } else if let mensajeError = error?.localizedDescription {
                switch mensajeError {
                case "Retry":
                    self.textoReconocido.text = "Error al reconocer lo escuchado, intente nuevamente"
                default:
                    self.textoReconocido.text = "Error: \(mensajeError)"
                }
                
                
            }
            self.botonReconocer.isEnabled = true
            self.botonReconocer.setTitle("Escuchar", for: .normal)
            //print (result?.bestTranscription.formattedString)
            //print (error?.localizedDescription)
        })
    }
    
    @objc func updateAudioMeter(timer: Timer) {
        
        if audioRecorder.isRecording {
            let hr = Int((audioRecorder.currentTime / 60) / 60)
            let min = Int(audioRecorder.currentTime / 60)
            let sec = Int(audioRecorder.currentTime.truncatingRemainder(dividingBy: 60))
            let totalTimeString = String(format: "%02d:%02d:%02d", hr, min, sec)
            //recordingTimeLabel.text = totalTimeString
            print(totalTimeString)
            tiempo.text = totalTimeString
            audioRecorder.updateMeters()
        }
    }
    
    func getDocumentsDirectory() -> URL {
        
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    //MARK:- Audio recoder delegate methods
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        
        if !flag {
            finishAudioRecording(success: false)
        }
    }
    
    @IBAction func clickEnBotonReconocer(_ sender: Any) {
        flagBotonReconocer = !flagBotonReconocer
        if flagBotonReconocer {
            //guard let node = audioEngine.inputNode else { return }
            let node = audioEngine.inputNode
            let recordingFormat = node.outputFormat(forBus: 0)
            node.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
                self.request.append(buffer)
            }
            
            // Prepare and start recording
            audioEngine.prepare()
            do {
                try audioEngine.start()
                //self.status = .recognizing
            } catch {
                return print(error)
            }
            
            // Analyze the speech
            recognitionTask = speechRecognizer?.recognitionTask(with: request, resultHandler: { result, error in
                if let result = result {
                    self.textoReconocido.text = "\(result.bestTranscription.formattedString)"
                    print(result.bestTranscription.formattedString)
                    //self.flightTextView.text = result.bestTranscription.formattedString
                    //self.searchFlight(number: result.bestTranscription.formattedString)
                } else if let error = error {
                    print(error)
                }
            })
            
            /*if isAudioRecordingGranted {
                
                //Create the session.
                let session = AVAudioSession.sharedInstance()
                
                do {
                    //Configure the session for recording and playback.
                    try session.setCategory(AVAudioSessionCategoryPlayAndRecord, with: .defaultToSpeaker)
                    try session.setActive(true)
                    //Set up a high-quality recording session.
                    let settings = [
                        AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                        AVSampleRateKey: 44100,
                        AVNumberOfChannelsKey: 2,
                        AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
                    ]
                    //Create audio file name URL
                    let audioFilename = getDocumentsDirectory().appendingPathComponent("audioRecording.m4a")
                    //Create the audio recording, and assign ourselves as the delegate
                    audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
                    audioRecorder.delegate = self
                    audioRecorder.isMeteringEnabled = true
                    
                    botonReconocer.setTitle("Detener", for: .normal)
                    textoReconocido.text = "Escuchando..."
                    
                    audioRecorder.record()
                    meterTimer = Timer.scheduledTimer(timeInterval: 0.1, target:self, selector:#selector(self.updateAudioMeter(timer:)), userInfo:nil, repeats:true)
                }
                catch let error {
                    print("Error for start audio recording: \(error.localizedDescription)")
                }
            }*/
        } else {
            //finishAudioRecording(success: true)
            audioEngine.stop()
            let node = audioEngine.inputNode
            node.removeTap(onBus: 0)
            recognitionTask?.cancel()
        }
    }
    
}
