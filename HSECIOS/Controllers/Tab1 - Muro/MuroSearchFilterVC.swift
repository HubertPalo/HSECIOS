import UIKit
import DropDown

/*class MuroSearchFilterVC: UIViewController {
    
    @IBOutlet weak var filterCodigo: UITextField!
    
    @IBOutlet weak var filterArea: UIButton!
    
    @IBOutlet weak var filterTipo: UIButton!
    
    @IBOutlet weak var filterRiesgo: UIButton!
    
    @IBOutlet weak var filterFechaInicio: UIButton!
    
    @IBOutlet weak var filterFechaFin: UIButton!
    
    @IBOutlet weak var filterGerencia: UIButton!
    
    @IBOutlet weak var filterSuperintendencia: UIButton!
    
    
    
    let dropdown = DropDown()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func clickEnFilterArea(_ sender: Any) {
        Utils.showDropdown(sender as! UIButton, Utils.maestroDescripcion["AREA"] ?? [], {(index,item) in
            
        })
        /*Utils.setDropdown(dropdown, filterArea, [String].init(Globals.obsArea.values), afterClickFilterArea(_:_:))
        dropdown.show()*/
    }
    
    @IBAction func clickEnFilterTipo(_ sender: Any) {
        Utils.showDropdown(sender as! UIButton, Utils.maestroDescripcion["TPOB"] ?? [], {(index,item) in
            
        })
        /*Utils.setDropdown(dropdown, filterTipo, [String].init(Globals.obsTipo.values), afterClickFilterTipo(_:_:))
        dropdown.show()*/
    }
    
    @IBAction func clickEnFilterRiesgo(_ sender: Any) {
        Utils.showDropdown(sender as! UIButton, Utils.maestroStatic2["NIVELRIESGO"] ?? [], {(index,item) in
            
        })
        /*Utils.setDropdown(dropdown, filterRiesgo, [String].init(Globals.obsRiesgo.values), afterClickFilterRiesgo(_:_:))
        dropdown.show()*/
    }
    
    @IBAction func clickEnFilterFechaInicio(_ sender: Any) {
        Utils.openDatePicker("Fecha Inicio", Utils.MSFFechaInicio, nil, Utils.MSFFechaFin, chandler: afterSelectFechaInicio(_:))
    }
    
    @IBAction func clickEnFilterFechaFin(_ sender: Any) {
        Utils.openDatePicker("Fecha Fin", Utils.MSFFechaFin, Utils.MSFFechaInicio, nil, chandler: afterSelectFechaFin(_:))
    }
    
    @IBAction func clickEnFilterGerencia(_ sender: Any) {
        Utils.showDropdown(sender as! UIButton, ["-"], {(index,item) in
            
        })
        /*Utils.setDropdown(dropdown, filterGerencia, ["-"], afterClickFilterGerencia(_:_:))
        dropdown.show()*/
    }
    
    @IBAction func clickEnFilterSuperintendencia(_ sender: Any) {
        Utils.showDropdown(sender as! UIButton, ["Seguridad", "Salud Ocupacional", "Comunidades"], {(index,item) in
            
        })
        /*Utils.setDropdown(dropdown, filterSuperintendencia, ["Seguridad", "Salud Ocupacional", "Comunidades"], afterClickFilterSuperintendencia(_:_:)   )
        dropdown.show()*/
    }
    func afterSelectFechaInicio(_ date: Date?) {
        if let fecha = date {
            print(Utils.date2str(fecha))
            Utils.MSFFechaInicio = date!
            filterFechaInicio.setTitle(Utils.date2str(date!, "dd 'de' MMMM 'de' yyyy"), for: .normal)
        }
    }
    func afterSelectFechaFin (_ date: Date?) {
        if let fecha = date {
            print(Utils.date2str(fecha))
            Utils.MSFFechaFin = date!
            filterFechaFin.setTitle(Utils.date2str(date!, "dd 'de' MMMM 'de' yyyy"), for: .normal)
        }
    }
    /*func afterClickFilterArea(_ index: Int, _ item: String) {
        filterArea.setTitle(item, for: .normal)
    }
    func afterClickFilterTipo(_ index: Int, _ item: String) {
        filterTipo.setTitle(item, for: .normal)
    }
    func afterClickFilterRiesgo(_ index: Int, _ item: String) {
        filterRiesgo.setTitle(item, for: .normal)
    }
    func afterClickFilterGerencia(_ index: Int, _ item: String) {
        filterGerencia.setTitle(item, for: .normal)
    }
    func afterClickFilterSuperintendencia(_ index: Int, _ item: String) {
        filterSuperintendencia.setTitle(item, for: .normal)
    }*/
    
    func updateSelectedPersona() {
        
    }
}*/
