import UIKit

class PlanesAccionPendTVC: UITableViewController {
    
    var planes: [PlanAccionPendiente] = []
    
    var alClickCelda: ((_ plan:PlanAccionPendiente) -> Void)?
    
    var alScrollLimiteTop: (() -> Void)?
    var alScrollLimiteBot: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func cleanData() {
        self.planes = []
    }
    
    func addMoreData(array:[PlanAccionPendiente]) {
        // var nuevaData: [PlanAccionPendiente] = []
        var codigos: [String] = []
        for i in 0..<self.planes.count {
            codigos.append(self.planes[i].CodAccion)
        }
        for i in 0..<array.count {
            if !codigos.contains(array[i].CodAccion) {
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
        Images.loadAvatarFromDNI(unit.CodSolicitadoPor, celda.avatar, true, tableView, indexPath)
        celda.autor.text = unit.SolicitadoPor
        celda.fecha.text = Utils.str2date2str(unit.FechaSolicitud)
        celda.tipo.text = unit.CodTabla
        celda.estado.text = unit.CodEstadoAccion
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
}
