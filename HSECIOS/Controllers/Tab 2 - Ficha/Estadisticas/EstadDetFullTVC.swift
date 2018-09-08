import UIKit

class EstadDetFullTVC: UITableViewController {
    
    var tituloAnterior = ""
    var celdaComunValues: [[String]] = []
    var celdaAdicionalValues: [[String]] = []
    var titulo = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titulo = self.tituloAnterior
        self.setTitleAndImage("HSEC", Images.minero)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return celdaComunValues.count
        case 1:
            return celdaAdicionalValues.count
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let celda = tableView.dequeueReusableCell(withIdentifier: "celdaComun") as! EstadDetFullTVCellComun
            celda.textoIzq.text = celdaComunValues[indexPath.row][0]
            celda.textoDer.text = celdaComunValues[indexPath.row][1]
            return celda
        case 1:
            let celda = tableView.dequeueReusableCell(withIdentifier: "celdaAdicional") as! EstadDetFullTVCellAdicional
            celda.textoIzq.text = celdaAdicionalValues[indexPath.row][0]
            celda.textoDer.text = celdaAdicionalValues[indexPath.row][1]
            return celda
        default:
            return UITableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableCell(withIdentifier: "header") as! EstadDetFullTVHeader
        switch section {
        case 0:
            header.titulo.text = self.tituloAnterior
        case 1:
            header.titulo.text = "Datos Adicionales"
        default:
            break
        }
        return header
    }
}

class EstadDetFullTVHeader: UITableViewCell {
    @IBOutlet weak var titulo: UILabel!
}

class EstadDetFullTVCellComun: UITableViewCell {
    @IBOutlet weak var textoIzq: UILabel!
    @IBOutlet weak var textoDer: UILabel!
}

class EstadDetFullTVCellAdicional: UITableViewCell {
    @IBOutlet weak var textoIzq: UILabel!
    @IBOutlet weak var textoDer: UILabel!
}
