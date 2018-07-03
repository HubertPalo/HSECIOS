import UIKit

class GaleriaFVDVC: UIViewController {
    
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var galeriaContainer: UIView!
    
    var galeria = GaleriaFVDTVC()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.galeria = self.childViewControllers[0] as! GaleriaFVDTVC
        self.viewContainer.isHidden = false
        self.galeriaContainer.isHidden = true
    }
    
    func loadGaleria(_ codigo: String) {
        self.galeria.modo = "GET"
        Rest.getDataGeneral(Routes.forMultimedia(codigo), false, success: {(resultValue:Any?,data:Data?) in
            let arrayMultimedia: ArrayGeneral<Multimedia> = Dict.dataToArray(data!)
            let files = arrayMultimedia.Data
            var multimedia: [FotoVideo] = []
            var documentos: [DocumentoGeneral] = []
            
            for i in 0..<files.count {
                switch files[i].TipoArchivo ?? "" {
                case "TP01":
                    multimedia.append(files[i].toFotoVideo())
                    break
                case "TP02":
                    multimedia.append(files[i].toFotoVideo())
                    break
                case "TP03":
                    documentos.append(files[i].toDocumentoGeneral())
                    break
                default:
                    break
                }
            }
            
            self.viewContainer?.isHidden = !(files.count == 0)
            self.galeriaContainer?.isHidden = files.count == 0
            self.galeria.documentos = documentos
            self.galeria.fotosyvideos = multimedia
            self.galeria.tableView.reloadData()
            self.galeria.tableView.bounces = false
        }, error: nil)
        /*Rest.getData(Routes.forMultimedia(codigo), false, vcontroller: self, success: {(dict: NSDictionary) in
            let files: [Multimedia] = Dict.toArrayMultimedia(dict)
            var multimedia: [FotoVideo] = []
            var documentos: [DocumentoGeneral] = []
            
            for i in 0..<files.count {
                switch files[i].TipoArchivo ?? "" {
                case "TP01":
                    multimedia.append(files[i].toFotoVideo())
                    break
                case "TP02":
                    multimedia.append(files[i].toFotoVideo())
                    break
                case "TP03":
                    documentos.append(files[i].toDocumentoGeneral())
                    break
                default:
                    break
                }
            }
            
            self.viewContainer?.isHidden = !(files.count == 0)
            self.galeriaContainer?.isHidden = files.count == 0
            self.galeria.documentos = documentos
            self.galeria.fotosyvideos = multimedia
            self.galeria.tableView.reloadData()
            self.galeria.tableView.bounces = false
        })*/
    }
    
    func loadModoPOST() {
        self.galeria.modo = "POST"
        self.galeriaContainer.isHidden = false
        self.viewContainer.isHidden = true
        self.galeria.tableView.reloadData()
    }
    
    
}
