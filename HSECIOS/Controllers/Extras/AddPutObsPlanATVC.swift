import UIKit

class AddPutObsPlATVC: UITableViewController {
    
    var tipo = "ADD"
    
    var responsables: [Persona] = []
    
    var data: [String:String] = [:]
    
    var alHacerClickEnOK: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return CGFloat.leastNonzeroMagnitude
        default:
            return 40
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 1:
            let celda = tableView.dequeueReusableCell(withIdentifier: "celda1") as! AddPutObsPlATVCell1
            celda.titulo.attributedText = Utils.addInitialRedAsterisk("Fecha Comprometida", "HelveticaNeue-Bold", 14)
            return celda.contentView
        case 2:
            let celda = tableView.dequeueReusableCell(withIdentifier: "celda1") as! AddPutObsPlATVCell1
            celda.titulo.attributedText = Utils.addInitialRedAsterisk("Tarea", "HelveticaNeue-Bold", 14)
            return celda.contentView
        case 3:
            let celda = tableView.dequeueReusableCell(withIdentifier: "celda2") as! AddPutObsPlATVCell1
            celda.titulo.attributedText = Utils.addInitialRedAsterisk("Responsables", "HelveticaNeue-Bold", 14)
            return celda.contentView
        default:
            return nil
        }
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return self.tipo == "ADD" ? 7 : 10
        case 1:
            return 2
        case 2:
            return 1
        case 3:
            return self.responsables.count
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            if self.tipo == "ADD" {
                switch indexPath.row {
                case 0:
                    let celda = tableView.dequeueReusableCell(withIdentifier: "celda3") as! AddPutObsPlATVCell2
                    celda.textoIzq.text = "Fecha de Solicitud"
                    celda.textoDer.text = "Falta"
                    return celda
                case 1:
                    return tableView.dequeueReusableCell(withIdentifier: "celda4")!
                case 2:
                    let celda = tableView.dequeueReusableCell(withIdentifier: "celda5") as! AddPutObsPlATVCell2
                    celda.textoIzq.attributedText = Utils.addInitialRedAsterisk("Solicitado Por:", "HelveticaNeue-Bold", 14)
                    celda.textoDer.text = "Falta"
                    return celda
                case 3:
                    let celda = tableView.dequeueReusableCell(withIdentifier: "celda6") as! AddPutObsPlATVCell3
                    celda.textoIzq.attributedText = Utils.addInitialRedAsterisk("Actividad Relacionada:", "HelveticaNeue-Bold", 14)
                    celda.botonDer.setTitle("- SELECCIONE -", for: .normal)
                    return celda
                case 4:
                    let celda = tableView.dequeueReusableCell(withIdentifier: "celda6") as! AddPutObsPlATVCell3
                    celda.textoIzq.attributedText = Utils.addInitialRedAsterisk("Nivel Riesgo:", "HelveticaNeue-Bold", 14)
                    celda.botonDer.setTitle("- SELECCIONE -", for: .normal)
                    return celda
                case 5:
                    let celda = tableView.dequeueReusableCell(withIdentifier: "celda6") as! AddPutObsPlATVCell3
                    celda.textoIzq.attributedText = Utils.addInitialRedAsterisk("Área HSEC:", "HelveticaNeue-Bold", 14)
                    celda.botonDer.setTitle("- SELECCIONE -", for: .normal)
                    return celda
                case 6:
                    let celda = tableView.dequeueReusableCell(withIdentifier: "celda6") as! AddPutObsPlATVCell3
                    celda.textoIzq.attributedText = Utils.addInitialRedAsterisk("Tipo Acción:", "HelveticaNeue-Bold", 14)
                    celda.botonDer.setTitle("- SELECCIONE -", for: .normal)
                    return celda
                default:
                    return UITableViewCell()
                }
            } else {
                switch indexPath.row {
                case 0:
                    return UITableViewCell()
                default:
                    return UITableViewCell()
                }
            }
        case 1:
            // let celda =
            return UITableViewCell()
        case 2:
            return UITableViewCell()
        case 3:
            return UITableViewCell()
        default:
            return UITableViewCell()
        }
    }
    
    @IBAction func clickOk(_ sender: Any) {
        //self.alHacerClickEnOK?
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
}

class AddPutObsPlATVCell1: UITableViewCell {
    @IBOutlet weak var titulo: UILabel!
}

class AddPutObsPlATVCell2: UITableViewCell {
    @IBOutlet weak var textoIzq: UILabel!
    @IBOutlet weak var textoDer: UILabel!
}

class AddPutObsPlATVCell3: UITableViewCell {
    @IBOutlet weak var textoIzq: UILabel!
    @IBOutlet weak var botonDer: UIButton!
}

class ObsPlanATVCell4: UITableViewCell {
    @IBOutlet weak var textoIzq: UILabel!
    @IBOutlet weak var textoDer: UILabel!
    @IBOutlet weak var botonAgregar: UIButton!
}

class ObsPlanATVCell5: UITableViewCell {
    @IBOutlet weak var textoIzq: UILabel!
    @IBOutlet weak var botonDer: UIButton!
}

class ObsPlanATVCell6: UITableViewCell {
    @IBOutlet weak var textoTop: UILabel!
}

class ObsPlanATVCell7: UITableViewCell {
    @IBOutlet weak var textoTop: UILabel!
    @IBOutlet weak var textoBot: UILabel!
}
