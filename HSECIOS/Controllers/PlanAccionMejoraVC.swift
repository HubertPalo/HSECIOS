import UIKit
import DKImagePickerController
import Photos
import AVKit
import MobileCoreServices

class PlanAccionMejoraVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIDocumentMenuDelegate, UIDocumentPickerDelegate, UINavigationControllerDelegate, UIDocumentInteractionControllerDelegate {
    
    @IBOutlet weak var tabla: UITableView!
    
    @IBOutlet weak var botonTopDer: UIBarButtonItem!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var progressBarView: UIView!
    @IBOutlet weak var progressBarText: UILabel!
    @IBOutlet weak var botonCancelarDescarga: UIButton!
    @IBOutlet weak var viewCancelarDescarga: UIView!
    
    
    var codPlanAccion = ""
    var accion = AccionMejoraAtencion()
    var accionFecha = Date()
    var responsables: [Persona] = []
    var nombres = Set<String>()
    var multimedia: [FotoVideo] = []
    var documentos: [DocumentoGeneral] = []
    var correlativosABorrar = Set<Int>()
    var docIdRequests = [Int]()
    var docPorcentajes = [Int]()
    var modo = "GET"
    var idPost = -1
    
    var docController: UIDocumentInteractionController?
    
    var afterSuccess: ((_ : AccionMejoraAtencion) -> Void)?
    
    var dataNoEdit: [[String]] = [["Responsable", "-"], ["Fecha", "-"], ["Porcentaje de avance", "-"], ["Tarea realizada", "-"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabla.delegate = self
        self.tabla.dataSource = self
        self.progressBarView.isHidden = true
        switch self.modo {
        case "ADD":
            self.setTitleAndImage("Agregar registro de atención", nil)
        case "PUT":
            self.setTitleAndImage("Editar registro de atención", nil)
        case "GET":
            self.setTitleAndImage("HSEC", Images.minero)
        default:
            break
        }
        
    }
    
    func cleanData() {
        self.dataNoEdit = [["Responsable", "-"], ["Fecha", "-"], ["Porcentaje de avance", "-"], ["Tarea realizada", "-"]]
        self.multimedia = []
        self.documentos = []
        self.codPlanAccion = ""
        self.accion = AccionMejoraAtencion()
        self.accionFecha = Date()
        self.responsables = []
        self.nombres.removeAll()
        self.correlativosABorrar.removeAll()
        self.docIdRequests = []
        self.docPorcentajes = []
        self.tabla?.reloadData()
    }
    
    func loadData(_ modo: String, _ correlativo: Int?, _ codPlanAccion: String, _ responsables: [Persona]) {
        self.modo = modo
        self.codPlanAccion = codPlanAccion
        self.responsables = responsables
        self.tabla?.reloadData()
        switch modo {
        case "ADD":
            self.botonTopDer.tintColor = UIColor.white
            self.botonTopDer.isEnabled = true
            
            self.setTitleAndImage("Agregar registro de atención", nil)
            
            self.accion = AccionMejoraAtencion()
            switch self.responsables.count {
            case 1:
                self.accion.Responsable = responsables[0].Nombres
                self.accion.CodResponsable = responsables[0].CodPersona
            case 0:
                self.accion.Responsable = "NO HAY RESPONSABLES DISPONIBLES"
                self.accion.CodResponsable = nil
            default:
                self.accion.Responsable = nil
                self.accion.CodResponsable = nil
            }
            self.accion.CodAccion = codPlanAccion
            self.accion.Correlativo = -1
            self.accion.PorcentajeAvance = "0"
            self.accionFecha = Date()
            self.accion.Fecha = Date().toString("dd-MM-YYYY")
            self.tabla?.reloadData()
        case "GET":
            self.botonTopDer.tintColor = UIColor.clear
            self.botonTopDer.isEnabled = false
            
            self.setTitleAndImage("HSEC", Images.minero)
            
            Rest.getDataGeneral(Routes.forAccionMejoraDetalle("\(correlativo!)"), true, success: {(resultValue:Any?,data:Data?) in
                self.accion = Dict.dataToUnit(data!)!
                self.accionFecha = self.accion.Fecha?.toDate() ?? Date()
                (self.multimedia, self.documentos) = Utils.separateMultimedia(self.accion.Files!.Data)
                self.docPorcentajes = [Int].init(repeating: 0, count: self.documentos.count)
                self.docIdRequests = [Int].init(repeating: -1, count: self.documentos.count)
                for unit in self.multimedia {
                    Images.downloadImage("\(unit.Correlativo!)", {
                        unit.imagen = Images.imagenes["P-\(unit.Correlativo!)"]
                        self.tabla?.reloadData()
                    })
                }
                self.tabla?.reloadData()
            }, error: nil)
        case "PUT":
            self.botonTopDer.tintColor = UIColor.white
            self.botonTopDer.isEnabled = true
            
            self.setTitleAndImage("Editar registro de atención", nil)
            
            Rest.getDataGeneral(Routes.forAccionMejoraDetalle("\(correlativo!)"), true, success: {(resultValue:Any?,data:Data?) in
                self.accion = Dict.dataToUnit(data!)!
                self.accionFecha = self.accion.Fecha?.toDate() ?? Date()
                (self.multimedia, self.documentos) = Utils.separateMultimedia(self.accion.Files!.Data)
                self.docPorcentajes = [Int].init(repeating: 0, count: self.documentos.count)
                self.docIdRequests = [Int].init(repeating: -1, count: self.documentos.count)
                for unit in self.multimedia {
                    Images.downloadImage("\(unit.Correlativo!)", {
                        unit.imagen = Images.imagenes["P-\(unit.Correlativo!)"]
                        self.tabla?.reloadData()
                    })
                }
                self.tabla?.reloadData()
            }, error: nil)
        default:
            break
        }
        
    }
    
    // Document Picker
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        do {
            let documento = DocumentoGeneral()
            documento.url = url
            documento.Descripcion = url.lastPathComponent
            documento.setMimeType()
            documento.TipoArchivo = "TP03"
            documento.multimediaData = try Data.init(contentsOf: url)
            let fileSize = documento.multimediaData?.count ?? 1024*1024*8
            documento.Tamanio = "\(fileSize)"
            if fileSize < 1024*1024*8 {
                self.documentos.append(documento)
                self.docIdRequests.append(-1)
                self.docPorcentajes.append(0)
                self.tabla.reloadData()
            } else {
                self.presentAlert("Archivo muy pesado", "No es posible subir archivos con un peso mayor a 8 MB", .alert, 2, nil, [], [], actionHandlers: [])
            }
        } catch {
            self.presentAlert("Error", "Ocurrió un error al intentar obtener data de su documento, por favor, inténtelo nuevamente", .alert, 2, nil, [], [], actionHandlers: [])
        }
    }
    func documentMenu(_ documentMenu: UIDocumentMenuViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController) {
        documentPicker.delegate = self
        present(documentPicker, animated: true, completion: nil)
    }
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("view was cancelled")
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.tag == 0 {
            if string.count > 1 {
                return false
            }
            let inverseSet = NSCharacterSet(charactersIn:"0123456789").inverted
            let components = string.components(separatedBy: inverseSet)
            let filtered = components.joined(separator: "")
            
            if string == filtered {
                let nsString = textField.text as NSString?
                let num = nsString?.replacingCharacters(in: range, with: string)
                let numero = Int(num!) ?? 0
                
                if numero <= 100 && numero >= 0 {
                    self.accion.PorcentajeAvance = "\(numero)"
                    
                    return true
                }
            }
            return false
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField.tag {
        case 0:
            textField.text = "\(Int(textField.text ?? "") ?? 0)"
            self.accion.PorcentajeAvance = textField.text
        case 1:
            self.accion.Descripcion = textField.text
        default:
            break
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 30
        case 1:
            return (self.modo == "GET" && self.multimedia.count == 0) ? CGFloat.leastNonzeroMagnitude : 35
        case 2:
            return (self.modo == "GET" && self.documentos.count == 0) ? CGFloat.leastNonzeroMagnitude : 35
            // return self.documentos.count > 0 ? 50 : CGFloat.leastNonzeroMagnitude
        default:
            return CGFloat.leastNonzeroMagnitude
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableCell(withIdentifier: "celda1") as! Celda1Texto1View1Boton
        switch section {
        case 0:
            header.texto.text = "Registro de atención"
            header.view.isHidden = true
        case 1:
            if (self.modo == "GET" && self.multimedia.count == 0) {
                return nil
            }
            header.texto.text = "Galería de Fotos Videos"
            header.view.isHidden = self.modo == "GET"
            header.boton.tag = 0
        case 2:
            if (self.modo == "GET" && self.documentos.count == 0) {
                return nil
            }
            header.texto.text = "Otros Documentos"
            header.view.isHidden = self.modo == "GET"
            header.boton.tag = 1
        default:
            break
        }
        return header.contentView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 4
        case 1:
            return self.multimedia.count / 2 + self.multimedia.count % 2
        case 2:
            return self.documentos.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                if self.modo == "GET" {
                    let celda = tableView.dequeueReusableCell(withIdentifier: "celda2") as! Celda2Texto
                    celda.texto1.text = "Responsable"
                    celda.texto2.text = self.accion.Responsable
                    return celda
                } else {
                    let celda = tableView.dequeueReusableCell(withIdentifier: "celda3") as! Celda1Texto1Boton
                    celda.texto.attributedText = Utils.addInitialRedAsterisk("Responsable", "HelveticaNeue-Bold", 13)
                    celda.boton.tag = 0
                    let dato = self.accion.CodResponsable == nil ? "- SELECCIOME -" : self.accion.Responsable
                    celda.boton.setTitle(dato, for: .normal)
                    celda.boton.titleLabel?.numberOfLines = 2
                    return celda
                }
            case 1:
                if self.modo == "GET" {
                    let celda = tableView.dequeueReusableCell(withIdentifier: "celda2") as! Celda2Texto
                    celda.texto1.text = "Fecha"
                    celda.texto2.text = Utils.str2date2str(self.accion.Fecha ?? "")
                    return celda
                } else {
                    let celda = tableView.dequeueReusableCell(withIdentifier: "celda3") as! Celda1Texto1Boton
                    celda.texto.text = "Fecha"
                    celda.boton.tag = 1
                    celda.boton.setTitle(Utils.date2str(self.accionFecha, "dd 'de' MMMM").uppercased(), for: .normal)
                    celda.boton.titleLabel?.numberOfLines = 2
                    return celda
                }
            case 2:
                if self.modo == "GET" {
                    let celda = tableView.dequeueReusableCell(withIdentifier: "celda2") as! Celda2Texto
                    celda.texto1.text = "Porcentaje de avance"
                    celda.texto2.text = self.accion.PorcentajeAvance
                    return celda
                } else {
                    let celda = tableView.dequeueReusableCell(withIdentifier: "celda4") as! Celda1Texto1InputText
                    celda.texto.attributedText = Utils.addInitialRedAsterisk("Porcentaje de avance", "HelveticaNeue-Bold", 13)
                    celda.inputTexto.text = self.accion.PorcentajeAvance
                    celda.inputTexto.tag = 0
                    celda.inputTexto.keyboardType = .numberPad
                    celda.inputTexto.delegate = self
                    return celda
                }
            case 3:
                if self.modo == "GET" {
                    let celda = tableView.dequeueReusableCell(withIdentifier: "celda2") as! Celda2Texto
                    celda.texto1.text = "Tarea realizada"
                    celda.texto2.text = self.accion.Descripcion
                    return celda
                } else {
                    let celda = tableView.dequeueReusableCell(withIdentifier: "celda5") as! Celda1Texto1InputText
                    celda.texto.attributedText = Utils.addInitialRedAsterisk("Tarea realizada", "HelveticaNeue-Bold", 13)
                    celda.inputTexto.text = self.accion.Descripcion
                    celda.inputTexto.tag = 1
                    celda.inputTexto.delegate = self
                    return celda
                }
            default:
                return UITableViewCell()
            }
            
        case 1: // Celda Galeria
            let celda = tableView.dequeueReusableCell(withIdentifier: "celda6") as! CeldaGaleria
            let unit1 = self.multimedia[indexPath.row * 2]
            let unit2: FotoVideo? = (indexPath.row * 2 + 1 == self.multimedia.count) ? nil : self.multimedia[indexPath.row * 2 + 1]
            celda.imagen1.image = unit1.imagen
            celda.imagen2.image = unit2 == nil ? nil : unit2!.imagen
            celda.play1.isHidden = unit1.TipoArchivo != "TP02"
            celda.play2.isHidden = unit2 == nil || unit2!.TipoArchivo != "TP02"
            celda.botonX1.tag = indexPath.row * 2
            celda.botonX2.tag = (indexPath.row * 2) + 1
            celda.boton1.tag = indexPath.row * 2
            celda.boton2.tag = (indexPath.row * 2) + 1
            celda.viewX1.isHidden = self.modo == "GET"
            celda.viewX2.isHidden = unit2 == nil || self.modo == "GET"
            celda.imagen2.isHidden = unit2 == nil
            celda.boton2.isEnabled = unit2 != nil
            return celda
        case 2: // Celda Documentos
            let celda = tableView.dequeueReusableCell(withIdentifier: "celda7") as! CeldaDocumento
            let unit = self.documentos[indexPath.row]
            celda.icono.image = unit.getIcon()
            if self.docIdRequests[indexPath.row] == -1 {
                celda.icono.isHidden = false
                celda.procentajeDescarga.isHidden = true
                celda.iconoCancelarDescarga.isHidden = true
            } else {
                celda.icono.isHidden = true
                celda.procentajeDescarga.isHidden = false
                celda.procentajeDescarga.text = "\(self.docPorcentajes[indexPath.row])%"
                celda.iconoCancelarDescarga.isHidden = false
            }
            celda.botonDescarga.tag = indexPath.row
            celda.nombre.text = unit.Descripcion
            celda.tamanho.text = Utils.getSizeFromFile(size: Int(unit.Tamanio ?? ""))
            celda.viewX.isHidden = self.modo == "GET"
            return celda
        default:
            return UITableViewCell()
        }
    }
    
    @IBAction func clickResponsableFecha(_ sender: Any) {
        let boton = sender as! UIButton
        switch boton.tag {
        case 0:
            var nombres: [String] = []
            for i in 0..<self.responsables.count {
                nombres.append(self.responsables[i].Nombres ?? "")
            }
            Utils.showDropdown(boton, nombres, {(indice,item) in
                self.accion.CodResponsable = self.responsables[indice].CodPersona
                self.accion.Responsable = self.responsables[indice].Nombres
            })
        case 1:
            Utils.openDatePicker("Fecha", Date(), nil, nil, chandler: {(date) in
                boton.setTitle(Utils.date2str(date, "dd 'de' MMMM").uppercased(), for: .normal)
                self.accionFecha = date
                // self.accion.Fecha = date.toString("dd-MM-YYYY")
            })
        default:
            break
        }
    }
    
    @IBAction func clickFlechaIzq(_ sender: Any) {
        var porcentaje = Int(self.accion.PorcentajeAvance ?? "") ?? 0
        porcentaje = porcentaje > 0 ? porcentaje - 1 : 0
        self.accion.PorcentajeAvance = "\(porcentaje)"
        self.tabla.reloadRows(at: [IndexPath.init(row: 2, section: 0)], with: .none)
    }
    
    @IBAction func clickFlechaDer(_ sender: Any) {
        var porcentaje = Int(self.accion.PorcentajeAvance ?? "") ?? 0
        porcentaje = porcentaje < 100 ? porcentaje + 1 : 100
        self.accion.PorcentajeAvance = "\(porcentaje)"
        self.tabla.reloadRows(at: [IndexPath.init(row: 2, section: 0)], with: .none)
    }
    
    @IBAction func clickImagen(_ sender: Any) {
        if !Utils.InteraccionHabilitada {
            return
        }
        
        let indice = (sender as! UIButton).tag
        let unit = self.multimedia[indice]
        if unit.TipoArchivo == "TP02" {
            if unit.asset == nil {
                
            } else {
                unit.asset!.fetchAVAssetWithCompleteBlock({(video, info) in
                    let playerAV = AVPlayer.init(playerItem: AVPlayerItem.init(asset: video!))
                    let playerViewController = AVPlayerViewController()
                    playerViewController.player = playerAV
                    self.present(playerViewController, animated: true) {
                        playerViewController.player!.play()
                    }
                })
            }
        } else {
            var imagenes = [FotoVideo]()
            var indiceGaleria = 0
            var contador = 0
            for media in self.multimedia {
                if media.TipoArchivo == "TP01" {
                    let newMedia = media.copy()
                    imagenes.append(newMedia)
                    if media.Descripcion == unit.Descripcion {
                        indiceGaleria = contador
                    }
                    contador = contador + 1
                }
            }
            self.showGaleria(imagenes, indiceGaleria)
        }
    }
    
    @IBAction func clickImagenX(_ sender: Any) {
        if !Utils.InteraccionHabilitada {
            return
        }
        
        let indexToDel = (sender as! UIButton).tag
        let unit = self.multimedia[indexToDel]
        if unit.Correlativo != nil {
            self.correlativosABorrar.insert(unit.Correlativo ?? 0)
        }
        self.nombres.remove(unit.Descripcion ?? "")
        self.multimedia.remove(at: indexToDel)
        self.tabla.reloadSections([1], with: .none)
    }
    
    @IBAction func clickDocumento(_ sender: Any) {
        let indice = (sender as! UIButton).tag
        let unit = self.documentos[indice]
        if unit.Correlativo == nil {
            return
        }
        
        if self.docIdRequests[indice] == -1 {
            self.docIdRequests[indice] = Rest.generateId()
            self.tabla.reloadRows(at: [IndexPath.init(row: indice, section: 1)], with: .none)
            Rest.downloadFileTo(unit.Descripcion ?? "archivo", Routes.forDownloadFile(unit.Url!), false, self.docIdRequests[indice], {(progreso) in
                self.docPorcentajes[indice] = Int(progreso * 100)
                self.tabla.reloadRows(at: [IndexPath.init(row: indice, section: 1)], with: .none)
                print(progreso)
            }, {(response) in
                print(response.destinationURL)
                Rest.requests[self.docIdRequests[indice]] = nil
                self.docPorcentajes[indice] = 0
                self.docIdRequests[indice] = -1
                self.tabla.reloadRows(at: [IndexPath.init(row: indice, section: 1)], with: .none)
                if response.destinationURL != nil {
                    self.docController = UIDocumentInteractionController(url: NSURL.fileURL(withPath: response.destinationURL!.path))
                    self.docController?.delegate = self
                    self.docController?.presentOptionsMenu(from: self.botonTopDer, animated: true)
                }
            }, {(error) in
                print(error)
                Rest.requests[self.docIdRequests[indice]] = nil
                self.docIdRequests[indice] = -1
                self.tabla.reloadRows(at: [IndexPath.init(row: indice, section: 1)], with: .none)
            })
        } else {
            Rest.requests[self.docIdRequests[indice]]?.cancel()
            Rest.requests[self.docIdRequests[indice]] = nil
            self.docIdRequests[indice] = -1
            self.tabla.reloadRows(at: [IndexPath.init(row: indice, section: 1)], with: .none)
        }
    }
    
    @IBAction func clickDocumentoX(_ sender: Any) {
        if !Utils.InteraccionHabilitada {
            return
        }
        
        let indexToDel = (sender as! UIButton).tag
        let unit = self.documentos[indexToDel]
        if unit.Correlativo != nil {
            self.correlativosABorrar.insert(unit.Correlativo ?? 0)
        }
        self.nombres.remove(unit.Descripcion ?? "")
        self.documentos.remove(at: indexToDel)
        self.docPorcentajes.remove(at: indexToDel)
        self.docIdRequests.remove(at: indexToDel)
        self.tabla.reloadSections([2], with: .none)
    }
    
    @IBAction func clickTituloBotonDer(_ sender: Any) {
        let boton = sender as! UIButton
        switch boton.tag {
        case 0:
            let pickerController = DKImagePickerController()
            pickerController.assetFilter = { (asset) in
                if let resource = PHAssetResource.assetResources(for: asset).first {
                    let fileSize = resource.value(forKey: "fileSize") as? Int ?? 1024 * 1024 * 8
                    return fileSize < 1024 * 1024 * 8
                }
                return false
            }
            pickerController.didSelectAssets = { (assets: [DKAsset]) in
                if assets.count > 0 {
                    for i in 0..<assets.count {
                        if assets[i].isVideo {
                            self.loadAssetVideo(asset: assets[i])
                        } else {
                            self.loadAssetImagen(asset: assets[i])
                        }
                    }
                }
            }
            self.present(pickerController, animated: true) {}
        case 1:
            let importMenu = UIDocumentMenuViewController(documentTypes: [String(kUTTypePDF), "com.microsoft.word.doc", "org.openxmlformats.wordprocessingml.document", "com.microsoft.excel.xls", "org.openxmlformats.spreadsheetml.sheet", "com.microsoft.powerpoint.​ppt", "org.openxmlformats.presentationml.presentation"], in: .import)
            importMenu.delegate = self
            importMenu.modalPresentationStyle = .formSheet
            self.present(importMenu, animated: true, completion: nil)
        default:
            break
        }
    }
    
    
    
    @IBAction func clickCancelarUpload(_ sender: Any) {
        Rest.requestFlags.remove(self.idPost)
    }
    
    @IBAction func clickTopIzq(_ sender: Any) {
        if !Utils.InteraccionHabilitada {
            return
        }
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func clickTopDer(_ sender: Any) {
        self.view.endEditing(true)
        var titulo = ""
        
        if (self.accion.CodResponsable ?? "").trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            titulo = "Responsable"
        }
        if (self.accion.PorcentajeAvance ?? "").trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            titulo = "Porcentaje de avance"
        }
        if (self.accion.Descripcion ?? "").trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            titulo = "Tarea realizada"
        }
        
        if titulo != "" {
            self.presentError("El campo \(titulo) no puede estar vacío")
            return
        }
        self.accion.Fecha = self.accionFecha.toString("YYYY-MM-dd")
        
        let copia = self.accion.copy()
        copia.Responsable = nil
        copia.Files = nil
        
        
        let cabecera = String.init(data: Dict.unitToData(Dict.unitToParams(copia))!, encoding: .utf8)!
        
        var arrayData = [Data]()
        var arrayNames = [String]()
        var arrayFileNames = [String]()
        var arrayMimeTypes = [String]()
        
        for i in 0..<self.multimedia.count {
            let unit = self.multimedia[i]
            if unit.Correlativo == nil && unit.multimediaData != nil && unit.Descripcion != nil {
                arrayData.append(unit.multimediaData!)
                arrayNames.append("multimedia\(i)")
                arrayFileNames.append(unit.Descripcion!)
                arrayMimeTypes.append(unit.mimeType!)
            }
        }
        for i in 0..<self.documentos.count {
            let unit = self.documentos[i]
            if unit.Correlativo == nil && unit.multimediaData != nil && unit.Descripcion != nil {
                arrayData.append(unit.multimediaData!)
                arrayNames.append("documento\(i)")
                arrayFileNames.append(unit.Descripcion!)
                arrayMimeTypes.append(unit.mimeType!)
            }
        }
        
        var toDel = (self.correlativosABorrar.map{String($0)}).joined(separator: ";")
        toDel = toDel == "" ? "-" : toDel
        self.idPost = Rest.generateId()
        var correlativo = self.accion.Correlativo == nil ? "-1" : "\(self.accion.Correlativo!)"
        
        self.idPost = Rest.generateId()
        self.progressBar.progress = 0.0
        self.progressBarText.text = "0%"
        self.viewCancelarDescarga.isHidden = false
        
        self.progressBarView.isHidden = false
        self.botonTopDer.isEnabled = false
        self.botonCancelarDescarga.isEnabled = true
        Utils.InteraccionHabilitada = false
        
        Rest.postMultipartFormData(Routes.forAccionMejoraPutPost(), params: [["1", cabecera], ["2", toDel], ["3", self.codPlanAccion], ["4", correlativo]], arrayData, arrayNames, arrayFileNames, arrayMimeTypes, false, idPost, success: {(resultValue:Any?,data:Data?) in
            self.progressBarView.isHidden = true
            self.botonTopDer.isEnabled = true
            self.botonCancelarDescarga.isEnabled = false
            Utils.InteraccionHabilitada = true
            print(resultValue)
            let respuesta = resultValue as! String
            if respuesta == "-1" {
                self.presentError("Ocurrió un error al procesar la solicitud")
                return
            }
            let respuestaSplits = respuesta.components(separatedBy: ";")
            if respuestaSplits.count != 3 {
                self.presentError("No se pudo intepretar la respuesta del servidor")
                return
            }
            self.presentarAlertaDeseaFinalizar({(aceptarAction) in
                self.afterSuccess?(self.accion)
                self.navigationController?.popViewController(animated: true)
                self.dismiss(animated: true, completion: nil)
            }, {(cancelarAction) in
                self.setTitleAndImage("Editar registro de atención", nil)
                self.modo = "PUT"
                self.correlativosABorrar.removeAll()
                if self.accion.Correlativo == -1 {
                    self.accion.Correlativo = Int(respuestaSplits[0])
                }
                self.tabla.reloadData()
                if respuestaSplits[2] != "-1" && respuestaSplits[2] != "-" {
                    let multimediaSplits = respuestaSplits[2].components(separatedBy: ",")
                    for multiNomCor in multimediaSplits {
                        var unitData = multiNomCor.components(separatedBy: ":")
                        for unit in self.multimedia {
                            if unit.Descripcion == unitData[0] {
                                unit.Correlativo = Int(unitData[1])
                            }
                        }
                        for unit in self.documentos {
                            if unit.Descripcion == unitData[0] {
                                unit.Correlativo = Int(unitData[1])
                            }
                        }
                    }
                }
            })
            
        }, progress: {(progreso) in
            self.progressBar.progress = Float(progreso)
            self.progressBarText.text = "\(Int(progreso * 100))%"
            self.viewCancelarDescarga.isHidden = progreso > 0.9
        }, error: {(error) in
            self.progressBarView.isHidden = true
            self.botonTopDer.isEnabled = true
            self.botonCancelarDescarga.isEnabled = false
            Utils.InteraccionHabilitada = true
            let (titulo, mensaje) = Utils.procesarMensajeError(error)
            self.presentAlert(titulo, mensaje, .alert, 2, nil, [], [], actionHandlers: [])
        })
    }
    
    func loadAssetVideo(asset: DKAsset) {
        var flagImage = false
        var flagVideoData = false
        var fotovideo = FotoVideo()
        fotovideo.TipoArchivo = asset.isVideo ? "TP02" : "TP01"
        fotovideo.asset = asset
        fotovideo.Descripcion = PHAssetResource.assetResources(for: asset.originalAsset!).first?.originalFilename
        fotovideo.setMimeType()
        Utils.bloquearPantalla()
        asset.fetchImageWithSize(CGSize.init(width: 200, height: 200), completeBlock: {(image,info) in
            flagImage = true
            if let newImage = image {
                fotovideo.imagen = newImage
            }
            if flagImage && flagVideoData {
                Utils.desbloquearPantalla()
                Dict.unitToData(fotovideo)
                if fotovideo.imagen != nil && fotovideo.multimediaData != nil && !self.nombres.contains(fotovideo.Descripcion ?? "") {
                    self.multimedia.append(fotovideo)
                    self.nombres.insert(fotovideo.Descripcion ?? "")
                    self.tabla.reloadData()
                }
            }
        })
        /*PHImageManager.default().requestAVAsset(forVideo: asset.originalAsset!, options: nil, resultHandler: {(avasset,mix,info) in
            flagVideoData = true
            // asset.originalAsset?.value(forKey: "fileName")
            do {
                let myAsset = avasset as? AVURLAsset
                fotovideo.multimediaData = try Data(contentsOf: (myAsset?.url)!)
                // = videoData  //Set video data to nil in case of video
                // print("video data : \(videoData)")
            } catch {
                fotovideo.multimediaData = nil
            }
            if flagImage && flagVideoData {
                Utils.desbloquearPantalla()
                Dict.unitToData(fotovideo)
                if fotovideo.imagen != nil && fotovideo.multimediaData != nil && !self.nombres.contains(fotovideo.Descripcion ?? "") {
                    self.multimedia.append(fotovideo)
                    self.nombres.insert(fotovideo.Descripcion ?? "")
                    self.tabla.reloadData()
                }
            }
        })*/
        let options = PHVideoRequestOptions()
        options.version = .original
        options.deliveryMode = .automatic
        options.isNetworkAccessAllowed = true
        
        PHCachingImageManager.default().requestAVAsset(forVideo: asset.originalAsset!, options: options, resultHandler:{ (avAsset, audioMix, info) in
            DispatchQueue.main.async {
                let theAsset = avAsset as! AVURLAsset
                let videoURL = theAsset.url
                print(videoURL)
                flagVideoData = true
                do {
                    fotovideo.multimediaData = try Data(contentsOf: theAsset.url)
                } catch {
                    fotovideo.multimediaData = nil
                }
                if flagImage && flagVideoData {
                    Utils.desbloquearPantalla()
                    Dict.unitToData(fotovideo)
                    if fotovideo.imagen != nil && fotovideo.multimediaData != nil && !self.nombres.contains(fotovideo.Descripcion ?? "") {
                        self.multimedia.append(fotovideo)
                        self.nombres.insert(fotovideo.Descripcion ?? "")
                        self.tabla.reloadData()
                    }
                }
            }
        })
    }
    
    func loadAssetImagen(asset: DKAsset) {
        var flagImage = false
        var flagImagefull = false
        var flagImageData = false
        var fotovideo = FotoVideo()
        fotovideo.TipoArchivo = asset.isVideo ? "TP02" : "TP01"
        // fotovideo.esVideo = asset.isVideo
        fotovideo.asset = asset
        fotovideo.Descripcion = PHAssetResource.assetResources(for: asset.originalAsset!).first?.originalFilename
        fotovideo.setMimeType()
        Utils.bloquearPantalla()
        asset.fetchImageWithSize(CGSize.init(width: 200, height: 200), completeBlock: {(image,info) in
            flagImage = true
            if let newImage = image {
                fotovideo.imagen = newImage
            }
            if flagImage && flagImagefull && flagImageData {
                Utils.desbloquearPantalla()
                Dict.unitToData(fotovideo)
                if !(fotovideo.imagen == nil) && !(fotovideo.multimediaData == nil) && !self.nombres.contains(fotovideo.Descripcion ?? "") {
                    self.multimedia.append(fotovideo)
                    self.nombres.insert(fotovideo.Descripcion ?? "")
                    self.tabla.reloadData()
                }
            }
        })
        asset.fetchOriginalImage(false, completeBlock: {(image,info) in
            flagImagefull = true
            if let newImageFull = image {
                fotovideo.imagenFull = newImageFull
            }
            if flagImage && flagImagefull && flagImageData {
                Utils.desbloquearPantalla()
                Dict.unitToData(fotovideo)
                if !(fotovideo.imagen == nil) && !(fotovideo.multimediaData == nil) && !self.nombres.contains(fotovideo.Descripcion ?? "") {
                    self.multimedia.append(fotovideo)
                    self.nombres.insert(fotovideo.Descripcion ?? "")
                    self.tabla.reloadData()
                }
            }
        })
        asset.fetchImageDataForAsset(false, completeBlock: {(imageData,info) in
            flagImageData = true
            if let newData = imageData {
                fotovideo.multimediaData = newData
            }
            if flagImage && flagImagefull && flagImageData {
                Utils.desbloquearPantalla()
                Dict.unitToData(fotovideo)
                if !(fotovideo.imagen == nil) && !(fotovideo.multimediaData == nil) && !self.nombres.contains(fotovideo.Descripcion ?? "") {
                    self.multimedia.append(fotovideo)
                    self.nombres.insert(fotovideo.Descripcion ?? "")
                    self.tabla.reloadData()
                }
            }
        })
    }
}

