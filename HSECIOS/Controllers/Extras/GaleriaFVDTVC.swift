import UIKit
import DKImagePickerController
import Photos
import AVKit
import MobileCoreServices

class GaleriaFVDTVC: UITableViewController, UIDocumentMenuDelegate, UIDocumentPickerDelegate, UINavigationControllerDelegate {
    
    // var editable = true
    var modo = "GET"
    var codigo = ""
    
    var fotosyvideos: [FotoVideo] = []
    var documentos: [DocumentoGeneral] = []
    
    override func viewDidAppear(_ animated: Bool) {
        if modo == "GET" {
            
        } else {
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // Document Picker
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        let documento = DocumentoGeneral()
        documento.url = url
        documento.data = NSData.init(contentsOf: url)!
        documento.nombre = url.lastPathComponent
        documento.tamanho = Utils.getSizeFromFile(file: documento.data)
        self.documentos.append(documento)
        self.tableView.reloadData()
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
            return self.fotosyvideos.count/2 + self.fotosyvideos.count%2
        case 1:
            return documentos.count
        default:
            return 0
        }
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0:
            if self.modo != "GET" || self.fotosyvideos.count > 0 {
                let celda = tableView.dequeueReusableCell(withIdentifier: "celda1") as! GaleriaFVDTVCell1
                celda.viewAgregar.isHidden = false //!self.editable
                celda.tituloIzq.text = "Galería de Fotos / Videos"
                celda.botonAgregar.tag = 1
                celda.contentView.backgroundColor = UIColor.red
                return celda.contentView
            }
        case 1:
            if self.modo != "GET" || self.documentos.count > 0 {
                let celda = tableView.dequeueReusableCell(withIdentifier: "celda1") as! GaleriaFVDTVCell1
                celda.viewAgregar.isHidden = false //!self.editable
                celda.tituloIzq.text = "Otros Documentos"
                celda.contentView.backgroundColor = UIColor.red
                celda.botonAgregar.tag = 2
                return celda.contentView
            }
        default:
            break
        }
        return nil
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if self.modo != "GET" || (section == 0 && self.fotosyvideos.count > 0) || (section == 1 && self.documentos.count > 0) {
            return 50
        }
        return CGFloat.leastNonzeroMagnitude
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            var celda = tableView.dequeueReusableCell(withIdentifier: "celda2") as! CeldaGaleria
            let dataIzq = self.fotosyvideos[indexPath.row * 2]
            let dataDer: FotoVideo? = indexPath.row * 2 + 1 >= self.fotosyvideos.count ? nil : self.fotosyvideos[indexPath.row * 2 + 1]
            
            celda.viewX1.isHidden = false //!editable
            celda.viewX2.isHidden = false //!editable
            celda.play1.isHidden = !dataIzq.esVideo
            celda.play2.isHidden = !(dataDer?.esVideo ?? false)
            celda.imagen2.isHidden = dataDer == nil
            if dataIzq.asset == nil {
                Images.loadImagePreviewFromCode("\(dataIzq.Correlativo ?? 0)", celda.imagen1, {
                    tableView.reloadRows(at: [indexPath], with: .none)
                })
            } else {
                celda.imagen1.image = dataIzq.imagen
            }
            if let newdataDer = dataDer {
                if newdataDer.asset == nil {
                    Images.loadImagePreviewFromCode("\(newdataDer.Correlativo ?? 0)", celda.imagen2, {
                        tableView.reloadRows(at: [indexPath], with: .none)
                    })
                } else {
                    celda.imagen2.image = newdataDer.imagen
                }
            }
            // Utils.initCeldaGaleria(&celda, dataIzq, dataDer, self.editable, tableView, indexPath)
            return celda
            /*let celda = tableView.dequeueReusableCell(withIdentifier: "celda2") as! GaleriaFVDTVCell2
            celda.viewXIzq.isHidden = !self.editable
            celda.viewXDer.isHidden = !self.editable
            
            let unitIzq = self.fotosyvideos[indexPath.row * 2]
            celda.imagenPlayIzq.isHidden = !unitIzq.esVideo
            
            if unitIzq.asset == nil {
                Images.loadImagePreviewFromCode(unitIzq.multimedia.Correlativo, celda.imagenIzq, tableView, indexPath)
            } else {
                celda.imagenIzq.image = unitIzq.imagen
            }
            let mostrarCeldaDer = indexPath.row * 2 + 1 != self.fotosyvideos.count
            print("\(indexPath.row) - \(mostrarCeldaDer)")
            if mostrarCeldaDer {
                let unitDer = self.fotosyvideos[indexPath.row * 2 + 1]
                celda.viewDer.isHidden = false
                celda.imagenPlayDer.isHidden = false
                celda.viewXDer.isHidden = false
                celda.imagenPlayDer.isHidden = !unitDer.esVideo
                if unitDer.asset == nil {
                    
                } else {
                    celda.imagenDer.isHidden = false
                    celda.imagenDer.image = unitDer.imagen
                }
            } else {
                celda.imagenPlayDer.isHidden = true
                celda.imagenDer.isHidden = true
                celda.viewXDer.isHidden = true
            }
            return celda*/
        case 1:
            let celda = tableView.dequeueReusableCell(withIdentifier: "celda3") as! AddObsPVCTab3Cell3
            let unit = documentos[indexPath.row]
            celda.icono.image = Images.alertaVerde
            celda.nombre.text = unit.nombre
            celda.tamanho.text = unit.tamanho
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
            pickerController.didSelectAssets = { (assets: [DKAsset]) in
                if assets.count > 0 {
                    self.loadAssets(assets: assets)
                }
            }
            self.present(pickerController, animated: true) {}
        case 2:
            self.escogerDocumento()
        default:
            break
        }
    }
    
    @IBAction func clickImagenIzq(_ sender: Any) {
        var superView = (sender as AnyObject).superview??.superview
        while !(superView is CeldaGaleria) {
            superView = superView?.superview
        }
        let celda = superView as! CeldaGaleria
        var indice = (self.tableView.indexPath(for: celda)!.row) * 2
        let unit = self.fotosyvideos[indice]
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
                for i in 0..<self.fotosyvideos.count {
                    let foto = self.fotosyvideos[i]
                    if !foto.esVideo {
                        fotos.append(foto)
                        
                    } else if i < indice {
                            print("\(i) - \(self.fotosyvideos.count) - \(indice)")
                            indice = indice - 1
                        }
                    
                }
                print("fotosyvideos count: \(self.fotosyvideos.count) - indice = \(indice)")
                Images.showGallery(fotos: fotos, index: indice, viewController: self)
            }
            
        }
    }
    
    @IBAction func clickImagenDer(_ sender: Any) {
        /*var superView = (sender as AnyObject).superview??.superview
        while !(superView is AddObsPVCTab3Cell2) {
            superView = superView?.superview
        }
        let celda = superView as! AddObsPVCTab3Cell2
        var indexToShow = (self.tableView.indexPath(for: celda)!.row) * 2 + 1
        if assetIsVideoFlag[indexToShow] {
            assets[indexToShow].fetchAVAssetWithCompleteBlock({(video, info) in
                let playerAV = AVPlayer.init(playerItem: AVPlayerItem.init(asset: video!))
                let playerViewController = AVPlayerViewController()
                playerViewController.player = playerAV
                self.present(playerViewController, animated: true) {
                    playerViewController.player!.play()
                }
            })
        } else {
            var imageAssets = [DKAsset].init(self.assets)
            for i in (0..<assetIsVideoFlag.count).reversed() {
                if assetIsVideoFlag[i] {
                    imageAssets.remove(at: i)
                    if i < indexToShow {
                        indexToShow = indexToShow - 1
                    }
                }
            }
            Images.showGallery(assets: imageAssets, index: indexToShow, viewController: self.parent!)
        }*/
    }
    
    @IBAction func clickImagenIzqX(_ sender: Any) {
        var superView = (sender as AnyObject).superview??.superview
        while !(superView is GaleriaFVDTVCell2) {
            superView = superView?.superview
        }
        let celda = superView as! GaleriaFVDTVCell2
        let indexToDel = (self.tableView.indexPath(for: celda)!.row) * 2
        self.fotosyvideos.remove(at: indexToDel)
        self.tableView.reloadData()
    }
    
    @IBAction func clickImagenDerX(_ sender: Any) {
        var superView = (sender as AnyObject).superview??.superview
        while !(superView is GaleriaFVDTVCell2) {
            superView = superView?.superview
        }
        let celda = superView as! GaleriaFVDTVCell2
        let indexToDel = (self.tableView.indexPath(for: celda)!.row) * 2 + 1
        self.fotosyvideos.remove(at: indexToDel)
        self.tableView.reloadData()
    }
    
    func loadAssets(assets: [DKAsset]) {
        var nombres: [String] = []
        for i in 0..<self.fotosyvideos.count {
            nombres.append(self.fotosyvideos[i].nombre)
        }
        for i in 0..<assets.count {
            assets[i].fetchImageWithSize(CGSize.init(width: 200, height: 200), completeBlock: {(image, info) in
                var unit = FotoVideo()
                unit.asset = assets[i]
                unit.esVideo = assets[i].isVideo
                unit.imagen = image ?? Images.blank
                print(i)
                print(image == nil ? "tiene imagen" : "no tiene imagen")
                if let nombre = PHAssetResource.assetResources(for: assets[i].originalAsset!).first?.originalFilename {
                    unit.nombre = nombre
                    print(nombre)
                    print(String.init(data: Dict.unitToData(unit)!, encoding: .utf8))
                } else {
                    if let info = info {
                        if info.keys.contains(NSString(string: "PHImageFileURLKey")) {
                            if let path = info[NSString(string: "PHImageFileURLKey")] as? NSURL {
                                print(path)
                            }
                        }
                    }
                }
                
                PHAssetResource.assetResources(for: assets[i].originalAsset!)
                if nombres.count == 0 || !nombres.contains(unit.nombre) {
                    self.fotosyvideos.append(unit)
                    nombres.append(unit.nombre)
                    self.tableView.reloadData()
                }
            })
        }
    }
}

class GaleriaFVDTVCell1: UITableViewCell {
    @IBOutlet weak var tituloIzq: UILabel!
    @IBOutlet weak var botonAgregar: UIButton!
    @IBOutlet weak var viewAgregar: UIView!
}

class GaleriaFVDTVCell2: UITableViewCell {
    @IBOutlet weak var imagenIzq: UIImageView!
    @IBOutlet weak var imagenDer: UIImageView!
    @IBOutlet weak var viewDer: UIView!
    @IBOutlet weak var imagenPlayIzq: UIImageView!
    @IBOutlet weak var imagenPlayDer: UIImageView!
    @IBOutlet weak var botonImagenDer: UIButton!
    @IBOutlet weak var viewXIzq: UIView!
    @IBOutlet weak var viewXDer: UIView!
}

class GaleriaFVDTVCell3: UITableViewCell {
    @IBOutlet weak var icono: UIImageView!
    @IBOutlet weak var nombre: UILabel!
    @IBOutlet weak var tamanho: UILabel!
    @IBOutlet weak var viewX: UIView!
}
