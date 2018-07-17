import UIKit

class PlanesAccionPendTVC: UITableViewController {
    
    var planes: [PlanAccionGeneral] = []
    
    var alClickCelda: ((_ plan:PlanAccionGeneral) -> Void)?
    
    var alScrollLimiteTop: (() -> Void)?
    var alScrollLimiteBot: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func cleanData() {
        self.planes = []
    }
    
    func addMoreData(array:[PlanAccionGeneral]) {
        // var nuevaData: [PlanAccionPendiente] = []
        var codigos: [String] = []
        for i in 0..<self.planes.count {
            codigos.append(self.planes[i].CodAccion ?? "")
        }
        for i in 0..<array.count {
            if !codigos.contains(array[i].CodAccion ?? "") {
                self.planes.append(array[i])
            }
        }
        self.tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.planes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: "celda") as! PlanesAccionPendientesTVCell
        let unit = self.planes[indexPath.row]
        Images.loadAvatarFromDNI(unit.CodSolicitadoPor ?? "", celda.avatar, true, tableView, indexPath)
        Images.loadIcon("NIVELRIESGO.\(unit.CodNivelRiesgo)", celda.icono)
        celda.editableView.isHidden = unit.Editable != nil && unit.Editable != 1 && unit.Editable != 3
        celda.autor.text = unit.SolicitadoPor
        celda.fecha.text = Utils.str2date2str(unit.FechaSolicitud ?? "")
        celda.tipo.text = Utils.searchMaestroStatic("TABLAS", unit.CodTabla ?? "")
        celda.estado.text = Utils.searchMaestroStatic("ESTADOPLAN", unit.CodEstadoAccion ?? "")
        celda.contenido.text = unit.DesPlanAccion
        celda.limiteView.isHidden = indexPath.row == self.planes.count - 1
        return celda
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let unit = self.planes[indexPath.row]
        VCHelper.openPlanAccionDetalle(self, unit)
    }
    
    @IBAction func click3Puntos(_ sender: Any) {
        Utils.openSheetMenu(self, "OPCIONES", nil, ["Editar plan de acción", "Eliminar plan de acción", "Cancelar"], [.default, .destructive, .cancel], [nil, nil, nil])
    }
    
    
}

class PlanesAccionPendientesTVCell: UITableViewCell {
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var autor: UILabel!
    @IBOutlet weak var fecha: UILabel!
    @IBOutlet weak var tipo: UILabel!
    @IBOutlet weak var estado: UILabel!
    @IBOutlet weak var contenido: UILabel!
    @IBOutlet weak var editableView: UIView!
    @IBOutlet weak var limiteView: UIView!
    @IBOutlet weak var icono: UIImageView!
}
