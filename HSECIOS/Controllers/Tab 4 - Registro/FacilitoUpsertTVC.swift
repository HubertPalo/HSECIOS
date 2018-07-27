import UIKit
import DKImagePickerController
import Photos
import AVFoundation
import AVKit

class FacilitoUpsertTVC: UITableViewController, UITextFieldDelegate {
    
    // var modo = "ADD"
    // var detalle = FacilitoDetalle()
    
    // var multimedia: [FotoVideo] = []
    
    // var dataRest: [String:String] = ["Tipo" : "A"]
    // var dataShow: [String:String] = ["Tipo" : "A", "CodPosicionGer": "- SELECCIONE -", "CodPosicionSup": "- SELECCIONE -"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.isUserInteractionEnabled = true
        Utils.setTitleAndImage(self, "Nuevo reporte facilito", Images.facilito)
        self.tableView.reloadData()
        Globals.UFViewController = self
    }
    
    /*func loadModo(_ modo: String, _ codigo: String){
        self.modo = modo
        // self.facilito = facilito
        
        self.tableView.reloadData()
        Rest.getDataGeneral(Routes.forFacilitoDetalle(codigo), true, success: {(resultValue:Any?,data:Data?) in
            let detalle: FacilitoDetalle = Dict.dataToUnit(data!)!
            // let detalle = Dict.toFacilitoDetalle(dict)
            if modo == "PUT" {
                self.dataRest["CodObsFacilito"] = detalle.CodObsFacilito
                self.dataRest["Tipo"] = detalle.Tipo
                self.dataRest["CodPosicionGer"] = detalle.CodPosicionGer
                self.dataRest["CodPosicionSup"] = detalle.CodPosicionSup
                self.dataRest["UbicacionExacta"] = detalle.UbicacionExacta
                self.dataRest["Observacion"] = detalle.Observacion
                self.dataRest["Accion"] = detalle.Accion
                self.dataRest["RespAuxiliar"] = detalle.RespAuxiliar
                self.dataRest["Estado"] = detalle.Estado
                
                self.dataShow["Tipo"] = Utils.searchMaestroStatic("TIPOFACILITO", detalle.Tipo ?? "")
                self.dataShow["CodPosicionGer"] = Utils.searchMaestroDescripcion("GERE", detalle.CodPosicionGer ?? "")
                self.dataShow["CodPosicionSup"] = Utils.searchMaestroDescripcion("SUPE.\(detalle.CodPosicionGer ?? "")", detalle.CodPosicionSup ?? "")
                self.dataShow["RespAuxiliar"] = detalle.RespAuxiliarDesc
                self.dataShow["Estado"] = Utils.searchMaestroStatic("ESTADOFACILITO", detalle.Estado ?? "")
            }
            self.tableView.reloadData()
            print(self.dataShow)
            print(self.dataRest)
        }, error: nil)
    }*/
    
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
            //self.dataRest["Ubicacion"] = textField.text ?? ""
        case 1:
            Globals.UFDetalle.Observacion = textField.text ?? ""
            //self.dataRest["Observacion"] = textField.text ?? ""
        case 2:
            Globals.UFDetalle.Accion = textField.text ?? ""
            // self.dataRest["Accion"] = textField.text ?? ""
        default:
            break
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 1:
            return Globals.UFModo == "ADD" ? nil : tableView.dequeueReusableCell(withIdentifier: "celda7")!.contentView
        case 2:
            return tableView.dequeueReusableCell(withIdentifier: "celda1")!.contentView
        default:
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 1:
            return Globals.UFModo == "ADD" ? CGFloat.leastNonzeroMagnitude : 3
        case 2:
            return 50
        default:
            return CGFloat.leastNonzeroMagnitude
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
                // celda.boton.setTitle(self.dataShow["CodPosicionGer"]!, for: .normal)
                celda.boton.titleLabel?.numberOfLines = 2
                return celda
            case 2:
                let celda = tableView.dequeueReusableCell(withIdentifier: "celda3") as! Celda1Texto1Boton
                celda.texto.attributedText = Utils.generateAttributedString(["Superintendencia"], ["HelveticaNeue"], [13])
                celda.boton.tag = 1
                celda.boton.setTitle(Utils.searchMaestroDescripcion("SUPE.\(Globals.UFDetalle.CodPosicionGer ?? "")", Globals.UFDetalle.CodPosicionSup ?? ""), for: .normal)
                // celda.boton.setTitle(self.dataShow["CodPosicionSup"]!, for: .normal)
                celda.boton.titleLabel?.numberOfLines = 2
                return celda
            case 3:
                let celda = tableView.dequeueReusableCell(withIdentifier: "celda4") as! Celda1Texto1InputText
                celda.texto.attributedText = Utils.addInitialRedAsterisk("Ubicación", "HelveticaNeue", 13)
                celda.inputTexto.text = (Globals.UFDetalle.UbicacionExacta ?? "")
                celda.inputTexto.tag = 0
                celda.inputTexto.delegate = self
                return celda
            case 4:
                let celda = tableView.dequeueReusableCell(withIdentifier: "celda4") as! Celda1Texto1InputText
                celda.texto.attributedText = Utils.addInitialRedAsterisk("Observación", "HelveticaNeue", 13)
                celda.inputTexto.text = (Globals.UFDetalle.Observacion ?? "")
                celda.inputTexto.tag = 1
                celda.inputTexto.delegate = self
                return celda
            case 5:
                let celda = tableView.dequeueReusableCell(withIdentifier: "celda4") as! Celda1Texto1InputText
                celda.texto.attributedText = Utils.addInitialRedAsterisk("Acción", "HelveticaNeue", 13)
                celda.inputTexto.text = (Globals.UFDetalle.Accion ?? "")
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
                // celda.boton.setTitle(self.dataShow["Estado"] ?? "", for: .normal)
                celda.boton.tag = 2
                return celda
            default:
                return UITableViewCell()
            }
        } else {
            let celda = tableView.dequeueReusableCell(withIdentifier: "celda5") as! CeldaGaleria
            let unit1 = Globals.GaleriaMultimedia[indexPath.row * 2]
            celda.imagen1.image = unit1.imagen
            celda.play1.isHidden = !unit1.esVideo
            if indexPath.row * 2 + 1 != Globals.GaleriaMultimedia.count {
                let unit2 = Globals.GaleriaMultimedia[indexPath.row * 2 + 1]
                celda.view2.isHidden = false
                celda.play2.isHidden = false
                celda.imagen2.isHidden = false
                celda.viewX2.isHidden = false
                celda.imagen2.image = unit2.imagen
                celda.play2.isHidden = !unit2.esVideo
            } else {
                celda.play2.isHidden = true
                celda.imagen2.isHidden = true
                celda.viewX2.isHidden = true
            }
            return celda
        }
        
    }
    
    @IBAction func clickTopIzq(_ sender: Any) {
        if self.navigationController!.viewControllers.count > 1 {
            self.navigationController?.popViewController(animated: true)
            self.dismiss(animated: true, completion: nil)
        } else {
            Utils.openMenuTab()
        }
    }
    
    @IBAction func clickTopDer(_ sender: Any) {
        self.view.endEditing(true)
        let respuestaTab = Globals.UFGetData()
        if respuestaTab.respuesta != "" {
            Alerts.presentAlert("Complete el siguiente campo obligatorio", respuestaTab.respuesta, duration: 2, imagen: Images.alertaAmarilla, viewController: self)
        } else {
            print(Globals.UFCodigo)
            Rest.postMultipartFormData(Routes.forADDFacilito(), params: [["1", respuestaTab.data], ["2", "-"], ["3", Globals.UFCodigo]], [], [], [], [], true, 0, success: {(resultValue:Any?,data:Data?) in
                var respuesta = resultValue as! String
                if respuesta == "-1" {
                    self.presentAlert("Error", "Ocurrió un error al procesar la solicitud. Por favor, inténtelo nuevamente", .alert, 2, nil, [], [], actionHandlers: [])
                } else {
                    let respuestaSplits = respuesta.components(separatedBy: ";")
                    for i in 0..<respuestaSplits.count {
                        if respuestaSplits[0] == "-1" {
                            
                        }
                    }
                }
                print(resultValue)
            }, progress: {(progreso:Double) in
                
            }, error: {(error) in
                print(error)
            })
            // Alerts.presentAlert("Campos correctos", "POST aun no desarrollado", duration: 1, imagen: Images.alertaVerde, viewController: self)
        }
    }
    
    @IBAction func clickAgregarResponsable(_ sender: Any) {
        VCHelper.openFiltroPersona(self, {(persona) in
            Globals.UFDetalle.RespAuxiliar = persona.CodPersona
            Globals.UFDetalle.RespAuxiliarDesc = persona.Nombres
            /*self.dataRest["RespAuxiliar"] = persona.CodPersona
            self.dataShow["RespAuxiliar"] = persona.Nombres*/
            self.tableView.reloadRows(at: [IndexPath.init(row: 0, section: 1)], with: .none)
        })
    }
    
    @IBAction func clickEliminarResponsable(_ sender: Any) {
        Globals.UFDetalle.RespAuxiliar = nil
        Globals.UFDetalle.RespAuxiliarDesc = nil
        /*self.dataRest["RespAuxiliar"] = nil
        self.dataShow["RespAuxiliar"] = nil*/
        self.tableView.reloadRows(at: [IndexPath.init(row: 0, section: 1)], with: .none)
    }
    
    @IBAction func clickActoCondicion(_ sender: Any) {
        let boton = sender as! UIButton
        Globals.UFDetalle.Tipo = boton.tag == 0 ? "A" : "C"
        self.tableView.reloadRows(at: [IndexPath.init(row: 0, section: 0)], with: .none)
        /*if self.dataRest["Tipo"]! != tipo {
            self.dataRest["Tipo"] = tipo
        }*/
    }
    
    @IBAction func clickGerenciaSuperintendencia(_ sender: Any) {
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
                // Me quede aqui !!!
                Globals.UFDetalle.CodPosicionGer = Utils.maestroCodTipo["GERE"]?[index]
                Globals.UFDetalle.CodPosicionSup = nil
                // self.dataRest["CodPosicionGer"] = Utils.maestroCodTipo["GERE"]?[index] ?? ""
                // self.dataRest["CodPosicionSup"] = nil
                // self.dataShow["CodPosicionSup"] = "- SELECCIONE -"
                self.tableView.reloadRows(at: [IndexPath.init(row: 2, section: 0)], with: .none)
            case 1:
                Globals.UFDetalle.CodPosicionSup = Utils.maestroCodTipo["SUPE.\(Globals.UFDetalle.CodPosicionGer ?? "")"]?[index]
                // self.dataRest["CodPosicionSup"] = Utils.maestroCodTipo["SUPE.\(self.dataRest["CodPosicionGer"] ?? "")"]?[index] ?? ""
            case 2:
                Globals.UFDetalle.Estado = Utils.maestroStatic1["ESTADOFACILITO"]?[index]
                // self.dataRest["Estado"] = Utils.maestroStatic1["ESTADOFACILITO"]?[index]
            default:
                break
            }
            // print(self.dataRest)
        })
    }
    
    @IBAction func clickFotografia(_ sender: Any) {
        let pickerController = DKImagePickerController()
        pickerController.didSelectAssets = { (assets: [DKAsset]) in
            if assets.count > 0 {
                /*Utils.loadAssets(assets: assets, originales: self.multimedia, chandler: {(nuevaMultimedia:[FotoVideo]) in
                    self.multimedia = nuevaMultimedia
                    self.tableView.reloadSections([1], with: .automatic)
                })*/
            }
        }
        self.present(pickerController, animated: true) {}
    }
    
    @IBAction func clickImagenIzq(_ sender: Any) {
        var superView = (sender as AnyObject).superview??.superview
        while !(superView is CeldaGaleria) {
            superView = superView?.superview
        }
        let celda = superView as! CeldaGaleria
        var indexToShow = (self.tableView.indexPath(for: celda)!.row) * 2
        let unit = Globals.GaleriaMultimedia[indexToShow]
        if unit.esVideo {
            unit.asset!.fetchAVAssetWithCompleteBlock({(video, info) in
                let playerAV = AVPlayer.init(playerItem: AVPlayerItem.init(asset: video!))
                let playerViewController = AVPlayerViewController()
                playerViewController.player = playerAV
                self.present(playerViewController, animated: true) {
                    playerViewController.player!.play()
                }
            })
        } else {
            var imageAssets = [FotoVideo].init(Globals.GaleriaMultimedia)
            for i in (0..<Globals.GaleriaMultimedia.count).reversed() {
                let unit = Globals.GaleriaMultimedia[i]
                if unit.esVideo {
                    imageAssets.remove(at: i)
                    if i < indexToShow {
                        indexToShow = indexToShow - 1
                    }
                }
            }
            Images.showGallery(fotos: imageAssets, index: indexToShow, viewController: self)
        }
    }
    
    @IBAction func clickImagenDer(_ sender: Any) {
        var superView = (sender as AnyObject).superview??.superview
        while !(superView is CeldaGaleria) {
            superView = superView?.superview
        }
        let celda = superView as! CeldaGaleria
        var indexToShow = (self.tableView.indexPath(for: celda)!.row) * 2 + 1
        let unit = Globals.GaleriaMultimedia[indexToShow]
        if unit.esVideo {
            unit.asset!.fetchAVAssetWithCompleteBlock({(video, info) in
                let playerAV = AVPlayer.init(playerItem: AVPlayerItem.init(asset: video!))
                let playerViewController = AVPlayerViewController()
                playerViewController.player = playerAV
                self.present(playerViewController, animated: true) {
                    playerViewController.player!.play()
                }
            })
        } else {
            var imageAssets = [FotoVideo].init(Globals.GaleriaMultimedia)
            for i in (0..<Globals.GaleriaMultimedia.count).reversed() {
                let unit = Globals.GaleriaMultimedia[i]
                if unit.esVideo {
                    imageAssets.remove(at: i)
                    if i < indexToShow {
                        indexToShow = indexToShow - 1
                    }
                }
            }
            Images.showGallery(fotos: imageAssets, index: indexToShow, viewController: self)
        }
    }
    
    @IBAction func clickImagenIzqX(_ sender: Any) {
        var superView = (sender as AnyObject).superview??.superview
        while !(superView is CeldaGaleria) {
            superView = superView?.superview
        }
        let celda = superView as! CeldaGaleria
        let indexToDel = self.tableView.indexPath(for: celda)!.row * 2
        Globals.GaleriaMultimedia.remove(at: indexToDel)
        /*self.assets.remove(at: indexToDel)
        self.imagenes.remove(at: indexToDel)
        self.assetIsVideoFlag.remove(at: indexToDel)
        self.assetNames.remove(at: indexToDel)*/
        self.tableView.reloadSections([1], with: .automatic)
    }
    
    @IBAction func clickImagenDerX(_ sender: Any) {
        var superView = (sender as AnyObject).superview??.superview
        while !(superView is CeldaGaleria) {
            superView = superView?.superview
        }
        let celda = superView as! CeldaGaleria
        let indexToDel = self.tableView.indexPath(for: celda)!.row * 2 + 1
        Globals.GaleriaMultimedia.remove(at: indexToDel)
        /*self.assets.remove(at: indexToDel)
         self.imagenes.remove(at: indexToDel)
         self.assetIsVideoFlag.remove(at: indexToDel)
         self.assetNames.remove(at: indexToDel)*/
        self.tableView.reloadSections([1], with: .automatic)
    }
    
    func loadAssets(assets: [DKAsset]) {
        /*self.assetFinishFetchFlag = [Bool].init(repeating: false, count: assets.count)
        var newAssetIsVideoFlag = [Bool].init(repeating: false, count: assets.count)
        for i in 0..<assets.count {
            newAssetIsVideoFlag[i] = assets[i].isVideo
            assets[i].fetchImageWithSize(CGSize.init(width: 200, height: 200), completeBlock: {(image, info) in
                let newAssetName = PHAssetResource.assetResources(for: assets[i].originalAsset!).first?.originalFilename ?? ""
                if !self.assetNames.contains(newAssetName) {
                    self.assetIsVideoFlag.append(assets[i].isVideo)
                    self.assets.append(assets[i])
                    self.imagenes.append(image ?? Images.blank)
                    self.assetNames.append(newAssetName)
                    self.tableView.reloadData()
                }
            })
        }*/
    }
    
}
/*
class RegistroRepObsTVCell1: UITableViewCell  {
    
}

class RegistroRepObsTVCell2: UITableViewCell  {
    var param = ""
    @IBOutlet weak var botonAuto: UIButton!
    @IBOutlet weak var botonCondicion: UIButton!
}

class RegistroRepObsTVCell3: UITableViewCell  {
    var param = ""
    @IBOutlet weak var botonDropdown: UIButton!
    
    
}

class RegistroRepObsTVCell4: UITableViewCell  {
    var param = ""
    @IBOutlet weak var textoIzq: UILabel!
    
    @IBOutlet weak var inputTexto: UITextField!
    
    @IBOutlet weak var imagenDer: UIImageView!
    
    
}

class RegistroRepObsTVCell5: UITableViewCell  {
    
}

class RegistroRepObsTVCell6: UITableViewCell  {
    @IBOutlet weak var imagen1: UIImageView!
    @IBOutlet weak var imagen2: UIImageView!
    @IBOutlet weak var extraview: UIView!
    @IBOutlet weak var imagenPlay1: UIImageView!
    @IBOutlet weak var imagenPlay2: UIImageView!
    @IBOutlet weak var imagenBoton2: UIButton!
    @IBOutlet weak var imagenXView2: UIView!
}*/
