import UIKit
import DKImagePickerController

class GaleriaImgVidTVC: UITableViewController {
    
    var assets: [DKAsset] = []
    var assetFinishFetchFlag: [Bool] = []
    var assetIsVideoFlag: [Bool] = []
    var imagenes: [UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.assets = []
        self.assetFinishFetchFlag = []
        self.assetIsVideoFlag = []
        self.imagenes = []
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func loadAssets(assets: [DKAsset]) {
        self.assetFinishFetchFlag = [Bool].init(repeating: false, count: assets.count)
        var newAssetIsVideoFlag = [Bool].init(repeating: false, count: assets.count)
        var newImagenes = [UIImage].init(repeating: Images.blank, count: assets.count)
        for i in 0..<assets.count {
            newAssetIsVideoFlag[i] = assets[i].isVideo
            assets[i].fetchImageWithSize(CGSize.init(width: 200, height: 200), completeBlock: {(image, info) in
                self.assetFinishFetchFlag[i] = true
                if let newimage = image {
                    newImagenes[i] = newimage
                }
                var tempFlag = true
                for i in 0..<self.assetFinishFetchFlag.count {
                    tempFlag = tempFlag && self.assetFinishFetchFlag[i]
                }
                if tempFlag {
                    print("\(self.assets.count) - \(self.imagenes.count) - \(self.assetIsVideoFlag.count)")
                    self.assetIsVideoFlag.append(contentsOf: newAssetIsVideoFlag)
                    self.assets.append(contentsOf: assets)
                    self.imagenes.append(contentsOf: newImagenes)
                    self.tableView.reloadData()
                    return
                }
            })
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return assets.count/2 + assets.count%2
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: "celda") as! GaleriaImgVidTVCell
        celda.imagen1.image = self.imagenes[indexPath.row*2]
        if indexPath.row*2 + 1 != assets.count {
            celda.extraview.isHidden = false
            celda.imagen2.image = self.imagenes[indexPath.row*2 + 1]
        } else {
            celda.extraview.isHidden = true
        }
        return celda
    }
    
    @IBAction func clickEnImagenIzq(_ sender: Any) {
        var superView = (sender as AnyObject).superview??.superview
        while !(superView is GaleriaImgVidTVCell) {
            superView = superView?.superview
        }
        let celda = superView as! GaleriaImgVidTVCell
        let indexToShow = self.tableView.indexPath(for: celda)!.row * 2
        // Images.showGallery(assets: self.assets, index: indexToShow, viewController: self.parent!)
    }
    
    @IBAction func clickEnImagenDer(_ sender: Any) {
        var superView = (sender as AnyObject).superview??.superview
        while !(superView is GaleriaImgVidTVCell) {
            superView = superView?.superview
        }
        let celda = superView as! GaleriaImgVidTVCell
        let indexToShow = self.tableView.indexPath(for: celda)!.row * 2 + 1
        // Images.showGallery(assets: self.assets, index: indexToShow, viewController: self.parent!)
    }
    
    @IBAction func clickEnXImagenIzq(_ sender: Any) {
        var superView = (sender as AnyObject).superview??.superview
        while !(superView is GaleriaImgVidTVCell) {
            superView = superView?.superview
        }
        let celda = superView as! GaleriaImgVidTVCell
        let indexToDel = self.tableView.indexPath(for: celda)!.row * 2
        self.assets.remove(at: indexToDel)
        self.imagenes.remove(at: indexToDel)
        self.assetIsVideoFlag.remove(at: indexToDel)
        self.tableView.reloadData()
    }
    
    @IBAction func clickEnXImagenDer(_ sender: Any) {
        var superView = (sender as AnyObject).superview??.superview
        while !(superView is GaleriaImgVidTVCell) {
            superView = superView?.superview
        }
        let celda = superView as! GaleriaImgVidTVCell
        let indexToDel = self.tableView.indexPath(for: celda)!.row * 2 + 1
        self.assets.remove(at: indexToDel)
        self.imagenes.remove(at: indexToDel)
        self.assetIsVideoFlag.remove(at: indexToDel)
        self.tableView.reloadData()
    }
    
}

class GaleriaImgVidTVCell: UITableViewCell {
    @IBOutlet weak var imagen1: UIImageView!
    @IBOutlet weak var imagen2: UIImageView!
    @IBOutlet weak var extraview: UIView!
}

