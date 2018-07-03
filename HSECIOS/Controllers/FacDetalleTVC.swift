import UIKit

class FacDetalleTVC: UITableViewController {
    
    var facilito = FacilitoElement()
    
    var detalles = FacilitoDetalle()
    var multimedia: [FotoVideo] = []
    var historialAtencion = ArrayGeneral<HistorialAtencionElement>()
    
    let sec0TextoIzq = ["Código Obs", "Observado Por", "Tipo Observación", "Estado", "Gerencia", "Superintendencia", "Ubicación Exacta", "Observación", "Acción a tomar", "Fecha Creación"]
    var sec0TextoDer = ["-", "-", "-", "-", "-", "-", "-", "-", "-", "-"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Utils.setTitleAndImage(self, "Rep. Facilito/Detalle", Images.facilito)
    }
    
    func cleanData() {
        self.detalles = FacilitoDetalle()
        self.multimedia = []
        self.historialAtencion.Count = 0
        self.historialAtencion.Data = []
        self.tableView.reloadData()
    }
    
    func loadFacilito(_ facilito: FacilitoElement) {
        self.facilito = facilito
        Rest.getDataGeneral(Routes.forFacilitoDetalle(facilito.CodObsFacilito ?? ""), false, success: {(resultValue:Any?,data:Data?) in
            self.detalles = Dict.dataToUnit(data!)!
            self.sec0TextoDer[0] = self.detalles.CodObsFacilito
            self.sec0TextoDer[1] = self.detalles.Persona
            self.sec0TextoDer[2] = Utils.searchMaestroStatic("TIPOFACILITO", self.detalles.Tipo)
            self.sec0TextoDer[3] = Utils.searchMaestroStatic("ESTADOFACILITO", self.detalles.Estado)
            self.sec0TextoDer[4] = Utils.searchMaestroDescripcion("GERE", self.detalles.CodPosicionGer)
            self.sec0TextoDer[5] = Utils.searchMaestroDescripcion("SUPE.\(self.detalles.CodPosicionGer)", self.detalles.CodPosicionSup)
            self.sec0TextoDer[6] = self.detalles.UbicacionExacta
            self.sec0TextoDer[7] = self.detalles.Observacion
            self.sec0TextoDer[8] = self.detalles.Accion
            self.sec0TextoDer[9] = Utils.str2date2str(self.detalles.FecCreacion)
            self.tableView.reloadSections([0], with: .automatic)
        }, error: nil)
        /*Rest.getData(Routes.forFacilitoDetalle(facilito.CodObsFacilito ?? ""), false, vcontroller: self, success: {(dict:NSDictionary) in
            self.detalles = Dict.toFacilitoDetalle(dict)
            self.sec0TextoDer[0] = self.detalles.CodObsFacilito
            self.sec0TextoDer[1] = self.detalles.Persona
            self.sec0TextoDer[2] = Utils.searchMaestroStatic("TIPOFACILITO", self.detalles.Tipo)
            self.sec0TextoDer[3] = Utils.searchMaestroStatic("ESTADOFACILITO", self.detalles.Estado)
            self.sec0TextoDer[4] = Utils.searchMaestroDescripcion("GERE", self.detalles.CodPosicionGer)
            self.sec0TextoDer[5] = Utils.searchMaestroDescripcion("SUPE.\(self.detalles.CodPosicionGer)", self.detalles.CodPosicionSup)
            self.sec0TextoDer[6] = self.detalles.UbicacionExacta
            self.sec0TextoDer[7] = self.detalles.Observacion
            self.sec0TextoDer[8] = self.detalles.Accion
            self.sec0TextoDer[9] = Utils.str2date2str(self.detalles.FecCreacion)
            self.tableView.reloadSections([0], with: .automatic)
        })*/
        Rest.getDataGeneral(Routes.forMultimedia("\(facilito.CodObsFacilito)-1"), false, success: {(resultValue:Any?,data:Data?) in
            let arrayFotovideo: ArrayGeneral<FotoVideo> = Dict.dataToArray(data!)
            self.multimedia = arrayFotovideo.Data
            // self.multimedia = Dict.toArrayMultimedia(dict)
            self.tableView.reloadSections([1], with: .automatic)
        }, error: nil)
        /*Rest.getData(Routes.forMultimedia("\(facilito.CodObsFacilito)-1"), false, vcontroller: self, success: {(dict:NSDictionary) in
            self.multimedia = Dict.toArrayMultimedia(dict)
            self.tableView.reloadSections([1], with: .automatic)
        })*/
        Rest.getDataGeneral(Routes.forFacilitoHistorialAtencion(facilito.CodObsFacilito ?? ""), false, success: {(resultValue:Any?,data:Data?) in
            self.historialAtencion = Dict.dataToUnit(data!)!
            self.tableView.reloadSections([2], with: .automatic)
        }, error: nil)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    @IBAction func clickAbrirMenuAtencion(_ sender: Any) {
        Utils.openSheetMenu(self, "HISTORIAL DE ATENCIÓN", nil, ["Editar Atención de Observación", "Eliminar Atención de Observación", "Cancelar"], [.default, .destructive, .cancel], [{(alertAction) in
            
            }, {(alertAction) in
                Alerts.presentAlert("esta seguro?", "Esta acción no se podrá deshacer", duration: 2, imagen: nil, viewController: self)
            }, nil])
    }
    
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return CGFloat.leastNonzeroMagnitude
        }
        return 50
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0:
            return nil
        case 1:
            let header = tableView.dequeueReusableCell(withIdentifier: "celda1") as! FacDetalleTVCell1
            header.titulo.text = "Galería Imágenes"
            header.view.isHidden = true
            return header.contentView
        case 2:
            let header = tableView.dequeueReusableCell(withIdentifier: "celda1") as! FacDetalleTVCell1
            header.titulo.text = "Historial de Atención"
            header.view.isHidden = self.facilito.Editable == "1"
            return header.contentView
        default:
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return self.sec0TextoIzq.count
        case 1:
            return self.multimedia.count/2 + self.multimedia.count%2
        case 2:
            return self.historialAtencion.Data.count
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let celda = tableView.dequeueReusableCell(withIdentifier: "celda2") as! FacDetalleTVCell2
            celda.textoIzq.text = self.sec0TextoIzq[indexPath.row]
            celda.textoDer.text = self.sec0TextoDer[indexPath.row]
            return celda
        case 1:
            var celda = tableView.dequeueReusableCell(withIdentifier: "celda3") as! CeldaGaleria
            let dataIzq = self.multimedia[indexPath.row * 2]
            let dataDer: FotoVideo? = indexPath.row * 2 + 1 == self.multimedia.count ? nil : self.multimedia[indexPath.row * 2 + 1]
            Utils.initCeldaGaleria(&celda, dataIzq, dataDer, false, tableView, indexPath)
            return celda
        case 2:
            let celda = tableView.dequeueReusableCell(withIdentifier: "celda4") as! FacDetalleTVCell4
            let unit = self.historialAtencion.Data[indexPath.row]
            celda.persona.text = unit.Persona
            celda.fecha.text = Utils.str2date2str(unit.Fecha)
            celda.estado.text = Utils.searchMaestroStatic("ESTADOFACILITO", unit.Estado)
            celda.comentario.text = unit.Comentario
            Images.loadAvatarFromDNI(unit.UrlObs, celda.avatar, true, tableView, indexPath)
            //Images.loadAvatarFromDNI(unit.UrlObs, celda.avatar, true)
            return celda
        default:
            return UITableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 2:
            print("-------------")
            print(self.historialAtencion.Data[indexPath.row])
            print(self.facilito)
            self.historialAtencion.Data[indexPath.row].printDescription()
            self.facilito.printDescription()
            print("-------------")
            VCHelper.openFacilitoDetalleAtencion(self, self.historialAtencion.Data[indexPath.row], self.facilito, false)
        default:
            break
        }
    }
}

class FacDetalleTVCell1: UITableViewCell {
    @IBOutlet weak var titulo: UILabel!
    @IBOutlet weak var view: UIView!
}

class FacDetalleTVCell2: UITableViewCell {
    @IBOutlet weak var textoIzq: UILabel!
    @IBOutlet weak var textoDer: UILabel!
}

class FacDetalleTVCell3: UITableViewCell {
    
}

class FacDetalleTVCell4: UITableViewCell {
    
    @IBOutlet weak var persona: UILabel!
    
    @IBOutlet weak var fecha: UILabel!
    
    @IBOutlet weak var estado: UILabel!
    
    @IBOutlet weak var comentario: UILabel!
    
    @IBOutlet weak var avatar: UIImageView!
    
}
