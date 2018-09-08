import UIKit
import DKImagePickerController
import Photos
import AVFoundation
import AVKit

class UpsertFacilitoVC: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var botonTopDer: UIBarButtonItem!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var progressBarView: UIView!
    @IBOutlet weak var progressBarText: UILabel!
    @IBOutlet weak var botonCancelarDescarga: UIButton!
    @IBOutlet weak var viewCancelarDescarga: UIView!
    
    @IBOutlet weak var tabla: UITableView!
    var idPost = -1
    
    override func viewWillAppear(_ animated: Bool) {
        if Globals.UFModo == "ADD" {
            self.setTitleAndImage("Nuevo reporte facilito", Images.facilito)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Globals.UFViewController = self
        self.tabla.delegate = self
        self.tabla.dataSource = self
        self.progressBarView.isHidden = true
        self.progressBarText.text = ""
        // self.tabla.reloadData()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        switch textField.tag {
        case 0:
            Globals.UFDetalle.UbicacionExacta = textField.text ?? ""
        case 1:
            Globals.UFDetalle.Observacion = textField.text ?? ""
        case 2:
            Globals.UFDetalle.Accion = textField.text ?? ""
        default:
            break
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 1:
            return Globals.UFModo == "ADD" ? nil : tableView.dequeueReusableCell(withIdentifier: "celda7")!.contentView
        case 2:
            return tableView.dequeueReusableCell(withIdentifier: "celda1")!.contentView
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 1:
            return Globals.UFModo == "ADD" ? CGFloat.leastNonzeroMagnitude : 3
        case 2:
            return 50
        default:
            return CGFloat.leastNonzeroMagnitude
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 6
        case 1:
            return Globals.UFModo == "ADD" ? 0 : 2
        case 2:
            return Globals.GaleriaMultimedia.count/2 + Globals.GaleriaMultimedia.count%2
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                let celda = tableView.dequeueReusableCell(withIdentifier: "celda2") as! Celda1Texto2Boton
                celda.texto.text = "Tipo"
                celda.boton1.backgroundColor = (Globals.UFDetalle.Tipo ?? "") == "A" ? Images.colorClover : Images.colorClover.withAlphaComponent(0.5)
                celda.boton1.tag = 0
                celda.boton2.backgroundColor = (Globals.UFDetalle.Tipo ?? "") == "C" ? UIColor.red : UIColor.red.withAlphaComponent(0.5)
                celda.boton2.tag = 1
                return celda
            case 1:
                let celda = tableView.dequeueReusableCell(withIdentifier: "celda3") as! Celda1Texto1Boton
                celda.texto.attributedText = Utils.addInitialRedAsterisk("Gerencia", "HelveticaNeue", 13)
                celda.boton.tag = 0
                celda.boton.setTitle(Utils.searchMaestroDescripcion("GERE", Globals.UFDetalle.CodPosicionGer ?? ""), for: .normal)
                celda.boton.titleLabel?.numberOfLines = 2
                return celda
            case 2:
                let celda = tableView.dequeueReusableCell(withIdentifier: "celda3") as! Celda1Texto1Boton
                celda.texto.attributedText = Utils.generateAttributedString(["Superintendencia"], ["HelveticaNeue"], [13])
                celda.boton.tag = 1
                celda.boton.setTitle(Utils.searchMaestroDescripcion("SUPE.\(Globals.UFDetalle.CodPosicionGer ?? "")", Globals.UFDetalle.CodPosicionSup ?? ""), for: .normal)
                celda.boton.titleLabel?.numberOfLines = 2
                return celda
            case 3:
                let celda = tableView.dequeueReusableCell(withIdentifier: "celda4") as! Celda1Texto1InputText
                celda.texto.attributedText = Utils.addInitialRedAsterisk("Ubicación", "HelveticaNeue", 13)
                celda.inputTexto.text = (Globals.UFDetalle.UbicacionExacta ?? "")
                celda.inputTexto.tag = 0
                celda.inputTexto.isEnabled = Utils.InteraccionHabilitada
                celda.inputTexto.delegate = self
                return celda
            case 4:
                let celda = tableView.dequeueReusableCell(withIdentifier: "celda4") as! Celda1Texto1InputText
                celda.texto.attributedText = Utils.addInitialRedAsterisk("Observación", "HelveticaNeue", 13)
                celda.inputTexto.text = (Globals.UFDetalle.Observacion ?? "")
                celda.inputTexto.isEnabled = Utils.InteraccionHabilitada
                celda.inputTexto.tag = 1
                celda.inputTexto.delegate = self
                return celda
            case 5:
                let celda = tableView.dequeueReusableCell(withIdentifier: "celda4") as! Celda1Texto1InputText
                celda.texto.attributedText = Utils.addInitialRedAsterisk("Acción", "HelveticaNeue", 13)
                celda.inputTexto.text = (Globals.UFDetalle.Accion ?? "")
                celda.inputTexto.isEnabled = Utils.InteraccionHabilitada
                celda.inputTexto.tag = 2
                celda.inputTexto.delegate = self
                return celda
            default:
                return UITableViewCell()
            }
        } else if indexPath.section == 1 {
            switch indexPath.row {
            case 0:
                let celda = tableView.dequeueReusableCell(withIdentifier: "celda6") as! Celda1Texto
                celda.texto.text = (Globals.UFDetalle.RespAuxiliarDesc ?? "")
                return celda
            case 1:
                let celda = tableView.dequeueReusableCell(withIdentifier: "celda3") as! Celda1Texto1Boton
                celda.texto.text = "Estado:"
                celda.boton.setTitle(Utils.searchMaestroStatic("ESTADOFACILITO", Globals.UFDetalle.Estado ?? ""), for: .normal)
                celda.boton.tag = 2
                return celda
            default:
                return UITableViewCell()
            }
        } else {
            let celda = tableView.dequeueReusableCell(withIdentifier: "celda5") as! CeldaGaleria
            let unit1 = Globals.GaleriaMultimedia[indexPath.row * 2]
            let unit2: FotoVideo? = (indexPath.row * 2 + 1 == Globals.GaleriaMultimedia.count) ? nil : Globals.GaleriaMultimedia[indexPath.row * 2 + 1]
            celda.imagen1.image = unit1.imagen
            celda.imagen2.image = unit2 == nil ? nil : unit2!.imagen
            celda.play1.isHidden = unit1.TipoArchivo != "TP02"
            celda.play2.isHidden = unit2 == nil || unit2!.TipoArchivo != "TP02"
            celda.botonX1.tag = indexPath.row * 2
            celda.botonX2.tag = (indexPath.row * 2) + 1
            celda.boton1.tag = indexPath.row * 2
            celda.boton2.tag = (indexPath.row * 2) + 1
            celda.viewX1.isHidden = Globals.GaleriaModo == "GET"
            celda.viewX2.isHidden = unit2 == nil || Globals.GaleriaModo == "GET"
            celda.imagen2.isHidden = unit2 == nil
            celda.boton2.isEnabled = unit2 != nil
            return celda
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
                if multimediaVideo.imagen != nil && multimediaVideo.multimediaData != nil && !Globals.GaleriaNombres.contains(multimediaVideo.Descripcion ?? "") {
                    Globals.GaleriaMultimedia.append(multimediaVideo)
                    Globals.GaleriaNombres.insert(multimediaVideo.Descripcion ?? "")
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
                if multimediaVideo.imagen != nil && multimediaVideo.multimediaData != nil && !Globals.GaleriaNombres.contains(multimediaVideo.Descripcion ?? "") {
                    Globals.GaleriaMultimedia.append(multimediaVideo)
                    Globals.GaleriaNombres.insert(multimediaVideo.Descripcion ?? "")
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
                if !(fotovideo.imagen == nil) && !(fotovideo.multimediaData == nil) && !Globals.GaleriaNombres.contains(fotovideo.Descripcion ?? "") {
                    Globals.GaleriaMultimedia.append(fotovideo)
                    Globals.GaleriaNombres.insert(fotovideo.Descripcion ?? "")
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
                if !(fotovideo.imagen == nil) && !(fotovideo.multimediaData == nil) && !Globals.GaleriaNombres.contains(fotovideo.Descripcion ?? "") {
                    Globals.GaleriaMultimedia.append(fotovideo)
                    Globals.GaleriaNombres.insert(fotovideo.Descripcion ?? "")
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
                if !(fotovideo.imagen == nil) && !(fotovideo.multimediaData == nil) && !Globals.GaleriaNombres.contains(fotovideo.Descripcion ?? "") {
                    Globals.GaleriaMultimedia.append(fotovideo)
                    Globals.GaleriaNombres.insert(fotovideo.Descripcion ?? "")
                    self.tabla.reloadData()
                }
            }
        })
    }
    
    @IBAction func clickTopIzq(_ sender: Any) {
        if !Utils.InteraccionHabilitada {
            return
        }
        self.presentarAlertaDatosSinGuardar {
            if self.navigationController!.viewControllers.count > 1 {
                self.navigationController?.popViewController(animated: true)
                self.dismiss(animated: true, completion: nil)
            } else {
                Utils.openMenuTab()
            }
        }
    }
    
    @IBAction func clickTopDer(_ sender: Any) {
        self.view.endEditing(true)
        if !Utils.InteraccionHabilitada {
            return
        }
        self.botonTopDer.isEnabled = false
        let respuestaTab = Globals.UFGetData()
        let respuestaGal = Globals.GaleriaGetData()
        print(respuestaGal)
        print(respuestaTab)
        if respuestaTab.respuesta != "" {
            self.presentAlert("El siguiente campo no puede estar vacío", respuestaTab.respuesta, .alert, 2, nil, [], [], actionHandlers: [])
            self.botonTopDer.isEnabled = true
            return
        }
        self.progressBarText.text = "0%"
        self.progressBar.progress = 0.0
        self.viewCancelarDescarga.isHidden = false
        self.progressBarView.isHidden = false
        self.idPost = Rest.generateId()
        Utils.InteraccionHabilitada = false
        self.tabla.reloadData()
        Rest.postMultipartFormData(Routes.forADDFacilito(), params: [["1", respuestaTab.data], ["2", respuestaGal.toDel], ["3", Globals.UFCodigo]], respuestaGal.data, respuestaGal.names, respuestaGal.fileNames, respuestaGal.mimeTypes, false, self.idPost, success: {(resultValue:Any?,data:Data?) in
            Utils.InteraccionHabilitada = true
            self.tabla.reloadData()
            self.progressBarView.isHidden = true
            self.botonTopDer.isEnabled = true
            var respuesta = resultValue as! String
            if respuesta == "-1" {
                self.presentAlert("Error", "Ocurrió un error al procesar la solicitud. Por favor, inténtelo nuevamente", .alert, 2, nil, [], [], actionHandlers: [])
            } else {
                var errores = [String]()
                
                var multimediaNombres = [String]()
                var multimediaCorrelativos = [Int]()
                let respuestaSplits = respuesta.components(separatedBy: ";")
                let multimediaSplits = respuestaSplits[2].components(separatedBy: ",")
                
                for split in multimediaSplits {
                    if split == "-1" {
                        if !errores.contains("Error al procesar una o mas imagenes") {
                            errores.append("Error al procesar una o mas imagenes")
                        }
                    } else {
                        var archivoSplits = split.components(separatedBy: ":")
                        if archivoSplits.count == 2 && Int(archivoSplits[1]) != nil {
                            multimediaNombres.append(archivoSplits[0])
                            multimediaCorrelativos.append(Int(archivoSplits[1])!)
                        }
                    }
                }
                
                
                switch Globals.UFModo {
                case "ADD":
                    if respuestaSplits[0] == "-1" {
                        errores.append("Error al agregar la Cabecera")
                    }
                    if respuestaSplits[1] == "-1" {
                        errores.append("Error aun no identificado")
                    }
                    if respuestaSplits[2] == "-1" {
                        errores.append("Error al ingresar archivos")
                    }
                    
                    break
                case "PUT":
                    if respuestaSplits[0] == "-1" {
                        errores.append("Error al editar la Cabecera")
                    }
                    if respuestaSplits[1] == "-1" {
                        errores.append("Error aun no identificado")
                    }
                    if respuestaSplits[2] == "-1" {
                        errores.append("Error al actualizar archivos")
                    }
                    
                    break
                default:
                    break
                }
                if errores.count > 0 {
                    self.presentAlert("Error", "Se encontraron los siguientes errores:\n\(errores)", .alert, 2, Images.alertaRoja, [], [], actionHandlers: [])
                } else {
                    self.presentAlert("¿Desea Finalizar?", "Se guardaron los datos correctamente", .alert, nil, Images.alertaVerde, ["Aceptar", "Cancelar"], [UIAlertActionStyle.default, UIAlertActionStyle.destructive], actionHandlers: [{(alertActionAceptar) in
                        print(self.navigationController?.viewControllers.count)
                        print("Al aceptar: aun falta desarrollar")
                        self.navigationController?.popViewController(animated: true)
                        self.dismiss(animated: true, completion: nil)
                        }, {(alertActionCancelar) in
                            print("Al cancelar: aun falta desarrollar")
                            Globals.UFModo = "PUT"
                            Globals.GaleriaCorrelativosABorrar.removeAll()
                            Globals.UFCodigo = respuestaSplits[0]
                            Globals.UFDetalle.CodObsFacilito = respuestaSplits[0]
                            for i in 0..<multimediaNombres.count {
                                let nombre = multimediaNombres[i]
                                let correlativo = multimediaCorrelativos[i]
                                for multimedia in Globals.GaleriaMultimedia {
                                    if multimedia.Correlativo == nil && multimedia.Descripcion == nombre {
                                        multimedia.Correlativo = correlativo
                                    }
                                }
                            }
                            self.tabla.reloadData()
                        }])
                }
            }
            print(resultValue)
        }, progress: {(progreso:Double) in
            self.progressBar.progress = Float(progreso)
            self.progressBarText.text = "\(Int(progreso * 100))%"
            self.viewCancelarDescarga.isHidden = progreso > 0.9
        }, error: {(error) in
            Utils.InteraccionHabilitada = true
            self.tabla.reloadData()
            self.progressBarView.isHidden = true
            self.botonTopDer.isEnabled = true
            let (titulo, mensaje) = Utils.procesarMensajeError(error)
            self.presentAlert(titulo, mensaje, .alert, 2, nil, [], [], actionHandlers: [])
        })
    }
    
    @IBAction func clickAgregarResponsable(_ sender: Any) {
        if !Utils.InteraccionHabilitada {
            return
        }
        VCHelper.openFiltroPersona(self, {(persona) in
            Globals.UFDetalle.RespAuxiliar = persona.CodPersona
            Globals.UFDetalle.RespAuxiliarDesc = persona.Nombres
            self.tabla.reloadRows(at: [IndexPath.init(row: 0, section: 1)], with: .none)
        })
    }
    
    @IBAction func clickEliminarResponsable(_ sender: Any) {
        if !Utils.InteraccionHabilitada {
            return
        }
        Globals.UFDetalle.RespAuxiliar = nil
        Globals.UFDetalle.RespAuxiliarDesc = nil
        self.tabla.reloadRows(at: [IndexPath.init(row: 0, section: 1)], with: .none)
    }
    
    @IBAction func clickActoCondicion(_ sender: Any) {
        if !Utils.InteraccionHabilitada {
            return
        }
        let boton = sender as! UIButton
        Globals.UFDetalle.Tipo = boton.tag == 0 ? "A" : "C"
        self.tabla.reloadRows(at: [IndexPath.init(row: 0, section: 0)], with: .none)
    }
    
    @IBAction func clickGerenciaSuperintendencia(_ sender: Any) {
        if !Utils.InteraccionHabilitada {
            return
        }
        let boton = sender as! UIButton
        var data: [String] = []
        switch boton.tag {
        case 0:
            data = Utils.maestroDescripcion["GERE"] ?? []
        case 1:
            data = Utils.maestroDescripcion["SUPE.\(Globals.UFDetalle.CodPosicionGer ?? "")"] ?? []
        case 2:
            data = Utils.maestroStatic2["ESTADOFACILITO"] ?? []
        default:
            break
        }
        Utils.showDropdown(boton, data, {(index, item) in
            switch boton.tag {
            case 0:
                Globals.UFDetalle.CodPosicionGer = Utils.maestroCodTipo["GERE"]?[index]
                Globals.UFDetalle.CodPosicionSup = nil
                self.tabla.reloadRows(at: [IndexPath.init(row: 2, section: 0)], with: .none)
            case 1:
                Globals.UFDetalle.CodPosicionSup = Utils.maestroCodTipo["SUPE.\(Globals.UFDetalle.CodPosicionGer ?? "")"]?[index]
            case 2:
                Globals.UFDetalle.Estado = Utils.maestroStatic1["ESTADOFACILITO"]?[index]
            default:
                break
            }
        })
    }
    
    @IBAction func clickFotografia(_ sender: Any) {
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
    
    @IBAction func clickImagen(_ sender: Any) {
        if !Utils.InteraccionHabilitada {
            return
        }
        let indice = (sender as! UIButton).tag
        let unit = Globals.GaleriaMultimedia[indice]
        switch unit.TipoArchivo ?? "" {
        case "TP01":
            var imagenes = [FotoVideo]()
            var indiceGaleria = 0
            var contador = 0
            for media in Globals.GaleriaMultimedia {
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
            self.showVideo(unit)
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
        Globals.GaleriaNombres.remove(Globals.GaleriaMultimedia[indice].Descripcion ?? "")
        if Globals.GaleriaMultimedia[indice].Correlativo != nil {
            Globals.GaleriaCorrelativosABorrar.insert(Globals.GaleriaMultimedia[indice].Correlativo!)
        }
        Globals.GaleriaMultimedia.remove(at: indice)
        self.tabla.reloadSections([2], with: .automatic)
    }
    
    @IBAction func clickCancelarDescarga(_ sender: Any) {
        Rest.requestFlags.remove(self.idPost)
    }
    
}
