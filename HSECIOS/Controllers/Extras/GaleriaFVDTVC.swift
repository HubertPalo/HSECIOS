import UIKit
import DKImagePickerController
import Photos
import AVKit
import MobileCoreServices

class GaleriaFVDTVC: UITableViewController, UIDocumentMenuDelegate, UIDocumentPickerDelegate, UINavigationControllerDelegate {
    
    // var modo = "GET"
    // var codigo = ""
    
    /*var fotosyvideos: [FotoVideo] = []
    var documentos: [DocumentoGeneral] = []
    var nombres: Set<String> = Set<String>()
    var correlativosToDel = Set<Int>()*/
    
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
            documento.tamanho = Utils.getSizeFromFile(file: documento.data)
            documento.multimediaData = try Data.init(contentsOf: url)
            let fileSize = documento.multimediaData?.count ?? 1024*1024*8
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
            let dataIzq = Globals.GaleriaMultimedia[indexPath.row * 2]
            
            let dataDer: FotoVideo? = indexPath.row * 2 + 1 >= Globals.GaleriaMultimedia.count ? nil : Globals.GaleriaMultimedia[indexPath.row * 2 + 1]
            
            celda.boton1.tag = indexPath.row * 2
            celda.botonX1.tag = indexPath.row * 2
            celda.boton2.tag = indexPath.row * 2 + 1
            celda.botonX2.tag = indexPath.row * 2 + 1
            celda.viewX1.isHidden = Globals.GaleriaModo == "GET"// false //!editable
            celda.viewX2.isHidden = Globals.GaleriaModo == "GET"// false //!editable
            celda.play1.isHidden = !dataIzq.esVideo
            celda.play2.isHidden = !(dataDer?.esVideo ?? false)
            celda.imagen2.isHidden = dataDer == nil
            if dataIzq.asset == nil {
                if dataIzq.Correlativo != nil {
                    celda.imagen1.image = Images.getImageFor("P-\(dataIzq.Correlativo!)")
                }
                /*Images.loadImagePreviewFromCode("\(dataIzq.Correlativo ?? 0)", celda.imagen1, {
                    tableView.reloadRows(at: [indexPath], with: .none)
                })*/
            } else {
                celda.imagen1.image = dataIzq.imagen
            }
            if let newdataDer = dataDer {
                if newdataDer.asset == nil {
                    if newdataDer.Correlativo != nil {
                        celda.imagen2.image = Images.getImageFor("P-\(newdataDer.Correlativo!)")
                    }
                    /*Images.loadImagePreviewFromCode("\(newdataDer.Correlativo ?? 0)", celda.imagen2, {
                        tableView.reloadRows(at: [indexPath], with: .none)
                    })*/
                } else {
                    celda.imagen2.image = newdataDer.imagen
                }
            }
            return celda
        case 1:
            let celda = tableView.dequeueReusableCell(withIdentifier: "celda3") as! CeldaDocumento
            let unit = Globals.GaleriaDocumentos[indexPath.row]
            celda.icono.image = Images.alertaVerde
            celda.nombre.text = unit.Descripcion
            celda.tamanho.text = unit.tamanho
            celda.viewX.isHidden = false
            return celda
        default:
            break
        }
        return UITableViewCell()
    }
    // Table
    
    @IBAction func clickBotonTituloDer(_ sender: Any) {
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
        var indice = (sender as! UIButton).tag
        let unit = Globals.GaleriaMultimedia[indice]
        if unit.esVideo {
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
            if unit.asset == nil {
                
            } else {
                var fotos: [FotoVideo] = []
                print(indice)
                for i in 0..<Globals.GaleriaMultimedia.count {
                    let foto = Globals.GaleriaMultimedia[i]
                    if !foto.esVideo {
                        fotos.append(foto)
                        
                    } else if i < indice {
                            print("\(i) - \(Globals.GaleriaMultimedia.count) - \(indice)")
                            indice = indice - 1
                        }
                    
                }
                print("fotosyvideos count: \(Globals.GaleriaMultimedia.count) - indice = \(indice)")
                Images.showGallery(fotos: fotos, index: indice, viewController: self)
            }
            
        }
    }
    
    @IBAction func clickImagenX(_ sender: Any) {
        let indexToDel = (sender as! UIButton).tag
        let unit = Globals.GaleriaMultimedia[indexToDel]
        
        if Globals.GaleriaModo == "PUT" && unit.Correlativo != nil {
            Globals.GaleriaCorrelativosABorrar.insert(unit.Correlativo ?? 0)
        }
        Globals.GaleriaNombres.remove(unit.Descripcion ?? "")
        Globals.GaleriaMultimedia.remove(at: indexToDel)
        self.tableView.reloadSections([0], with: .none)
    }
    
    @IBAction func clickEliminarDocumento(_ sender: Any) {
        let boton = sender as! UIButton
        Globals.GaleriaNombres.remove(Globals.GaleriaDocumentos[boton.tag].Descripcion ?? "")
        Globals.GaleriaDocumentos.remove(at: boton.tag)
        self.tableView.reloadSections([1], with: .none)
    }
    
    
    func loadAssetVideo(asset: DKAsset) {
        var flagImage = false
        var flagVideoData = false
        var fotovideo = FotoVideo()
        fotovideo.esVideo = asset.isVideo
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
        fotovideo.esVideo = asset.isVideo
        fotovideo.asset = asset
        fotovideo.Descripcion = PHAssetResource.assetResources(for: asset.originalAsset!).first?.originalFilename
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
