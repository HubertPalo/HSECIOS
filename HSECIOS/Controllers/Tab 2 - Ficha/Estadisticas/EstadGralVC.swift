import UIKit
import DropDown

class EstadGralVC: UIViewController {
    
    @IBOutlet weak var botonAnho: UIButton!
    
    @IBOutlet weak var botonMes: UIButton!
    
    @IBOutlet weak var viewNoData: UIView!
    
    @IBOutlet weak var containerData: UIView!
    
    @IBOutlet weak var iconoSearch: UIImageView!
    
    var dropdown = DropDown()
    var anho = "\(Utils.currentYear)"
    var mes = ""
    var codPersona = ""
    
    var estadisticas: [EstadisticaGral] = []
    var estadisticaClicked: EstadisticaGral = EstadisticaGral()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Utils.setTitleAndImage(self, "Ficha/Estadística", UIImage(named: "ficha")!)
        self.iconoSearch.image = UIImage.init(named: "search")?.withRenderingMode(.alwaysTemplate)
        self.iconoSearch.tintColor = UIColor.white
        containerData.isHidden = true
        viewNoData.isHidden = false
        let arrayMes = ["*", "Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio", "Julio", "Agosto", "Setiembre", "Octubre", "Noviembre", "Diciembre"]
        let arrayMesString = ["", "01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12"]
        let mesInt = Int(Utils.date2str(Date(), "MM")) ?? 0
        botonMes.setTitle(arrayMes[mesInt], for: .normal)
        mes = arrayMesString[mesInt]
        botonAnho.setTitle("\(Utils.currentYear)", for: .normal)
        buscar()
    }
    
    func showDropdown(_ boton: UIButton, _ dropDatasource: [String], _ resultDatasource: [String]) {
        dropdown.anchorView = boton
        dropdown.bottomOffset = CGPoint(x: 0, y: boton.bounds.height)
        dropdown.dataSource = dropDatasource
        dropdown.selectionAction = { (index, item) in
            boton.setTitle(item, for: .normal)
            if boton == self.botonAnho {
                self.anho = item
            }
            if boton == self.botonMes {
                self.mes = resultDatasource[index]
            }
        }
        dropdown.show()
    }
    
    func buscar(){
        Rest.getDataGeneral(Routes.forEstadisticaGeneral(codPersona, anho, mes), true, success: {(resultValue:Any?,data:Data?) in
            let hijo = self.childViewControllers[0] as! EstadGralTVC
            let arrayEstadGeneral: ArrayGeneral<EstadisticaGral> = Dict.dataToArray(data!)
            hijo.estadisticas = arrayEstadGeneral.Data
            if hijo.estadisticas.count > 0 {
                self.viewNoData.isHidden = true
                self.containerData.isHidden = false
            } else {
                self.viewNoData.isHidden = false
                self.containerData.isHidden = true
            }
            hijo.tableView.reloadData()
        }, error: nil)
    }
    
    @IBAction func clickEnAnho(_ sender: Any) {
        var anhos: [String] = ["*"]
        for i in (2014..<Utils.currentYear+1).reversed() {
            anhos.append("\(i)")
        }
        let boton = sender as! UIButton
        Utils.showDropdown(boton, anhos, {(index,item) in
            self.anho = item
            if item == "*" {
                self.botonMes.setTitle("*", for: .normal)
                self.mes = ""
            }
        })
    }
    
    @IBAction func clickEnMes(_ sender: Any) {
        if self.anho == "*" {
            return
        }
        let boton = sender as! UIButton
        Utils.showDropdown(boton, ["*", "Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio", "Julio", "Agosto", "Setiembre", "Octubre", "Noviembre", "Diciembre"], {(indice,item) in
            let realData = ["", "01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12"]
            self.mes = realData[indice]
        })
        // showDropdown(self.botonMes, , )
    }
    
    @IBAction func clickEnBuscar(_ sender: Any) {
        buscar()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toEstadDetalle" {
            let destination = segue.destination as! EstadDetalleVC
            destination.estadistica = self.estadisticaClicked
            destination.codPersona = self.codPersona
            destination.padreAnho = self.anho
            destination.padreMes = self.mes
            destination.padreLabelMes = self.botonMes.title(for: .normal)!
        }
    }
}
