import UIKit
import DKImagePickerController
import Photos
import AVKit

class FacDetalleAtencionVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var botonTopDer: UIBarButtonItem!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var progressBarView: UIView!
    @IBOutlet weak var progressBarText: UILabel!
    @IBOutlet weak var botonCancelarDescarga: UIButton!
    @IBOutlet weak var viewCancelarDescarga: UIView!
    
    @IBOutlet weak var tabla: UITableView!
    
    var idPost = -1
    var modo = ""
    var codigo = ""
    var atencion = HistorialAtencionElement()
    var fechaResolucion: Date?
    var horaResolucion: Date?
    
    var multimediaNombres = Set<String>()
    var multimedia: [FotoVideo] = []
    var correlativosABorrar = Set<Int>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabla.delegate = self
        self.tabla.dataSource = self
        self.progressBarView.isHidden = true
        self.progressBar.progress = 0.0
        self.botonTopDer.isEnabled = self.modo == "ADD" || self.modo == "PUT"
        self.botonTopDer.tintColor = (self.modo == "ADD" || self.modo == "PUT") ? UIColor.white : UIColor.clear
        self.multimediaNombres.removeAll()
        self.correlativosABorrar.removeAll()
        if self.atencion.FechaFin != nil {
            self.fechaResolucion = Utils.str2date(self.atencion.FechaFin!)
            self.horaResolucion = Utils.str2date(self.atencion.FechaFin!)
        }
        self.tabla.reloadData()
        
        var titulo = ""
        var imagen: UIImage? = Images.facilito
        switch self.modo {
        case "GET":
            titulo = "Detalle Facilito/Atención"
        case "ADD":
            titulo = "Agregar Atención"
        case "PUT":
            titulo = "Editar Atención"
        default:
            titulo = ""
            imagen = nil
        }
        if self.modo == "GET" || self.modo == "PUT" {
            Rest.getDataGeneral(Routes.forMultimedia("\(codigo)-\(atencion.Correlativo!)"), true, success: {(resultValue:Any?,data:Data?) in
                var arrayMultimedia: ArrayGeneral<Multimedia> = Dict.dataToArray(data!)
                self.multimedia = Utils.separateMultimedia(arrayMultimedia.Data).fotovideos
                var contador = 0
                for media in self.multimedia {
                    self.multimediaNombres.insert(media.Descripcion ?? "")
                    Images.downloadImage("\(media.Correlativo!)", {() in
                        media.imagen = Images.imagenes["P-\(media.Correlativo!)"]
                        contador = contador + 1
                        if contador == self.multimedia.count {
                            self.tabla.reloadData()
                        }
                    })
                }
            }, error: {(error) in
                
            })
        }
        Utils.setTitleAndImage(self, titulo, imagen)
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.atencion.Comentario = textField.text
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 1 ? 50 : CGFloat.leastNonzeroMagnitude
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return nil
        }
        let header = tableView.dequeueReusableCell(withIdentifier: "celda1") as! Celda1Texto1View
        header.texto.text = "Galería de imágenes"
        header.view.isHidden = self.modo == "GET"
        return header.contentView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            switch self.modo {
            case "GET":
                return 5
            case "ADD":
                return 2 + (self.atencion.Estado == "S" ? 2: 0)
            case "PUT":
                return 2 + (self.atencion.Estado == "S" ? 2: 0)
            default:
                return 0
            }
        case 1:
            return (self.multimedia.count/2) + (self.multimedia.count%2)
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            if self.modo == "GET" {
                let celda = tableView.dequeueReusableCell(withIdentifier: "celda2") as! Celda2Texto
                switch indexPath.row {
                case 0:
                    celda.texto1.text = "Atendido por:"
                    celda.texto2.text = self.atencion.Persona
                case 1:
                    celda.texto1.text = "Fecha Atención:"
                    celda.texto2.text = Utils.str2date2str(self.atencion.Fecha ?? "")
                case 2:
                    celda.texto1.text = "Estado:"
                    celda.texto2.text = Utils.searchMaestroStatic("ESTADOFACILITO", self.atencion.Estado ?? "")
                case 3:
                    celda.texto1.text = "Fecha Ejecutarse:"
                    celda.texto2.text = Utils.str2date2str(self.atencion.FechaFin ?? "")
                case 4:
                    celda.texto1.text = "Comentario:"
                    celda.texto2.text = self.atencion.Comentario
                default:
                    break
                }
                return celda
            } else {
                switch indexPath.row {
                case 0 :
                    let celda = tableView.dequeueReusableCell(withIdentifier: "celda3") as! Celda1Texto1Boton
                    celda.texto.text = "Estado"
                    celda.boton.tag = 0
                    var dato = Utils.searchMaestroStatic("ESTADOFACILITO", self.atencion.Estado ?? "")
                    dato = dato == "" ? "- SELECCIONE -" : dato
                    celda.boton.setTitle(dato, for: .normal)
                    return celda
                case 1 :
                    if self.atencion.Estado == "S" {
                        let celda = tableView.dequeueReusableCell(withIdentifier: "celda3") as! Celda1Texto1Boton
                        celda.texto.text = "Fecha resolución"
                        celda.boton.tag = 1
                        var dato = Utils.date2str(self.fechaResolucion, "dd 'de' MMMM").uppercased()
                        dato = dato == "" ? "SELECCIONAR FECHA" : dato
                        celda.boton.setTitle(dato, for: .normal)
                        return celda
                    } else {
                        let celda = tableView.dequeueReusableCell(withIdentifier: "celda4") as! Celda1Texto1InputText
                        celda.texto.text = "Acción"
                        celda.inputTexto.text = self.atencion.Comentario
                        celda.inputTexto.delegate = self
                        return celda
                    }
                case 2 :
                    let celda = tableView.dequeueReusableCell(withIdentifier: "celda3") as! Celda1Texto1Boton
                    celda.texto.text = "Hora resolución"
                    celda.boton.tag = 2
                    var dato = Utils.date2str(self.horaResolucion, "HH:mm:ss")
                    dato = dato == "" ? "00:00:00" : dato
                    celda.boton.setTitle(dato, for: .normal)
                    return celda
                case 3 :
                    let celda = tableView.dequeueReusableCell(withIdentifier: "celda4") as! Celda1Texto1InputText
                    celda.texto.text = "Acción"
                    celda.inputTexto.text = self.atencion.Comentario
                    celda.inputTexto.delegate = self
                    return celda
                default:
                    return UITableViewCell()
                }
            }
        case 1:
            let celda = tableView.dequeueReusableCell(withIdentifier: "celda5") as! CeldaGaleria
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
        default:
            return UITableViewCell()
        }
    }
    
    func loadAssetVideo(asset: DKAsset) {
        var flagImage = false
        var flagVideoData = false
        let multimediaVideo = FotoVideo()
        multimediaVideo.asset = asset
        multimediaVideo.TipoArchivo = "TP02"
        multimediaVideo.Descripcion = (PHAssetResource.assetResources(for: asset.originalAsset!).first?.originalFilename ?? "")
        multimediaVideo.setMimeType()
        Utils.bloquearPantalla()
        asset.fetchImageWithSize(CGSize.init(width: 200, height: 200), completeBlock: {(image,info) in
            flagImage = true
            if let newImage = image {
                multimediaVideo.imagen = newImage
            }
            if flagImage && flagVideoData {
                Utils.desbloquearPantalla()
                Dict.unitToData(multimediaVideo)
                if multimediaVideo.imagen != nil && multimediaVideo.multimediaData != nil && !self.multimediaNombres.contains(multimediaVideo.Descripcion ?? "") {
                    self.multimedia.append(multimediaVideo)
                    self.multimediaNombres.insert(multimediaVideo.Descripcion ?? "")
                    self.tabla.reloadData()
                }
            }
        })
        PHImageManager.default().requestAVAsset(forVideo: asset.originalAsset!, options: nil, resultHandler: {(avasset,mix,info) in
            flagVideoData = true
            do {
                let myAsset = avasset as? AVURLAsset
                multimediaVideo.multimediaData = try Data(contentsOf: (myAsset?.url)!)
            } catch {
                multimediaVideo.multimediaData = nil
            }
            if flagImage && flagVideoData {
                Utils.desbloquearPantalla()
                Dict.unitToData(multimediaVideo)
                if multimediaVideo.imagen != nil && multimediaVideo.multimediaData != nil && !self.multimediaNombres.contains(multimediaVideo.Descripcion ?? "") {
                    self.multimedia.append(multimediaVideo)
                    self.multimediaNombres.insert(multimediaVideo.Descripcion ?? "")
                    self.tabla.reloadData()
                }
            }
        })
    }
    
    func loadAssetImagen(asset: DKAsset) {
        var flagImage = false
        var flagImagefull = false
        var flagImageData = false
        let fotovideo = FotoVideo()
        fotovideo.TipoArchivo = "TP01"
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
                if !(fotovideo.imagen == nil) && !(fotovideo.multimediaData == nil) && !self.multimediaNombres.contains(fotovideo.Descripcion ?? "") {
                    self.multimedia.append(fotovideo)
                    self.multimediaNombres.insert(fotovideo.Descripcion ?? "")
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
                if !(fotovideo.imagen == nil) && !(fotovideo.multimediaData == nil) && !self.multimediaNombres.contains(fotovideo.Descripcion ?? "") {
                    self.multimedia.append(fotovideo)
                    self.multimediaNombres.insert(fotovideo.Descripcion ?? "")
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
                if !(fotovideo.imagen == nil) && !(fotovideo.multimediaData == nil) && !self.multimediaNombres.contains(fotovideo.Descripcion ?? "") {
                    self.multimedia.append(fotovideo)
                    self.multimediaNombres.insert(fotovideo.Descripcion ?? "")
                    self.tabla.reloadData()
                }
            }
        })
    }
    
    @IBAction func clickAgregarMultimedia(_ sender: Any) {
        if !Utils.InteraccionHabilitada {
            return
        }
        let pickerController = DKImagePickerController()
        pickerController.didSelectAssets = { (assets: [DKAsset]) in
            if assets.count > 0 {
                for asset in assets {
                    if asset.isVideo {
                        self.loadAssetVideo(asset: asset)
                    } else {
                        self.loadAssetImagen(asset: asset)
                    }
                }
            }
        }
        self.present(pickerController, animated: true) {}
    }
    
    @IBAction func clickEstadoFechaHora(_ sender: Any) {
        if !Utils.InteraccionHabilitada {
            return
        }
        let boton = sender as! UIButton
        switch boton.tag {
        case 0:
            Utils.showDropdown(boton, Utils.maestroStatic2["ESTADOFACILITO"] ?? [], {(index,item) in
                self.atencion.Estado = Utils.maestroStatic1["ESTADOFACILITO"]?[index]
                self.tabla.reloadSections([0], with: .none)
            })
        case 1:
            let rango = Utils.getDateMonthInterval(Date())
            Utils.openDatePicker("Fecha resolución", self.fechaResolucion ?? Date(), rango.initialDate, rango.endDate, chandler: {(date) in
                self.fechaResolucion = date
                boton.setTitle(Utils.date2str(date, "dd 'de' MMMM").uppercased(), for: .normal)
            })
        case 2:
            Utils.openHourPicker("Hora resolución", chandler: {(date) in
                self.horaResolucion = date
                boton.setTitle(Utils.date2str(date, "HH:mm:ss"), for: .normal)
            })
        default:
            break
        }
    }
    
    @IBAction func clickImagen(_ sender: Any) {
        if !Utils.InteraccionHabilitada {
            return
        }
        let indice = (sender as! UIButton).tag
        let unit = self.multimedia[indice]
        switch unit.TipoArchivo ?? "" {
        case "TP01":
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
            break
        case "TP02":
            unit.asset!.fetchAVAssetWithCompleteBlock({(video, info) in
                let playerAV = AVPlayer.init(playerItem: AVPlayerItem.init(asset: video!))
                let playerViewController = AVPlayerViewController()
                playerViewController.player = playerAV
                self.present(playerViewController, animated: true) {
                    playerViewController.player!.play()
                }
            })
            break
        default:
            self.presentAlert("Error", "Tipo de archivo desconocido", .alert, 2, nil, [], [], actionHandlers: [])
        }
    }
    
    @IBAction func clickImagenX(_ sender: Any) {
        if !Utils.InteraccionHabilitada {
            return
        }
        let indice = (sender as! UIButton).tag
        self.multimediaNombres.remove(Globals.GaleriaMultimedia[indice].Descripcion ?? "")
        if self.multimedia[indice].Correlativo != nil {
            self.correlativosABorrar.insert(self.multimedia[indice].Correlativo!)
        }
        self.multimedia.remove(at: indice)
        self.tabla.reloadSections([1], with: .none)
    }
    
    @IBAction func clickTopDer(_ sender: Any) {
        if !Utils.InteraccionHabilitada {
            return
        }
        self.view.endEditing(true)
        
        self.fechaResolucion = self.atencion.Estado == "S" ? self.fechaResolucion : nil
        self.horaResolucion = self.atencion.Estado == "S" ? self.horaResolucion : nil
        self.atencion.FechaFin = ""
        if let fecha = self.fechaResolucion {
            self.atencion.FechaFin = fecha.toString("YYYY-MM-dd")
            if let hora = self.horaResolucion {
                self.atencion.FechaFin = self.atencion.FechaFin! + "T" + hora.toString("HH:mm:ss")
            } else {
                self.atencion.FechaFin = self.atencion.FechaFin! + "T00:00:00"
            }
        }
        
        var titulo = ""
        titulo = self.atencion.Estado == nil ? "Estado" : titulo
        titulo = self.atencion.Comentario == nil || self.atencion.Comentario == "" ? "Acción" : titulo
        titulo = (self.atencion.Estado == "S" && self.atencion.FechaFin == "") ? "Fecha Resolución" : titulo
        if titulo != "" {
            self.presentAlert("El siguiente campo no puede estar vacío", titulo, .alert, 2, nil, [], [], actionHandlers: [])
            return
        }
        
        var data = [Data]()
        var names = [String]()
        var fileNames = [String]()
        var mimeTypes = [String]()
        for media in self.multimedia {
            if media.Correlativo == nil && media.multimediaData != nil {
                data.append(media.multimediaData!)
                names.append(media.Descripcion!)
                fileNames.append(media.Descripcion!)
                mimeTypes.append(media.mimeType!)
            }
        }
        var archivosABorrar: String = (self.correlativosABorrar.map{String($0)}).joined(separator: ";")
        archivosABorrar = archivosABorrar == "" ? "-" : archivosABorrar
        let correlativo = self.atencion.Correlativo != nil ? "\(self.atencion.Correlativo!)" : ""
        let cabecera = String.init(data: Dict.unitToData(self.atencion)!, encoding: .utf8)!
        
        self.progressBar.progress = 0.0
        self.progressBarView.isHidden = false
        self.idPost = Rest.generateId()
        Utils.InteraccionHabilitada = false
        Rest.postMultipartFormData(Routes.forPOSTFacAtencion(), params: [["1", cabecera], ["2", archivosABorrar], ["3", self.codigo], ["4", correlativo]], data, names, fileNames, mimeTypes, true, self.idPost, success: {(resultValue:Any?,data:Data?) in
            print(resultValue)
            Utils.InteraccionHabilitada = true
            self.progressBarView.isHidden = true
            let respuesta = resultValue as! String
            if respuesta == "-1" {
                self.presentAlert("El servidor rechazó su solicitud", "Por favor, inténtelo más tarde", .alert, 2, nil, [], [], actionHandlers: [])
                return
            }
            let respuestaSplits = respuesta.components(separatedBy: ";")
            if respuestaSplits.count != 3 {
                self.presentAlert("Error de interpretación", "No pudo procesarse la respuesta brindada por el servidor", .alert, nil, nil, ["Aceptar"], [.default], actionHandlers: [{(alertAceptar) in
                    self.navigationController?.popViewController(animated: true)
                    self.dismiss(animated: true, completion: nil)
                    }])
                return
            }
            // Crear y modificar Historial Atencion
            // -0 Crear
            // -1 Modificar
            if respuestaSplits[0] != "-1" {
                let atencionCorrelativo = self.atencion.Correlativo == -1 ? Int(respuestaSplits[0])! : self.atencion.Correlativo!
                Rest.getDataGeneral(Routes.forNotificacion(respuestaSplits[0], codigoUpsert: self.atencion.Correlativo == nil ? "0" : "1"), false, success: {(resultValue:Any?, data:Data?) in
                    print(resultValue)
                }, error: {(error) in
                    print(error)
                })
            }
            
            //"ObsFacilito/SendNotification/"+ObsHist.Correlativo+(GlobalVariables.flaghistorial?"-0":"-1");
            
            self.presentAlert("¿Desea finalizar?", "Los datos fueron guardados con éxito", .alert, nil, nil, ["Aceptar", "Cancelar"], [.default, .cancel], actionHandlers: [{(alertAceptar) in
                /*Rest.getDataGeneral(Routes.forNotificacion(respuestaSplits[0], codigoUpsert: self.modo == "PUT" ? "1" : "0"), true, success: {(resultValue:Any?,data:Data?) in
                    print(resultValue)
                }, error: {(error) in
                    print(error)
                })*/
                self.navigationController?.popViewController(animated: true)
                self.dismiss(animated: true, completion: nil)
                }, {(alertCancelar) in
                    self.modo = "PUT"
                    self.atencion.Correlativo = Int(respuestaSplits[0])
                    if respuestaSplits[2] != "-" {
                        var nombres = [String]()
                        var correlativos = [Int]()
                        let archivos = respuestaSplits[2].components(separatedBy: ",")
                        for archivo in archivos {
                            let nombreCorrelativo = archivo.components(separatedBy: ":")
                            nombres.append(nombreCorrelativo[0])
                            correlativos.append(Int(nombreCorrelativo[1])!)
                        }
                        for i in 0..<nombres.count {
                            for media in self.multimedia {
                                if media.Descripcion == nombres[i] {
                                    media.Correlativo = correlativos[i]
                                }
                            }
                        }
                    }
                    self.tabla.reloadData()
                }])
            print(resultValue)
        }, progress: {(progreso) in
            self.progressBar.progress = Float(progreso)
            self.progressBarText.text = "\(Int(progreso * 100))%"
            self.viewCancelarDescarga.isHidden = progreso > 0.9
        }, error: {(error) in
            Utils.InteraccionHabilitada = true
            self.progressBarView.isHidden = true
            let (titulo, mensaje) = Utils.procesarMensajeError(error)
            self.presentAlert(titulo, mensaje, .alert, 2, nil, [], [], actionHandlers: [])
        })
    }
    
    @IBAction func clickCancelarDescarga(_ sender: Any) {
        Rest.requestFlags.remove(self.idPost)
    }
    
    
}
