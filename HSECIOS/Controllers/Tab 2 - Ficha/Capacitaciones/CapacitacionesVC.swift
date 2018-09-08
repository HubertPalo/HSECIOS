import UIKit

class CapacitacionesVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tabla: UITableView!
    
    var capRecibidas: [Capacitacion] = []
    var capPerfil: [Capacitacion] = []
    var hideSections = [false, false]
    var titlesInSections = ["Capacitaciones Recibidas", "Perfil de capacitación"]
    
    var codPersona = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setTitleAndImage("Ficha/Capacitaciones", UIImage.init(named: "ficha"))
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
            self.tabla.reloadData()
        }, error: nil)
        Rest.getDataGeneral(Routes.forCapPerfil(codigo), true, success: {(resultValue:Any?,data:Data?) in
            let capacitaciones: ArrayGeneral<Capacitacion> = Dict.dataToArray(data!)
            self.capPerfil = capacitaciones.Data
            self.tabla.reloadData()
        }, error: nil)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let celda = tableView.dequeueReusableCell(withIdentifier: "celda1") as! Celda1Boton
        celda.boton.tag = section
        celda.boton.setTitle(titlesInSections[section], for: .normal)
        return celda.contentView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1 + (hideSections[0] ? 0 : self.capRecibidas.count)
        case 1:
            return 1 + (hideSections[1] ? 0 : self.capPerfil.count)
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let celda = tableView.dequeueReusableCell(withIdentifier: "celda2")!
            celda.isUserInteractionEnabled = false
            return celda
        }
        let celda = tableView.dequeueReusableCell(withIdentifier: "celda3") as! Celda4Texto1View
        let unit = indexPath.section == 0 ? self.capRecibidas[indexPath.row - 1] : self.capPerfil[indexPath.row - 1]
        let fecha = indexPath.section == 0 ? unit.Fecha : unit.Cumplido
        celda.texto1.text = fecha?.toDate()?.toString("dd-MM-YYYY") ?? "Fecha"
        celda.texto2.text = unit.Tema
        celda.texto3.text = unit.Estado
        celda.texto4.text = (unit.Nota ?? -1) == -1 ? "-" : "\(unit.Nota!)"
        celda.view.isHidden = (indexPath.section == 0 && indexPath.row == self.capRecibidas.count) || (indexPath.section == 1 && indexPath.row == self.capPerfil.count)
        celda.isUserInteractionEnabled = true
        return celda
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let unit = indexPath.section == 0 ? self.capRecibidas[indexPath.row - 1] : self.capPerfil[indexPath.row - 1]
        let fecha = indexPath.section == 0 ? unit.Fecha : unit.Cumplido
        if fecha == nil {
            self.tabla.deselectRow(at: indexPath, animated: true)
            return
        }
        let popup = Tabs.sb.instantiateViewController(withIdentifier: "PopUp") as! PopUpVC
        popup.modalPresentationStyle = .overCurrentContext
        let title = titlesInSections[indexPath.section]
        
        
        var dataForLeft = ["Fecha", "Duración", "Tema", "Tipo", "Nota", "Estado", "Vencimiento"]
        var duracion = ""
        switch unit.Duracion ?? "" {
        case "":
            duracion = "-"
        case "1:0":
            duracion = "1:0 h"
        case "1":
            duracion = "1 h"
        default:
            duracion = unit.Duracion! + " hrs"
        }
        var dataForRight = [unit.Fecha ?? "", duracion, unit.Tema ?? "", unit.Tipo ?? "", (unit.Nota ?? -1) == -1 ? "nil" : "\(unit.Nota!)", unit.Estado ?? "", Utils.str2date2str(unit.Vencimiento ?? "")]
        if indexPath.section == 1 {
            dataForLeft = ["Tema", "Cumplido", "Tipo", "Nota", "Estado", "Vencimiento"]
            dataForRight = [unit.Tema ?? "", Utils.str2date2str(unit.Cumplido ?? ""), unit.Tipo ?? "", (unit.Nota ?? -1) == -1 ? "nil" : "\(unit.Nota!)", unit.Estado ?? "", Utils.str2date2str(unit.Vencimiento ?? "")]
        }
        popup.dataTitle = title
        popup.dataLeft = dataForLeft
        popup.dataRight = dataForRight
        popup.alSalir = {
            self.tabla.deselectRow(at: indexPath, animated: true)
        }
        self.present(popup, animated: false, completion: nil)
    }
    
    @IBAction func clickEnHeader(_ sender: Any) {
        let section = (sender as! UIButton).tag
        self.hideSections[section] = !self.hideSections[section]
        self.tabla.reloadData()
    }
}
