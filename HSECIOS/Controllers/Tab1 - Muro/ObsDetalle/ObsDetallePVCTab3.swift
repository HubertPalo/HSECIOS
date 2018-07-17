import UIKit

class ObsDetallePVCTab3: UIViewController {
    
    var galeria = GaleriaFVDVC()
    var padre = ObsDetalleVC()
    var observacion = MuroElement()
    
    // var documentos: [Multimedia] = []
    // var multimedia: [Multimedia] = []
    
    override func viewWillAppear(_ animated: Bool) {
        //self.galeria.modo = "GET"
        //self.galeria.codigo = self.observacion.Codigo ?? ""
        /*self.galeria.galeria.fotosyvideos = []
        self.galeria.galeria.documentos = []
        self.galeria.galeria.nombres.removeAll()*/
        self.galeria.galeria.tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let padre = self.parent?.parent as? ObsDetalleVC {
            padre.selectTab(2)
        }
        // self.galeria.codigo = self.observacion.Codigo ?? ""
        /*Helper.getData(Routes.forMultimedia(Utils.selectedObsCode), true, vcontroller: self, success: {(dict: NSDictionary) in
            let adjuntos = Dict.toArrayMultimedia(dict)
            self.documentos = []
            self.multimedia = []
            if adjuntos.count == 0 {
                let popup = UIViewController()
                popup.modalPresentationStyle = .overCurrentContext
                popup.view.backgroundColor = UIColor.black
                
                self.present(popup, animated: true, completion: nil)
            } else {
                for i in 0..<adjuntos.count {
                    switch adjuntos[i].TipoArchivo {
                    case "TP01":
                        self.multimedia.append(adjuntos[i])
                        break
                    case "TP02":
                        self.multimedia.append(adjuntos[i])
                        break
                    case "TP03":
                        self.documentos.append(adjuntos[i])
                        break
                    default:
                        break
                    }
                }
                self.tabla1.reloadData()
                self.tabla2.reloadData()
            }
        })*/
        //HMuro.getObservacionesMultimedia(codeObs, vcontroller: self, success: successGettingData(_:), error: errorGettingData(_:))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.galeria = self.childViewControllers[0] as! GaleriaFVDVC
        self.padre = self.parent?.parent as! ObsDetalleVC
        self.observacion = self.padre.observacion
        // self.galeria.modo = "GET"
        // self.galeria.codigo = self.observacion.Codigo ?? ""
        // self.galeria.loadModoGET(self.observacion.Codigo ?? "")
        /*let hijo = self.childViewControllers[0] as! GaleriaVC
        hijo.codigo = self.observacion.Codigo// Utils.selectedObsCode
        hijo.getFilesFor(self.observacion.Codigo)//Utils.selectedObsCode)*/
    }
    
    /*func loadObservacion(_ observacion: MuroElement){
        self.galeria.loadModoGET(observacion.Codigo ?? "")
        // self.galeria.loadGaleria(observacion.Codigo ?? "")
    }*/
    
}
