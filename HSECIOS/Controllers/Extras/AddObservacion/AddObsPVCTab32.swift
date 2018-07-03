import UIKit
import DKImagePickerController
import Photos
import AVKit
import MobileCoreServices

class AddObsPVCTab32: UITableViewController, UIDocumentMenuDelegate, UIDocumentPickerDelegate, UINavigationControllerDelegate {
    
    var assets: [DKAsset] = []
    var assetFinishFetchFlag: [Bool] = []
    var assetIsVideoFlag: [Bool] = []
    var assetNames: [String] = []
    var imagenes: [UIImage] = []
    var documentos: [DocumentoGeneral] = []
    
    override func viewDidAppear(_ animated: Bool) {
        if let padre = self.parent?.parent as? UpsertObsVC {
            padre.selectTab(2)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        //let myURL = url as URL
        //print(myURL.lastPathComponent)
        //print("import result : \(myURL)")
        //print("url: \(url.absoluteString)")
        //let data = NSData.init(contentsOf: myURL)!
        let documento = DocumentoGeneral()
        documento.url = url
        documento.data = NSData.init(contentsOf: url)!
        documento.nombre = url.lastPathComponent
        documento.tamanho = Utils.getSizeFromFile(file: documento.data)
        self.documentos.append(documento)
        //self.tableView.reloadSections(IndexSet.init(integer: 1), with: .automatic)
        self.tableView.reloadData()
        
    }
    
    func documentMenu(_ documentMenu: UIDocumentMenuViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController) {
        documentPicker.delegate = self
        present(documentPicker, animated: true, completion: nil)
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("view was cancelled")
        //dismiss(animated: true, completion: nil)
    }
    
    func escogerDocumento(){
        let importMenu = UIDocumentMenuViewController(documentTypes: [String(kUTTypePDF), "com.microsoft.word.doc", "org.openxmlformats.wordprocessingml.document", "com.microsoft.excel.xls", "org.openxmlformats.spreadsheetml.sheet", "com.microsoft.powerpoint.​ppt", "org.openxmlformats.presentationml.presentation"], in: .import)
        importMenu.delegate = self
        importMenu.modalPresentationStyle = .formSheet
        
        self.present(importMenu, animated: true, completion: nil)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return assets.count/2 + assets.count%2
        case 1:
            return documentos.count
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let celda = tableView.dequeueReusableCell(withIdentifier: "celda1") as! AddObsPVCTab3Cell1
        switch section {
        case 0:
            celda.titulo.text = "Galería de Fotos / Videos"
            celda.botonTituloDer.tag = 1
        case 1:
            celda.titulo.text = "Otros Documentos"
            celda.botonTituloDer.tag = 2
        default:
            break
        }
        return celda
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let celda = tableView.dequeueReusableCell(withIdentifier: "celda2") as! AddObsPVCTab3Cell2
            let newIndex = indexPath.row
            celda.imagen1.image = self.imagenes[newIndex * 2]
            celda.imagenPlay1.isHidden = !self.assetIsVideoFlag[newIndex * 2]
            if newIndex * 2 + 1 != self.assets.count {
                celda.extraview.isHidden = false
                celda.imagenPlay2.isHidden = false
                celda.imagen2.isHidden = false
                celda.imagenXView2.isHidden = false
                celda.imagen2.image = self.imagenes[newIndex * 2 + 1]
                celda.imagenPlay2.isHidden = !self.assetIsVideoFlag[newIndex * 2 + 1]
            } else {
                celda.imagenPlay2.isHidden = true
                celda.imagen2.isHidden = true
                celda.imagenXView2.isHidden = true
            }
            return celda
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
    
    @IBAction func clickBotonTituloDer(_ sender: Any) {
        print((sender as! UIButton).tag)
        //let botonDer = sender as! UIButton
        switch (sender as! UIButton).tag {
        case 1:
            print("Click en 1")
            let pickerController = DKImagePickerController()
            pickerController.didSelectAssets = { (assets: [DKAsset]) in
                if assets.count > 0 {
                    self.loadAssets(assets: assets)
                }
            }
            self.present(pickerController, animated: true) {}
        case 2:
            print("Click en 2")
            self.escogerDocumento()
        default:
            break
        }
    }
    
    @IBAction func clickImagenIzq(_ sender: Any) {
        var superView = (sender as AnyObject).superview??.superview
        while !(superView is AddObsPVCTab3Cell2) {
            superView = superView?.superview
        }
        let celda = superView as! AddObsPVCTab3Cell2
        var indexToShow = (self.tableView.indexPath(for: celda)!.row) * 2
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
            // Images.showGallery(assets: imageAssets, index: indexToShow, viewController: self.parent!)
        }
    }
    
    @IBAction func clickImagenDer(_ sender: Any) {
        var superView = (sender as AnyObject).superview??.superview
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
            // Images.showGallery(assets: imageAssets, index: indexToShow, viewController: self.parent!)
        }
    }
    
    @IBAction func clickImagenIzqX(_ sender: Any) {
        var superView = (sender as AnyObject).superview??.superview
        while !(superView is AddObsPVCTab3Cell2) {
            superView = superView?.superview
        }
        let celda = superView as! AddObsPVCTab3Cell2
        let indexToDel = (self.tableView.indexPath(for: celda)!.row) * 2
        self.assets.remove(at: indexToDel)
        self.imagenes.remove(at: indexToDel)
        self.assetIsVideoFlag.remove(at: indexToDel)
        self.assetNames.remove(at: indexToDel)
        self.tableView.reloadData()
        print("click imagen izq - x")
        print("Assets Names")
        print(self.assetNames)
        print("Assets is Video")
        print(self.assetIsVideoFlag)
    }
    
    @IBAction func clickImagenDerX(_ sender: Any) {
        var superView = (sender as AnyObject).superview??.superview
        while !(superView is AddObsPVCTab3Cell2) {
            superView = superView?.superview
        }
        let celda = superView as! AddObsPVCTab3Cell2
        let indexToDel = (self.tableView.indexPath(for: celda)!.row) * 2 + 1
        self.assets.remove(at: indexToDel)
        self.imagenes.remove(at: indexToDel)
        self.assetIsVideoFlag.remove(at: indexToDel)
        self.assetNames.remove(at: indexToDel)
        self.tableView.reloadData()
        print("click imagen der - x")
        print("Assets Names")
        print(self.assetNames)
        print("Assets is Video")
        print(self.assetIsVideoFlag)
    }
    
    func loadAssets(assets: [DKAsset]) {
        self.assetFinishFetchFlag = [Bool].init(repeating: false, count: assets.count)
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
        }
    }
    
}

class AddObsPVCTab3Cell1: UITableViewCell {
    @IBOutlet weak var titulo: UILabel!
    @IBOutlet weak var botonTituloDer: UIButton!
}

class AddObsPVCTab3Cell2: UITableViewCell {
    @IBOutlet weak var imagen1: UIImageView!
    @IBOutlet weak var imagen2: UIImageView!
    @IBOutlet weak var extraview: UIView!
    @IBOutlet weak var imagenPlay1: UIImageView!
    @IBOutlet weak var imagenPlay2: UIImageView!
    @IBOutlet weak var imagenBoton2: UIButton!
    @IBOutlet weak var imagenXView2: UIView!
}

class AddObsPVCTab3Cell3: UITableViewCell {
    @IBOutlet weak var icono: UIImageView!
    @IBOutlet weak var nombre: UILabel!
    @IBOutlet weak var tamanho: UILabel!
    
    @IBOutlet weak var borrarDocView: UIView!
    
    
}
