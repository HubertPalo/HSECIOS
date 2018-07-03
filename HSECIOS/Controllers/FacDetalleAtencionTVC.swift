import UIKit

class FacDetalleAtencionTVC: UITableViewController {
    
    var editable = false
    
    var multimedia: [FotoVideo] = []
    var atencion = HistorialAtencionElement()
    var facilito = FacilitoElement()
    
    var textoNoEditable = [["Atendido por:", "-"], ["Fecha Atención:", "-"], ["Estado:", "-"], ["Fecha Ejecutarse:", "-"], ["Comentario:", "-"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func cleanData() {
        self.textoNoEditable = [["Atendido por:", "-"], ["Fecha Atención:", "-"], ["Estado:", "-"], ["Fecha Ejecutarse:", "-"], ["Comentario:", "-"]]
        self.multimedia = []
        self.atencion = HistorialAtencionElement()
        self.facilito = FacilitoElement()
        self.tableView.reloadData()
    }
    
    func loadAtencion(_ atencion: HistorialAtencionElement, _ facilito: FacilitoElement, _ editable: Bool) {
        
        self.atencion = atencion
        self.editable = editable //atencion.CodObsFacilito == "1"
        self.facilito = facilito
        self.textoNoEditable = [["Atendido por:", atencion.Persona], ["Fecha Atención:", Utils.str2date2str(atencion.Fecha)], ["Estado:", Utils.searchMaestroStatic("ESTADOFACILITO", atencion.Estado)], ["Fecha Ejecutarse:", Utils.str2date2str(atencion.FechaFin)], ["Comentario:", atencion.Comentario]]
        self.tableView.reloadSections([0], with: .automatic)
        Rest.getDataGeneral(Routes.forMultimedia("\(self.facilito.CodObsFacilito)-\(self.atencion.Correlativo)"), false, success: {(resultValue:Any?,data:Data?) in
            let arrayFotovideo: ArrayGeneral<FotoVideo> = Dict.dataToArray(data!)
            self.multimedia = arrayFotovideo.Data
            // self.multimedia = Dict.toArrayMultimedia(dict)
            print(self.multimedia)
            self.tableView.reloadSections([1], with: .automatic)
        }, error: nil)
        /*Rest.getData(Routes.forMultimedia("\(self.facilito.CodObsFacilito)-\(self.atencion.Correlativo)"), false, vcontroller: self, success: {(dict:NSDictionary) in
            self.multimedia = Dict.toArrayMultimedia(dict)
            print(self.multimedia)
            self.tableView.reloadSections([1], with: .automatic)
        })*/
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 1 ? 50 : CGFloat.leastNonzeroMagnitude
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return nil
        }
        let header = tableView.dequeueReusableCell(withIdentifier: "celda1") as! FacDetalleAtencionTVCell1
        header.titulo.text = "Galería de imágenes"
        header.view.isHidden = !self.editable
        return header.contentView
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            if self.editable {
                return 2 + (self.atencion.Estado == "S" ? 2 : 0)
            } else {
                return 5
            }
        case 1:
            return (self.multimedia.count/2) + (self.multimedia.count%2)
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("\(indexPath) - \(self.editable)")
        switch indexPath.section {
        case 0:
            if self.editable {
                if self.atencion.Estado == "S" {
                    switch indexPath.row {
                    case 0:
                        return UITableViewCell()
                    case 1:
                        return UITableViewCell()
                    case 2:
                        return UITableViewCell()
                    case 3:
                        return UITableViewCell()
                    default:
                        return UITableViewCell()
                    }
                } else {
                    switch indexPath.row {
                    case 0:
                        return UITableViewCell()
                    case 1:
                        return UITableViewCell()
                    default:
                        return UITableViewCell()
                    }
                }
            } else {
                let celda = tableView.dequeueReusableCell(withIdentifier: "celda2") as! FacDetalleAtencionTVCell2
                celda.textoIzq.text = self.textoNoEditable[indexPath.row][0]
                celda.textoDer.text = self.textoNoEditable[indexPath.row][1]
                return celda
            }
        case 1:
            var celda = tableView.dequeueReusableCell(withIdentifier: "celda5") as! CeldaGaleria
            let dataIzq = self.multimedia[indexPath.row * 2]
            let dataDer: FotoVideo? = indexPath.row * 2 + 1 == self.multimedia.count ? nil : self.multimedia[indexPath.row * 2 + 1]
            Utils.initCeldaGaleria(&celda, dataIzq, dataDer, self.editable, tableView, indexPath)
            return celda
        default:
            return UITableViewCell()
        }
    }
}

class FacDetalleAtencionTVCell1: UITableViewCell {
    @IBOutlet weak var titulo: UILabel!
    @IBOutlet weak var view: UIView!
}

class FacDetalleAtencionTVCell2: UITableViewCell {
    @IBOutlet weak var textoIzq: UILabel!
    @IBOutlet weak var textoDer: UILabel!
}

class FacDetalleAtencionTVCell3: UITableViewCell {
    @IBOutlet weak var textoIzq: UILabel!
    @IBOutlet weak var botonDer: UIButton!
}

class FacDetalleAtencionTVCell4: UITableViewCell {
    @IBOutlet weak var textoIzq: UILabel!
    @IBOutlet weak var cajaTextoDer: UITextField!
}
