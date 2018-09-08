import UIKit
import DKImagePickerController
import Photos
import AVKit
import MobileCoreServices

class GaleriaFVDTVC: UITableViewController, UIDocumentMenuDelegate, UIDocumentPickerDelegate, UINavigationControllerDelegate, UIDocumentInteractionControllerDelegate {
    
    var descargaDocumentoBarButton = UIBarButtonItem()
    var docController: UIDocumentInteractionController?
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // self.tableView.reloadData()
    }
    
    func getData() -> (dataAdd: [Data], filenamesAdd: [String], mimeTypesAdd: [String], correlativoDel: [String]) {
        var arrayData = [Data]()
        var arrayFileName = [String]()
        var arrayMimeType = [String]()
        var arrayCorreDel = [String]()
        for i in 0..<Globals.GaleriaMultimedia.count {
            let unit = Globals.GaleriaMultimedia[i]
            if unit.Correlativo == nil {
                if unit.Descripcion != nil && unit.multimediaData != nil {
                    arrayData.append(unit.multimediaData!)
                    arrayFileName.append(unit.getFileName())
                    arrayMimeType.append(unit.getMimeType())
                }
            }
        }
        for i in Globals.GaleriaCorrelativosABorrar {
            arrayCorreDel.append("\(i)")
        }
        print(arrayCorreDel)
        return (arrayData, arrayFileName, arrayMimeType, arrayCorreDel)
    }
    
    func addFotoVideo(_ arrayFotoVideo: [FotoVideo]) {
        Globals.GaleriaMultimedia.append(contentsOf: arrayFotoVideo)
        self.tableView.reloadData()
    }
    
    // Document Picker
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        do {
            let documento = DocumentoGeneral()
            documento.url = url
            documento.Descripcion = url.lastPathComponent
            documento.multimediaData = try Data.init(contentsOf: url)
            let fileSize = documento.multimediaData?.count ?? 1024*1024*8
            documento.tamanho = Utils.getSizeFromFile(size: fileSize)
            if fileSize < 1024*1024*8 {
                Globals.GaleriaDocumentos.append(documento)
                self.tableView.reloadData()
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
    func escogerDocumento(){
        let importMenu = UIDocumentMenuViewController(documentTypes: [String(kUTTypePDF), "com.microsoft.word.doc", "org.openxmlformats.wordprocessingml.document", "com.microsoft.excel.xls", "org.openxmlformats.spreadsheetml.sheet", "com.microsoft.powerpoint.​ppt", "org.openxmlformats.presentationml.presentation"], in: .import)
        importMenu.delegate = self
        importMenu.modalPresentationStyle = .formSheet
        self.present(importMenu, animated: true, completion: nil)
    }
    // Document Picker
    
    // Table
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return Globals.GaleriaMultimedia.count/2 + Globals.GaleriaMultimedia.count%2
        case 1:
            return Globals.GaleriaDocumentos.count
        default:
            return 0
        }
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0:
            if Globals.GaleriaModo == "GET" && Globals.GaleriaMultimedia.count == 0 {
                return nil
            }
            let celda = tableView.dequeueReusableCell(withIdentifier: "celda1") as! GaleriaFVDTVCell1
            celda.viewAgregar.isHidden = Globals.GaleriaModo == "GET"
            celda.tituloIzq.text = "Galería de Fotos / Videos"
            celda.botonAgregar.tag = 1
            return celda.contentView
        case 1:
            if Globals.GaleriaModo == "GET" && Globals.GaleriaDocumentos.count == 0 {
                return nil
            }
            let celda = tableView.dequeueReusableCell(withIdentifier: "celda1") as! GaleriaFVDTVCell1
            celda.viewAgregar.isHidden = Globals.GaleriaModo == "GET"
            celda.tituloIzq.text = "Otros Documentos"
            celda.botonAgregar.tag = 2
            return celda.contentView
        default:
            break
        }
        return nil
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            if Globals.GaleriaModo == "GET" && Globals.GaleriaMultimedia.count == 0 {
                return CGFloat.leastNonzeroMagnitude
            }
            return 50
        case 1:
            if Globals.GaleriaModo == "GET" && Globals.GaleriaDocumentos.count == 0 {
                return CGFloat.leastNonzeroMagnitude
            }
            return 50
        default:
            return CGFloat.leastNonzeroMagnitude
        }
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let celda = tableView.dequeueReusableCell(withIdentifier: "celda2") as! CeldaGaleria
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
        case 1:
            let celda = tableView.dequeueReusableCell(withIdentifier: "celda3") as! CeldaDocumento
            let unit = Globals.GaleriaDocumentos[indexPath.row]
            celda.icono.image = unit.getIcon()
            if Globals.GaleriaDocIdRequests[indexPath.row] == -1 {
                celda.icono.isHidden = false
                celda.procentajeDescarga.isHidden = true
                celda.iconoCancelarDescarga.isHidden = true
            } else {
                celda.icono.isHidden = true
                celda.procentajeDescarga.isHidden = false
                celda.procentajeDescarga.text = "\(Globals.GaleriaDocPorcentajes[indexPath.row])%"
                celda.iconoCancelarDescarga.isHidden = false
            }
            celda.botonDescarga.tag = indexPath.row
            celda.nombre.text = unit.Descripcion
            celda.tamanho.text = unit.tamanho
            celda.viewX.isHidden = Globals.GaleriaModo == "GET"
            return celda
        default:
            break
        }
        return UITableViewCell()
    }
    // Table
    
    @IBAction func clickBotonTituloDer(_ sender: Any) {
        if !Utils.InteraccionHabilitada {
            return
        }
        
        switch (sender as! UIButton).tag {
        case 1:
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
        case 2:
            self.escogerDocumento()
        default:
            break
        }
    }
    
    @IBAction func clickImagen(_ sender: Any) {
        if !Utils.InteraccionHabilitada {
            return
        }
        
        let indice = (sender as! UIButton).tag
        let unit = Globals.GaleriaMultimedia[indice]
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
        }
    }
    
    @IBAction func clickImagenX(_ sender: Any) {
        if !Utils.InteraccionHabilitada {
            return
        }
        
        let indexToDel = (sender as! UIButton).tag
        let unit = Globals.GaleriaMultimedia[indexToDel]
        if unit.Correlativo != nil {
            Globals.GaleriaCorrelativosABorrar.insert(unit.Correlativo ?? 0)
        }
        Globals.GaleriaNombres.remove(unit.Descripcion ?? "")
        Globals.GaleriaMultimedia.remove(at: indexToDel)
        self.tableView.reloadSections([0], with: .none)
    }
    
    @IBAction func clickEliminarDocumento(_ sender: Any) {
        if !Utils.InteraccionHabilitada {
            return
        }
        
        let indexToDel = (sender as! UIButton).tag
        let unit = Globals.GaleriaDocumentos[indexToDel]
        if unit.Correlativo != nil {
            Globals.GaleriaCorrelativosABorrar.insert(unit.Correlativo ?? 0)
        }
        Globals.GaleriaNombres.remove(unit.Descripcion ?? "")
        Globals.GaleriaDocumentos.remove(at: indexToDel)
        self.tableView.reloadSections([1], with: .none)
    }
    
    @IBAction func clickDescarga(_ sender: Any) {
        let indice = (sender as! UIButton).tag
        let unit = Globals.GaleriaDocumentos[indice]
        if unit.Correlativo == nil {
            return
        }
        
        if Globals.GaleriaDocIdRequests[indice] == -1 {
            Globals.GaleriaDocIdRequests[indice] = Rest.generateId()
            // let celda = self.tableView.cellForRow(at: IndexPath.init(row: indice, section: 1)) as! CeldaDocumento
            self.tableView.reloadRows(at: [IndexPath.init(row: indice, section: 1)], with: .none)
            Rest.downloadFileTo(unit.Descripcion ?? "archivo", Routes.forDownloadFile(unit.Url!), false, Globals.GaleriaDocIdRequests[indice], {(progreso) in
                // let celda = self.tableView.cellForRow(at: IndexPath.init(row: indice, section: 1)) as! CeldaDocumento
                Globals.GaleriaDocPorcentajes[indice] = Int(progreso * 100)
                self.tableView.reloadRows(at: [IndexPath.init(row: indice, section: 1)], with: .none)
                print(progreso)
            }, {(response) in
                print(response.destinationURL)
                Rest.requests[Globals.GaleriaDocIdRequests[indice]] = nil
                Globals.GaleriaDocPorcentajes[indice] = 0
                Globals.GaleriaDocIdRequests[indice] = -1
                // self.tableView.cellForRow(at: IndexPath.init(row: indice, section: 1)).tag
                self.tableView.reloadRows(at: [IndexPath.init(row: indice, section: 1)], with: .none)
                if response.destinationURL != nil {
                    self.docController = UIDocumentInteractionController(url: NSURL.fileURL(withPath: response.destinationURL!.path))
                    self.docController?.delegate = self
                    self.docController?.presentOptionsMenu(from: self.descargaDocumentoBarButton, animated: true)
                }
            }, {(error) in
                print(error)
                Rest.requests[Globals.GaleriaDocIdRequests[indice]] = nil
                Globals.GaleriaDocIdRequests[indice] = -1
                self.tableView.reloadRows(at: [IndexPath.init(row: indice, section: 1)], with: .none)
            })
        } else {
            Rest.requests[Globals.GaleriaDocIdRequests[indice]]?.cancel()
            Rest.requests[Globals.GaleriaDocIdRequests[indice]] = nil
            Globals.GaleriaDocIdRequests[indice] = -1
            self.tableView.reloadRows(at: [IndexPath.init(row: indice, section: 1)], with: .none)
        }
    }
    
    
    
    func loadAssetVideo(asset: DKAsset) {
        var flagImage = false
        var flagVideoData = false
        var fotovideo = FotoVideo()
        fotovideo.TipoArchivo = asset.isVideo ? "TP02" : "TP01"
        // fotovideo.esVideo = asset.isVideo
        fotovideo.asset = asset
        fotovideo.Descripcion = PHAssetResource.assetResources(for: asset.originalAsset!).first?.originalFilename
        Utils.bloquearPantalla()
        asset.fetchImageWithSize(CGSize.init(width: 200, height: 200), completeBlock: {(image,info) in
            flagImage = true
            if let newImage = image {
                fotovideo.imagen = newImage
            }
            if flagImage && flagVideoData {
                Utils.desbloquearPantalla()
                Dict.unitToData(fotovideo)
                if fotovideo.imagen != nil && fotovideo.multimediaData != nil && !Globals.GaleriaNombres.contains(fotovideo.Descripcion ?? "") {
                    Globals.GaleriaMultimedia.append(fotovideo)
                    Globals.GaleriaNombres.insert(fotovideo.Descripcion ?? "")
                    self.tableView.reloadData()
                }
            }
        })
        PHImageManager.default().requestAVAsset(forVideo: asset.originalAsset!, options: nil, resultHandler: {(avasset,mix,info) in
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
                if fotovideo.imagen != nil && fotovideo.multimediaData != nil && !Globals.GaleriaNombres.contains(fotovideo.Descripcion ?? "") {
                    Globals.GaleriaMultimedia.append(fotovideo)
                    Globals.GaleriaNombres.insert(fotovideo.Descripcion ?? "")
                    self.tableView.reloadData()
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
                if !(fotovideo.imagen == nil) && !(fotovideo.multimediaData == nil) && !Globals.GaleriaNombres.contains(fotovideo.Descripcion ?? "") {
                    Globals.GaleriaMultimedia.append(fotovideo)
                    Globals.GaleriaNombres.insert(fotovideo.Descripcion ?? "")
                    self.tableView.reloadData()
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
                    self.tableView.reloadData()
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
                    self.tableView.reloadData()
                }
            }
        })
    }
}

class GaleriaFVDTVCell1: UITableViewCell {
    @IBOutlet weak var tituloIzq: UILabel!
    @IBOutlet weak var botonAgregar: UIButton!
    @IBOutlet weak var viewAgregar: UIView!
}
