import UIKit

class PlanesAccionPendTVC: UITableViewController {
    
    var planes: [PlanAccionGeneral] = []
    
    // var alClickCelda: ((_ plan:PlanAccionGeneral) -> Void)?
    
    var alScrollLimiteTop: (() -> Void)?
    var alScrollLimiteBot: (() -> Void)?
    
    var forceUpdateFromFather: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func cleanData() {
        self.planes = []
    }
    
    func addMoreData(array:[PlanAccionGeneral]) {
        var codigos: [String] = []
        for plan in self.planes {
            codigos.append(plan.CodAccion ?? "")
        }
        for unit in array {
            if !codigos.contains(unit.CodAccion ?? "") {
                self.planes.append(unit)
            }
        }
        /*for i in 0..<self.planes.count {
            codigos.append(self.planes[i].CodAccion ?? "")
        }
        for i in 0..<array.count {
            if !codigos.contains(array[i].CodAccion ?? "") {
                self.planes.append(array[i])
            }
        }*/
        self.tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.planes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: "celda") as! PlanesAccionPendientesTVCell
        let unit = self.planes[indexPath.row]
        Images.loadIcon("NIVELRIESGO.\(unit.CodNivelRiesgo ?? "")", celda.icono)
        celda.editableView.isHidden = unit.Editable != nil && unit.Editable != 1 && unit.Editable != 3
        celda.editableBoton.tag = indexPath.row
        celda.autor.text = unit.SolicitadoPor
        celda.fecha.text = Utils.str2date2str(unit.FechaSolicitud ?? "")
        celda.empresa.text = unit.Empresa
        celda.tipo.text = Utils.searchMaestroStatic("TABLAS", unit.CodTabla ?? "")
        celda.estado.text = Utils.searchMaestroStatic("ESTADOPLAN", unit.CodEstadoAccion ?? "")
        celda.contenido.text = unit.DesPlanAccion
        celda.limiteView.isHidden = indexPath.row == self.planes.count - 1
        celda.avatar.layer.cornerRadius = celda.avatar.frame.height/2
        celda.avatar.layer.masksToBounds = true
        if (unit.CodSolicitadoPor ?? "") != "" {
            celda.avatar.image = Images.getImageFor("A-\(unit.CodSolicitadoPor ?? "")")
        }
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
        let indice = (sender as! UIButton).tag
        let unit = self.planes[indice]
        self.presentAlert("OPCIONES", nil, .actionSheet, nil, nil, ["Editar", "Eliminar", "Cancelar"], [.default, .destructive, .cancel], actionHandlers: [{(editarAlert) in
            VCHelper.openUpsertPlanAccion(self.parent!, "PUT", unit.CodAccion!, {(planAccion) in
                var copia = planAccion.copy()
                copia.Responsables = nil
                copia.SolicitadoPor = nil
                Rest.postDataGeneral(Routes.forPostPlanAccion(), Dict.unitToParams(copia), true, success: {(resultValue:Any?,data:Data?) in
                    var strResult = resultValue as! String
                    if strResult == "-1" {
                        self.presentAlert("Error", "Ocurrió un error al ingresar el plan de acción", .alert, 2, nil, [], [], actionHandlers: [])
                    } else {
                        self.presentAlert("Operación exitosa", "Se editó el Plan de Acción correctamente", .alert, 2, nil, [], [], actionHandlers: [])
                        self.forceUpdateFromFather?()
                    }
                }, error: {(error) in
                    print(error)
                })
            })
            }, {(eliminarAlert) in
                self.presentAlert("¿Desea eliminar item?", "Plan Acción \(unit.CodAccion!)", .alert, nil, nil, ["Aceptar", "Cancelar"], [.default, .cancel], actionHandlers: [{(actionAceptar) in
                    Rest.getDataGeneral(Routes.forPlanAccionDelete(unit.CodAccion!), true, success: {(resultValue:Any?,data:Data?) in
                        let respuesta = resultValue as! String
                        if respuesta == "1" {
                            self.presentAlert("Item eliminado", nil, .alert, 1, nil, [], [], actionHandlers: [])
                            self.forceUpdateFromFather?()
                        } else {
                            self.presentAlert("Error", "Ocurrió un error al intentar eliminar el item", .alert, 2, nil, [], [], actionHandlers: [])
                        }
                    }, error: nil)
                    }, nil])
            }, nil])
        /*self.presentAlert("OPCIONES", nil, .actionSheet, nil, nil, ["Editar plan de acción", "Eliminar plan de acción", "Cancelar"], [.default, .destructive, .cancel], actionHandlers: [{(actionEditar) in
            
            }, {(actionEliminar) in
                
            }, nil])*/
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
    @IBOutlet weak var editableBoton: UIButton!
    @IBOutlet weak var limiteView: UIView!
    @IBOutlet weak var icono: UIImageView!
    @IBOutlet weak var empresa: UILabel!
}
