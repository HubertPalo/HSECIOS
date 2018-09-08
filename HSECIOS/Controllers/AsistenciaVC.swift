
import UIKit
import AVFoundation
//import CoreNFC

class AsistenciaVC: UIViewController, UITabBarDelegate, UITableViewDelegate, UITableViewDataSource /*, NFCNDEFReaderSessionDelegate*/ {
    //var nfcSession: NFCNDEFReaderSession?
    var codCurso = ""
    var indiceF = ""
    //var fechaPart = ""
    var dataFechaCod = [String]()
    var dataFechaDes = [String]()
    var Asistentes: [Persona] = []
    var linEnable: Bool = false
    var soundEnable: Bool = true
    var player: AVAudioPlayer?
    var activeScan = true
    var ControlCam = ScannerVC()
    var a = 0
    
    @IBOutlet weak var btnSound: UIButton!
    @IBOutlet weak var TablAsistencia: UITableView!
    
    @IBOutlet weak var btnLinterna: UIButton!
    
    @IBOutlet weak var VerScan: UIButton!
    @IBOutlet weak var btnFecha: UIButton!
    
    @IBOutlet weak var ContBarCode: UIView!
    
    @IBOutlet weak var barSubTitle: UIView!
    
    @IBOutlet weak var barTitleView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Utils.setTitleAndImage2(self,"Capacitación/Curso/Asistencia", UIImage(named: "cursos-1"))
        self.ControlCam = self.childViewControllers[0] as! ScannerVC
        LoadData(indiceF)
        Utils.asistenciaVC = self
        self.TablAsistencia.delegate=self
        self.TablAsistencia.dataSource=self
        print("\(codCurso) - Asistencia")
        print("\(indiceF) - Asist fecha")
        print("\(dataFechaDes[0]) - descripcion")
        print("\(dataFechaCod[0]) - descripcion")
        
    }
    
    func LoadData(_ fecha: String) {
        
        //self.btnFecha.setTitle(dataFechaDes[0], for: .normal)
        self.btnFecha.setTitle(dataFechaDes[dataFechaCod.index(of: indiceF)!], for: .normal)
        self.btnFecha.isEnabled = dataFechaDes.count > 1
        
        //(_ codeC: String, _ fecha: String, _ pageNo: Int, _ elemsPP: Int)
        Rest.getDataGeneral(Routes.forAsistentesT(codCurso, fecha, 1, 14), true, success: {(resultValue:Any?,data:Data?) in
            // let planes = Dict.toArrayPlanAccionPendiente(dict)
            let asisCurso: ArrayGeneral<Persona> = Dict.dataToArray(data!)
            //self.textoSinOcurrencias.text = "No hubo ocurrencias"
            //self.TablaCap.isHidden = cursos.Data.count <= 0
            
            if asisCurso.Data.count > 0 {
                self.Asistentes = asisCurso.Data
                self.TablAsistencia.reloadData()
            } else {
                self.Asistentes = asisCurso.Data
                self.TablAsistencia.reloadData()
            }
        }, error: nil)
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return Asistentes.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celdaT = tableView.dequeueReusableCell(withIdentifier: "userasist") as! AsistenciaViewCell
        let unit = Asistentes[indexPath.row]
        celdaT.nombre.text = unit.Nombres
        celdaT.cargo.text = "\(unit.Cargo!) "
        celdaT.btn_eliminar.tag = indexPath.row
        //celdaT.Nombre.text = unit.Nombres
        /*if unit.Cargo == ""{celdaT.Cargo.text = " "} else { celdaT.Cargo.text = unit.Cargo}
         
         celdaT.NotaCurso.text = unit.Email
         */
        
        return celdaT
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        
        self.presentAlert2(nil, "Hora de ingreso: \(Asistentes[indexPath.row].Email!)", .actionSheet, 2, nil, [], [], actionHandlers: [])
        
        
        
        /*
         let popup = Tabs.sb.instantiateViewController(withIdentifier: "NotaEditPopup") as! NotaEditPopupVC
         popup.modalPresentationStyle = .overCurrentContext
         //popup.dataPersona = cursoNotas[indexPath.row]
         popup.cursoNotas = cursoNotas
         popup.position = indexPath.row
         popup.codCurso = codCurso
         self.present(popup, animated: true, completion: nil)
         */
        
    }
    
    
    
    @IBAction func eliminarA(_ sender: Any) {
        let position = (sender as! UIButton).tag
        self.presentAlert("Eliminar participante", "Estas seguro de eliminar al participante \(String(describing: Asistentes[position].Nombres!))", .alert, nil, Images.alertaAmarilla, ["Cancelar", "Aceptar"], [.cancel, .default], actionHandlers: [ {(alertaCancelar) in
            print("Esto ocurre al presionar cancelar")
            
            }, {(alertAceptar) in
                print("Esto ocurre al presionar aceptar")
                print(Routes.forDeleteA(self.Asistentes[position].CodPersona!, self.codCurso, self.indiceF))
                
                
                Rest.getDataGeneral(Routes.forDeleteA(self.Asistentes[position].CodPersona!, self.codCurso, self.indiceF), true, success: {(resultValue:Any?,data:Data?) in
                    let str = resultValue as! String
                    print(str)
                    
                    self.LoadData(self.indiceF)
                    
                }, error: nil)
            }, {(alertaEliminar) in
                print("Esto ocurre al presionar eliminar")
            }])
        
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let currentOffset = scrollView.contentOffset.y
        if currentOffset <= -14 {
            //self.alScrollLimiteTop?()
            let cantidad = self.Asistentes.count > 14 ? self.Asistentes.count : 14
            
            Rest.getDataGeneral(Routes.forAsistentesT(codCurso, indiceF, 1, 14), true, success: {(resultValue:Any?,data:Data?) in
                // let planes = Dict.toArrayPlanAccionPendiente(dict)
                let asisCurso: ArrayGeneral<Persona> = Dict.dataToArray(data!)
                //self.textoSinOcurrencias.text = "No hubo ocurrencias"
                //self.TablaCap.isHidden = cursos.Data.count <= 0
                
                if asisCurso.Data.count > 0 {
                    self.Asistentes = asisCurso.Data
                    self.TablAsistencia.reloadData()
                }
            }, error: nil)
            
        } else {
            let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
            if maximumOffset - currentOffset <= -14 {
                //self.alScrollLimiteBot?()
                
                var pagina = self.Asistentes.count / 14
                if self.Asistentes.count % 14 == 0 {
                    pagina = pagina + 1
                }
                Rest.getDataGeneral(Routes.forAsistentesT(codCurso, indiceF, pagina, 14), true, success: {(resultValue:Any?,data:Data?) in
                    // let planes = Dict.toArrayPlanAccionPendiente(dict)
                    let asisCurso: ArrayGeneral<Persona> = Dict.dataToArray(data!)
                    //self.textoSinOcurrencias.text = "No hubo ocurrencias"
                    //self.TablaCap.isHidden = cursos.Data.count <= 0
                    /*
                     if asisCurso.Data.count > 0 {
                     self.Asistentes = asisCurso.Data
                     self.TablAsistencia.reloadData()
                     }
                     */
                    self.addMoreData(array: asisCurso.Data)
                    
                }, error: nil)
                
            }
        }
    }
    
    func addMoreData(array:[Persona]) {
        // var nuevaData: [PlanAccionPendiente] = []
        var codigos: [String] = []
        for i in 0..<self.Asistentes.count {
            codigos.append(self.Asistentes[i].CodPersona!)
        }
        for i in 0..<array.count {
            if !codigos.contains(array[i].CodPersona!) {
                self.Asistentes.append(array[i])
            }
        }
        self.TablAsistencia.reloadData()
    }
    
    
    @IBAction func addPersona(_ sender: Any) {
        var dataPersona = Persona()
        
        VCHelper.openFiltroPersona(self, {(persona:Persona) in
            //self.loadDataFromDNI(codigo: persona.NroDocumento)
            self.addParticipante(persona.CodPersona!, self.codCurso, persona.Estado!)
            
        })
        
    }
    func addParticipante(_ codPer: String,_ codCurso: String,_ indice:String ){
        Rest.postDataGeneral(Routes.forAddAsistente(), ["CodPersona": codPer, "NroDocumento": codCurso, "Estado": self.indiceF], true, success: {(resultValue:Any?,data:Data?) in
            let usuario: Persona = Dict.dataToUnit(data!)!
            print(usuario.Estado)
            
            Globals.isScaning = true
            
            if usuario == nil || usuario.CodPersona == nil
            {
                
                self.presentAlert(nil, "Ocurrio un error al registrar asistente" , .alert, 2,Images.errorIcon,  [], [], actionHandlers: [])
                
            }else if usuario.Estado == "N" { // scanner
                self.activeScan=true;///
                self.ControlCam.startCam() //habilitar la camara
                
                self.presentAlert(nil, "\(usuario.CodPersona!) : \(usuario.Nombres!)" , .actionSheet, 2,nil,  [], [], actionHandlers: [])
                //Images.errorIcon
                
            }else if usuario.Estado == "P"{
                
                self.presentAlert("Asistente no registrado", "Desea agregarlo a la lista de participantes?", .alert, nil, Images.alertaAmarilla, ["Cancelar", "Aceptar"], [.cancel, .default], actionHandlers: [ {(alertaCancelar) in
                    print("Esto ocurre al presionar cancelar")/// activar scan
                    self.activeScan=true;
                    self.ControlCam.startCam() //habilitar la camara
                    
                    }, {(alertAceptar) in
                        print("Esto ocurre al presionar aceptar")
                        self.activeScan=true;
                        self.ControlCam.startCam() //habilitar la camara
                        
                        Rest.postDataGeneral(Routes.forAddParticipante(), ["CodPersona": codPer, "NroDocumento": codCurso, "Estado": self.indiceF], true, success: {(resultValue:Any?,data:Data?) in
                            //let usuario: Persona = Dict.dataToUnit(data!)!
                            print(self.indiceF)
                            let str = resultValue as! String
                            
                            if str == "-1" {
                                self.presentAlert2(nil, "Ocurrio un error, no se pudo guardar la nota", .actionSheet, 2, nil, [], [], actionHandlers: [])
                            }else {
                                Images.downloadAvatar(usuario.NroDocumento!, {() in
                                    
                                    let popup = Utils.capacitacionSB.instantiateViewController(withIdentifier: "PopUpAsistente") as! PopUpAsistenteVC
                                    popup.modalPresentationStyle = .overCurrentContext
                                    popup.dataPersona = usuario
                                    popup.tituloPop = "REGISTRADO CORRECTAMENTE"
                                    popup.tiempo = 5
                                    popup.re = 0
                                    popup.gr = 95
                                    popup.bl = 146
                                    popup.tipoIcon = "check"
                                    self.present(popup, animated: true, completion: nil)
                                    
                                    self.LoadData(self.indiceF)
                                    
                                })
                            }
                            
                        }, error: nil)
                        
                    }, {(alertaEliminar) in
                        print("Esto ocurre al presionar eliminar")
                    }])
                
            } else if usuario.Estado == "R" /*|| usuario.Estado == "A"*/{
                self.activeScan=true;
                self.ControlCam.startCam() //habilitar la camara
                Images.downloadAvatar(usuario.NroDocumento!, {() in
                    let popup = Utils.capacitacionSB.instantiateViewController(withIdentifier: "PopUpAsistente") as! PopUpAsistenteVC
                    popup.modalPresentationStyle = .overCurrentContext
                    popup.dataPersona = usuario
                    popup.tituloPop = "ASISTENTE YA REGISTRADO"
                    popup.tiempo = 5
                    popup.re = 255
                    popup.gr = 171
                    popup.bl = 0
                    popup.tipoIcon = "Alert"
                    self.present(popup, animated: true, completion: nil)
                })
                
                
            }else if usuario.Estado == "A"{
                
                Images.downloadAvatar(usuario.NroDocumento!, {() in
                    let popup = Utils.capacitacionSB.instantiateViewController(withIdentifier: "PopUpAsistente") as! PopUpAsistenteVC
                    popup.modalPresentationStyle = .overCurrentContext
                    popup.dataPersona = usuario
                    popup.tituloPop = "REGISTRADO CORRECTAMENTE"
                    popup.tiempo = 5
                    popup.re = 0
                    popup.gr = 95
                    popup.bl = 146
                    popup.tipoIcon = "check"
                    self.present(popup, animated: true, completion: nil)
                    self.LoadData(self.indiceF)
                    
                })
                
                
                
                self.LoadData(self.indiceF)
                
            }
            
            
            
        }, error: {(error) in
            //self.inputsStack.isHidden = false
            print(error)
        })
        
    }
    
    @IBAction func FechaAsist(_ sender: Any) {
        
        Utils.showDropdown(sender as! UIButton, self.dataFechaDes, {(index,item) in
            
            self.indiceF = self.dataFechaCod[index]
            self.LoadData(self.indiceF)
            print(self.indiceF)
        })
        
    }
    
    
    @IBAction func Back(_ sender: Any) {
        //dataFechaCod = [String]()
        //dataFechaDes = [String]()
        
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnBarCode(_ sender: Any) {
        self.ContBarCode.isHidden = false
        self.barSubTitle.isHidden = true
        self.barTitleView.isHidden = false
        self.ControlCam.startCam()
    }
    
    @IBAction func close(_ sender: Any) {
        self.barTitleView.isHidden = true
        self.ContBarCode.isHidden = true
        self.barSubTitle.isHidden = false
        self.ControlCam.disCamera()
        
        
        
    }
    
    @IBAction func linterna(_ sender: Any) {
        
        if linEnable ==  false{
            //set icon con una linea
            btnLinterna.setImage(UIImage(named: "flashoff"), for: .normal)
            linEnable = true
            toggleTorch(on: linEnable)
        }else{
            btnLinterna.setImage(UIImage(named: "flashon"), for: .normal)
            
            linEnable = false
            toggleTorch(on: linEnable)
        }
        
        
        
    }
    
    func DataToScan(_ dniScan: String){
        
        print("Dni: \(dniScan)")
        if activeScan {
            activeScan = false
            self.addParticipante("D\(dniScan)",self.codCurso,self.indiceF)
            
        }
        
        //    func addParticipante(_ codPer: String,_ codCurso: String,_ indice:String ){
        if soundEnable {
            playSound()
        }
        
        
    }
    
    @IBAction func SoundAD(_ sender: Any) {
        //btnSound
        
        if soundEnable ==  true{
            //set icon con una linea
            btnSound.setImage(UIImage(named: "volumenoff"), for: .normal)
            soundEnable = false
            //toggleTorch(on: linEnable)
        }else{
            btnSound.setImage(UIImage(named: "volumenon"), for: .normal)
            
            soundEnable = true
            //toggleTorch(on: linEnable)
        }
        
    }
    
    
    func playSound() {
        
        let alertSound = URL(fileURLWithPath: Bundle.main.path(forResource: "scan_dni", ofType: "mp3")!)
        print(alertSound)
        
        try! AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
        try! AVAudioSession.sharedInstance().setActive(true)
        
        try! player = AVAudioPlayer(contentsOf: alertSound)
        player!.prepareToPlay()
        player!.play()
        
    }
    
    func toggleTorch(on: Bool){
        guard let device = AVCaptureDevice.default(for: .video) else {return}
        if device.hasTorch{
            do{
                if device.isTorchAvailable {
                    try device.lockForConfiguration()
                    if on == true {
                        device.torchMode = .on
                    }else {
                        device.torchMode = .off
                    }
                    device.unlockForConfiguration()
                }else {
                    print("Torch could not be used")
                }
                
            } catch {
                print("Torch could not be used")
            }
        } else {
            print("Torch is not available")
            
        }
    }
    
    @IBAction func nfcScan(_ sender: Any) {
        /*nfcSession = NFCNDEFReaderSession.init(delegate: self, queue: nil, invalidateAfterFirstRead: true)
         nfcSession?.begin()
         */
    }
    
    
    /*
     func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
     print("The session was invalidated: \(error.localizedDescription)")
     }
     
     func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
     // Parse the card's information
     }
     */
}

class AsistenciaViewCell: UITableViewCell {
    @IBOutlet weak var nombre: UILabel!
    
    @IBOutlet weak var cargo: UILabel!
    
    @IBOutlet weak var btn_eliminar: UIButton!
    
}
