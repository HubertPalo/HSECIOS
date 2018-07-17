import UIKit

class GaleriaFVDVC: UIViewController {
    
    @IBOutlet var viewContainer: UIView!
    @IBOutlet var galeriaContainer: UIView!
    
    var galeria = GaleriaFVDTVC()
    
    override func viewWillAppear(_ animated: Bool) {
        self.viewContainer.isHidden = Globals.GaleriaVCViewContainerIsHidden
        self.galeriaContainer.isHidden = Globals.GaleriaVCGaleriaContainerIsHidden
        self.galeria.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.galeria = self.childViewControllers[0] as! GaleriaFVDTVC
        self.galeriaContainer.isHidden = true
        self.viewContainer.isHidden = true
    }
    
    
    /*func loadModoPOST() {
        self.modo = "ADD"
        self.galeria.modo = "ADD"
        self.galeria.fotosyvideos = []
        self.galeria.documentos = []
        self.galeria.nombres.removeAll()
        self.galeriaContainer?.isHidden = false
        self.viewContainer?.isHidden = true
        self.galeria.tableView.reloadData()
    }
    
    func loadModoPUT(_ codigo: String) {
        self.modo = "PUT"
        self.codigo = codigo
        self.galeria.modo = "PUT"
        self.galeria.fotosyvideos = []
        self.galeria.documentos = []
        self.galeria.nombres.removeAll()
        Rest.getDataGeneral(Routes.forMultimedia(codigo), true, success: {(resultValue:Any?,data:Data?) in
            let arrayMultimedia: ArrayGeneral<Multimedia> = Dict.dataToArray(data!)
            self.galeriaContainer?.isHidden = arrayMultimedia.Count == 0
            self.viewContainer?.isHidden = arrayMultimedia.Count != 0
            for multimedia in arrayMultimedia.Data {
                switch multimedia.TipoArchivo ?? "" {
                case "TP01":
                    self.galeria.fotosyvideos.append(multimedia.toFotoVideo())
                    Images.downloadCorrelativo("\(multimedia.Correlativo ?? 0)", {(self.galeria.tableView.reloadData())})
                    break
                case "TP02":
                    self.galeria.fotosyvideos.append(multimedia.toFotoVideo())
                    Images.downloadCorrelativo("\(multimedia.Correlativo ?? 0)", {(self.galeria.tableView.reloadData())})
                    break
                default:
                    self.galeria.documentos.append(multimedia.toDocumentoGeneral())
                    break
                }
            }
            self.galeria.tableView.reloadData()
        }, error: {(error) in
            
        })
    }
    
    func loadModoGET(_ codigo: String) {
        self.modo = "GET"
        self.codigo = codigo
        self.galeria.modo = "GET"
        self.galeria.fotosyvideos = []
        self.galeria.documentos = []
        self.galeria.nombres.removeAll()
        Rest.getDataGeneral(Routes.forMultimedia(codigo), true, success: {(resultValue:Any?,data:Data?) in
            let arrayMultimedia: ArrayGeneral<Multimedia> = Dict.dataToArray(data!)
            self.galeriaContainer?.isHidden = arrayMultimedia.Count == 0
            self.viewContainer?.isHidden = arrayMultimedia.Count != 0
            for multimedia in arrayMultimedia.Data {
                switch multimedia.TipoArchivo ?? "" {
                case "TP01":
                    self.galeria.fotosyvideos.append(multimedia.toFotoVideo())
                    Images.downloadCorrelativo("\(multimedia.Correlativo ?? 0)", {(self.galeria.tableView.reloadData())})
                    break
                case "TP02":
                    self.galeria.fotosyvideos.append(multimedia.toFotoVideo())
                    Images.downloadCorrelativo("\(multimedia.Correlativo ?? 0)", {(self.galeria.tableView.reloadData())})
                    break
                default:
                    self.galeria.documentos.append(multimedia.toDocumentoGeneral())
                    break
                }
            }
            self.galeria.tableView.reloadData()
        }, error: {(error) in
            
        })
    }*/
    
}
