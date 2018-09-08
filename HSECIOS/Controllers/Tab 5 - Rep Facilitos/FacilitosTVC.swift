import UIKit

class FacilitosTVC: UITableViewController {
    
    var data = [FacilitoElement]()
    
    var alSeleccionarCelda: ((_ facilito:FacilitoElement) -> Void)?
    var alScrollLimiteTop: (() -> Void)?
    var alScrollLimiteBot: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: "celda") as! FacilitosTVCell
        let unit = self.data[indexPath.row]
        celda.autor.text = unit.Persona
        celda.fecha.text = Utils.str2date2str(unit.Fecha ?? "")
        celda.tipo.text = Utils.searchMaestroStatic("TIPOFACILITO", unit.Tipo ?? "")
        celda.estado.text = Utils.searchMaestroStatic("ESTADOFACILITO", unit.Estado ?? "")
        celda.contenido.text = unit.Observacion
        celda.empresa.text = unit.Empresa
        celda.viewEditable.isHidden = unit.Editable == "0" || unit.Editable == "2"
        celda.tiempo.attributedText = Utils.handleSeconds("\(unit.TiempoDiffMin ?? 0)")
        celda.limiteView.isHidden = indexPath.row == self.data.count - 1
        celda.avatar.layer.cornerRadius = celda.avatar.frame.height/2
        celda.avatar.layer.masksToBounds = true
        if (unit.UrlObs ?? "") != "" {
            celda.avatar.image = Images.getImageFor("A-\(unit.UrlObs ?? "")")
        }
        celda.imagen.isHidden = (unit.UrlPrew ?? "").isEmpty
        if (unit.UrlPrew ?? "") != "" {
            celda.imagen.image = Images.getImageFor("P-\(unit.UrlPrew ?? "")")
        }
        if unit.Estado ?? "" == "S" {
            celda.imagenEstado.image = Images.getIconFor("ESTADOFACILITO.\(unit.Estado ?? "")")?.withRenderingMode(.alwaysTemplate)
            celda.imagenEstado.tintColor = (unit.TiempoDiffMin ?? 0 > -1) ? UIColor.green : UIColor.red
        } else {
            celda.imagenEstado.image = Images.getIconFor("ESTADOFACILITO.\(unit.Estado ?? "")")
        }
        return celda
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let unit = self.data[indexPath.row]
        alSeleccionarCelda?(unit)
    }
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let currentOffset = scrollView.contentOffset.y
        if currentOffset <= -10 {
            self.alScrollLimiteTop?()
        } else {
            let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
            if maximumOffset - currentOffset <= -10 {
                self.alScrollLimiteBot?()
            }
        }
    }
    
    @IBAction func clickAvatar(_ sender: Any) {
        var superV = (sender as! UIButton).superview
        while !(superV is UITableViewCell) {
            superV = superV?.superview
        }
        var codigo = self.tableView.indexPath(for: superV as! UITableViewCell)
        
        Utils.showFichaFor(self.data[codigo!.row].UrlObs ?? "")
    }
    
    @IBAction func clickOpciones(_ sender: Any) {
        self.presentAlert("OPCIONES", nil, .actionSheet, nil, nil, ["Editar", "Eliminar", "Cancelar"], [.default, .destructive, .cancel], actionHandlers: [{(alertEditar) in
            var superV = (sender as! UIButton).superview
            while !(superV is UITableViewCell) {
                superV = superV?.superview
            }
            var codigo = self.tableView.indexPath(for: superV as! UITableViewCell)!
            VCHelper.openUpsertFacilito(self, "PUT", self.data[codigo.row].CodObsFacilito ?? "")
            }, { (alertEliminar) in
                self.presentAlert("Funcionalidad en desarrollo", nil, .alert, 2, nil, [], [], actionHandlers: [])
                // Alerts.presentAlert("Funcionalidad en desarrollo", ":D", duration: 1, imagen: Images.alertaRoja, viewController: self)
            }, { (alertCancelar) in
                self.presentAlert("Funcionalidad en desarrollo", nil, .alert, 2, nil, [], [], actionHandlers: [])
                //Alerts.presentAlert("Funcionalidad en desarrollo", ":D", duration: 1, imagen: Images.alertaRoja, viewController: self)
            }])
        /*Utils.openSheetMenu(self, "OPCIONES", nil, ["Editar", "Eliminar", "Cancelar"], [.default, .destructive, .cancel], [{(alertEditar) in
            var superV = (sender as! UIButton).superview
            while !(superV is UITableViewCell) {
                superV = superV?.superview
            }
            var codigo = self.tableView.indexPath(for: superV as! UITableViewCell)!
            VCHelper.openUpsertFacilito(self, "PUT", self.facilitos.Data[codigo.row].CodObsFacilito ?? "")
            }, { (alertEliminar) in
                Alerts.presentAlert("Funcionalidad en desarrollo", ":D", duration: 1, imagen: Images.alertaRoja, viewController: self)
            }, { (alertCancelar) in
                Alerts.presentAlert("Funcionalidad en desarrollo", ":D", duration: 1, imagen: Images.alertaRoja, viewController: self)
            }])*/
        
    }
    
}

class FacilitosTVCell: UITableViewCell {
    @IBOutlet weak var autor: UILabel!
    @IBOutlet weak var fecha: UILabel!
    @IBOutlet weak var tipo: UILabel!
    @IBOutlet weak var estado: UILabel!
    @IBOutlet weak var tiempo: UILabel!
    @IBOutlet weak var empresa: UILabel!
    @IBOutlet weak var contenido: UILabel!
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var imagen: UIImageView!
    @IBOutlet weak var imagenEstado: UIImageView!
    @IBOutlet weak var viewEditable: UIView!
    @IBOutlet weak var limiteView: UIView!
}
