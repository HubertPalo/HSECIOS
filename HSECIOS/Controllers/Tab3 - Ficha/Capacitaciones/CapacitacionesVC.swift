import UIKit

class CapacitacionesVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tabla: UITableView!
    
    var capRecibidas: [Capacitacion] = []
    var capPerfil: [Capacitacion] = []
    var capacitaciones: [[Capacitacion]] = [[],[]]
    var hideSections = [false, false]
    var rowsInSections = [0, 0]
    var titlesInSections = ["Capacitaciones Recibidas", "Perfil de capacitación"]
    
    var codPersona = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //container1HeightConstraint.isActive = false
        tabla.delegate = self
        tabla.dataSource = self
        tabla.rowHeight = UITableViewAutomaticDimension
        tabla.estimatedRowHeight = 70
        loadCapacitaciones(codPersona)
    }
    
    func loadCapacitaciones(_ codigo: String) {
        Rest.getDataGeneral(Routes.forCapRecibidas(codigo), true, success: {(resultValue:Any?,data:Data?) in
            let capacitaciones: ArrayGeneral<Capacitacion> = Dict.dataToArray(data!)
            self.capRecibidas = capacitaciones.Data
            self.capPerfil = capacitaciones.Data
            self.capacitaciones[0] = capacitaciones.Data
            self.rowsInSections = [self.capacitaciones[0].count, self.capacitaciones[1].count]
            self.tabla.reloadData()
            self.tabla.layoutIfNeeded()
        }, error: nil)
        Rest.getDataGeneral(Routes.forCapPerfil(codigo), true, success: {(resultValue:Any?,data:Data?) in
            let capacitaciones: ArrayGeneral<Capacitacion> = Dict.dataToArray(data!)
            self.capRecibidas = capacitaciones.Data
            self.capPerfil = capacitaciones.Data
            self.capacitaciones[0] = capacitaciones.Data
            self.rowsInSections = [self.capacitaciones[0].count, self.capacitaciones[1].count]
            self.tabla.reloadData()
            self.tabla.layoutIfNeeded()
        }, error: nil)
        /*Rest.getData(Routes.forCapRecibidas(codigo), false, vcontroller: self, success: {(dict: NSDictionary) in
            let capacitaciones = Dict.toArrayCapacitacion(dict)
            self.capRecibidas = capacitaciones
            self.capPerfil = capacitaciones
            self.capacitaciones[0] = capacitaciones
            self.rowsInSections = [self.capacitaciones[0].count, self.capacitaciones[1].count]
            self.tabla.reloadData()
            self.tabla.layoutIfNeeded()
        })
        Rest.getData(Routes.forCapPerfil(codigo), false, vcontroller: self, success: {(dict: NSDictionary) in
            let capacitaciones = Dict.toArrayCapacitacion(dict)
            self.capRecibidas = capacitaciones
            self.capPerfil = capacitaciones
            self.capacitaciones[1] = capacitaciones
            self.rowsInSections = [self.capacitaciones[0].count, self.capacitaciones[1].count]
            self.tabla.reloadData()
            self.tabla.layoutIfNeeded()
        })*/
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        var size = 50
        if hideSections[section] {
            size = size - 30
        }
        return CGFloat(size)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        print("View for header: \(section)")
        let celda = tableView.dequeueReusableCell(withIdentifier: "header") as! CapacitacionesHeaderCell
        celda.section = section
        celda.titulo.setTitle(titlesInSections[section], for: .normal)
        return celda.contentView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rowsInSections[section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: "celda") as! CapacitacionesVCell
        var unit = capacitaciones[indexPath.section][indexPath.row]
        celda.tema.text = unit.Tema
        celda.estado.text = unit.Estado
        celda.nota.text = unit.Nota
        print("\(unit.Tema) - \(unit.Estado) - \(unit.Nota)")
        return celda
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let popup = Tabs.sb.instantiateViewController(withIdentifier: "PopUp") as! PopUpVC
        popup.modalPresentationStyle = .overCurrentContext
        let title = titlesInSections[indexPath.section]
        let unit = capacitaciones[indexPath.section][indexPath.row]
        var dataForLeft = ["Fecha", "Duración", "Tema", "Tipo", "Nota", "Estado", "Vencimiento"]
        var dataForRight = [unit.Fecha, unit.Duracion, unit.Tema, unit.Tipo, unit.Nota, unit.Estado, unit.Vencimiento]
        if indexPath.section == 1 {
            dataForLeft = ["Tema", "Cumplido", "Tipo", "Nota", "Estado", "Vencimiento"]
            dataForRight = [unit.Tema, unit.Cumplido, unit.Tipo, unit.Nota, unit.Estado, unit.Vencimiento]
        }
        popup.dataTitle = title
        popup.dataLeft = dataForLeft
        popup.dataRight = dataForRight
        //popup.loadData(title, newDataLeft: dataForLeft, newDataRight: dataForRight)
        
        //popup.planAccion = planes[indexPath.row]
        self.present(popup, animated: true, completion: nil)
    }
    
    @IBAction func clickEnHeader(_ sender: Any) {
        var celda = (sender as AnyObject).superview??.superview?.superview as! CapacitacionesHeaderCell
        print("click En Header, celda en seccion: \(celda.section)")
        hideSections[celda.section] = !hideSections[celda.section]
        celda.stackInferior.isHidden = hideSections[celda.section]
        if hideSections[celda.section] {
            rowsInSections[celda.section] = 0
            tabla.reloadData()
        } else {
            rowsInSections[celda.section] = capacitaciones[celda.section].count
            tabla.reloadData()
        }
    }
}

class CapacitacionesHeaderCell: UITableViewCell {
    
    @IBOutlet weak var titulo: UIButton!
    @IBOutlet weak var stackInferior: UIStackView!
    
    var section = -1
}

class CapacitacionesVCell: UITableViewCell {
    @IBOutlet weak var tema: UILabel!
    @IBOutlet weak var nota: UILabel!
    @IBOutlet weak var estado: UILabel!
}
