import UIKit
import DropDown

class EstadDetalleVC: UIViewController {
    
    @IBOutlet weak var botonAnho: UIButton!
    
    @IBOutlet weak var botonMes: UIButton!
    
    @IBOutlet weak var viewNoData: UIView!
    
    @IBOutlet weak var containerData: UIView!
    
    @IBOutlet weak var titulo: UILabel!
    
    var padreLabelMes = ""
    var padreMes = ""
    var padreAnho = ""
    
    var estadistica = EstadisticaGral()
    var dropdown = DropDown()
    var anho = ""
    var mes = ""
    var codPersona = ""
    
    var data = ["ObservadoPor":"", "Lugar":"", "CodUbicacion":"", "FechaInicio":"", "FechaFin":""]
    
    let arrayMesDropdown = ["-", "Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio", "Julio", "Agosto", "Setiembre", "Octubre", "Noviembre", "Diciembre"]
    let arrayMesPost = ["", "01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12"]
    
    var detFullToSend = EstadisticaDetalle()
    
    var elemsPP = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //print("asdasdsadsada - \(Utils.currentMonth)")
        viewNoData.isHidden = false
        containerData.isHidden = true
        //let mesInt = Int(Utils.date2str(Date(), "MM")) ?? 0
        //botonMes.setTitle(arrayMesDropdown[mesInt], for: .normal)
        botonMes.setTitle(padreLabelMes, for: .normal)
        //mes = arrayMesPost[mesInt]
        botonAnho.setTitle(padreAnho, for: .normal)
        mes = padreMes
        anho = padreAnho
        titulo.text = "\(estadistica.Descripcion) (\(estadistica.Ejecutados))"
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
    
    func buscar() {
        let hijo = self.childViewControllers[0] as! EstadDetalleTVC
        hijo.categoria = estadistica.Codigo
        let cantidad = Int(estadistica.Ejecutados) ?? 0
        let pagina = 1
        switch estadistica.Codigo {
        case "-1":
            self.data = [:]
            self.data ["Observacion"] = "\(pagina)"
            self.data ["Accion"] = "\(cantidad)"
            if self.anho != "*" {
                
            }
            if self.mes != "*" {
                
            }
            
            Rest.postDataGeneral(Routes.forFiltroFacilito(), self.data, true, success: {(resultValue:Any?,data:Data?) in
                let facilitos: ArrayGeneral<FacilitoElement> = Dict.dataToArray(data!)
                hijo.facilitos = facilitos.Data
                hijo.tableView.reloadData()
                self.viewNoData.isHidden = facilitos.Data.count > 0
                self.containerData.isHidden = facilitos.Data.count <= 0
            }, error: nil)
        case "00":
            Rest.getDataGeneral(Routes.forPlanAccionGeneral(self.codPersona, anho, mes, 1, elemsPP), true, success: {(resultValue:Any?,data:Data?) in
                let planes: ArrayGeneral<PlanAccionGeneral> = Dict.dataToArray(data!)
                // let planes = Dict.toArrayPlanAccionGeneral(dict)
                hijo.planesAccion = planes.Data
                hijo.tableView.reloadData()
                self.viewNoData.isHidden = planes.Data.count > 0
                self.containerData.isHidden = planes.Data.count <= 0
            }, error: nil)
            /*Rest.getData(Routes.forPlanAccionGeneral(self.codPersona, anho, mes, 1, elemsPP), true, vcontroller: self, success: {(dict: NSDictionary) in
                let planes = Dict.toArrayPlanAccionGeneral(dict)
                hijo.planesAccion = planes
                hijo.tableView.reloadData()
                self.viewNoData.isHidden = planes.count > 0
                self.containerData.isHidden = planes.count <= 0
            })*/
        case "01":
            self.data = [:]
            self.data["ObservadoPor"] = self.codPersona
            self.data["Lugar"] = "1"
            self.data["CodUbicacion"] = "\(elemsPP)"
            
            if self.mes == "" {
                self.data["FechaInicio"] = "\(self.anho)-01-01"
                self.data["FechaFin"] = "\(self.anho)-12-30"
            } else {
                print("\(self.anho)-\(self.mes)-05")
                let fecha = Utils.str2date("\(self.anho)-\(self.mes)-05", "YYYY-MM-dd")!
                let rango = Utils.getDateMonthInterval(fecha)
                self.data["FechaInicio"] = Utils.date2str(rango.initialDate, "YYYY-MM-dd")
                self.data["FechaFin"] = Utils.date2str(rango.endDate, "YYYY-MM-dd")
                // self.data["FechaInicio"] = "\(self.anho)-\(self.mes)-01"
                // self.data["FechaFin"] = "\(self.anho)-\(self.mes)-31"
            }
            if self.anho == "*" {
                let dates = Utils.getAllYearsRange()
                self.data["FechaInicio"] = dates.initialDate
                self.data["FechaFin"] = dates.endDate
                // (, self.data["FechaFin"])
            }
            Rest.postDataGeneral(Routes.forMuroSearchO(), self.data, true, success: {(resultValue:Any?,data:Data?) in
                let observaciones: ArrayGeneral<MuroElement> = Dict.dataToArray(data!)
                // let observaciones: [MuroElement] = Dict.toArrayMuroElement(dict)
                hijo.observaciones = observaciones.Data
                hijo.tableView.reloadData()
                self.viewNoData.isHidden = observaciones.Data.count > 0
                self.containerData.isHidden = observaciones.Data.count <= 0
            }, error: nil)
            /*Rest.postData(Routes.forMuroSearchO(), data, true, vcontroller: self, success: {(dict: NSDictionary) in
                let observaciones: [MuroElement] = Dict.toArrayMuroElement(dict)
                hijo.observaciones = observaciones
                hijo.tableView.reloadData()
                self.viewNoData.isHidden = observaciones.count > 0
                self.containerData.isHidden = observaciones.count <= 0
            })*/
        case "02":
            self.data = [:]
            self.data["Elemperpage"] = "\(elemsPP)"
            self.data["Pagenumber"] = "1"
            self.data["CodTipo"] = self.codPersona
            if self.mes == "" {
                self.data["FechaP"] = "\(self.anho)-01-01"
                self.data["Fecha"] = "\(self.anho)-12-31"
            } else {
                self.data["FechaP"] = "\(self.anho)-\(self.mes)-01"
                self.data["Fecha"] = "\(self.anho)-\(self.mes)-31"
            }
            Rest.postDataGeneral(Routes.forMuroSearchI(), self.data, true, success: {(resultValue:Any?,data:Data?) in
                let inspecciones: ArrayGeneral<MuroElement> = Dict.dataToArray(data!)
                hijo.inspecciones = inspecciones.Data
                hijo.tableView.reloadData()
                self.viewNoData.isHidden = inspecciones.Data.count > 0
                self.containerData.isHidden = inspecciones.Data.count <= 0
            }, error: nil)
            /*Rest.postData(Routes.forMuroSearchI(), data, true, vcontroller: self, success: {(dict: NSDictionary) in
                let inspecciones: [MuroElement] = Dict.toArrayMuroElement(dict)
                hijo.inspecciones = inspecciones
                hijo.tableView.reloadData()
                self.viewNoData.isHidden = inspecciones.count > 0
                self.containerData.isHidden = inspecciones.count <= 0
            })*/
        case "03":
            Rest.getDataGeneral(Routes.forEstadisticaDetalle(self.codPersona, self.anho, self.mes, self.estadistica.Codigo), true, success: {(resultValue:Any?,data:Data?) in
                let incidentes: ArrayGeneral<EstadisticaDetalle> = Dict.dataToArray(data!)
                hijo.incidentes = incidentes.Data
                hijo.tableView.reloadData()
                self.viewNoData.isHidden = incidentes.Data.count > 0
                self.containerData.isHidden = incidentes.Data.count <= 0
            }, error: nil)
            /*Rest.getData(Routes.forEstadisticaDetalle(self.codPersona, self.anho, self.mes, self.estadistica.Codigo), true, vcontroller: self, success: {(dict: NSDictionary) in
                let incidentes = Dict.toArrayEstadisticaDetalle(dict)
                hijo.incidentes = incidentes
                hijo.tableView.reloadData()
                self.viewNoData.isHidden = incidentes.count > 0
                self.containerData.isHidden = incidentes.count <= 0
            })*/
        case "04":
            Rest.getDataGeneral(Routes.forEstadisticaDetalle(self.codPersona, self.anho, self.mes, self.estadistica.Codigo), true, success: {(resultValue:Any?,data:Data?) in
                let iperc: ArrayGeneral<EstadisticaDetalle> = Dict.dataToArray(data!)
                hijo.iperc = iperc.Data
                hijo.tableView.reloadData()
                self.viewNoData.isHidden = iperc.Data.count > 0
                self.containerData.isHidden = iperc.Data.count <= 0
            }, error: nil)
            /*Rest.getData(Routes.forEstadisticaDetalle(self.codPersona, self.anho, self.mes, self.estadistica.Codigo), true, vcontroller: self, success: {(dict: NSDictionary) in
                let iperc = Dict.toArrayEstadisticaDetalle(dict)
                hijo.iperc = iperc
                hijo.tableView.reloadData()
                self.viewNoData.isHidden = iperc.count > 0
                self.containerData.isHidden = iperc.count <= 0
            })*/
        case "05":
            Rest.getDataGeneral(Routes.forEstadisticaDetalle(self.codPersona, self.anho, self.mes, self.estadistica.Codigo), true, success: {(resultValue:Any?,data:Data?) in
                let auditorias: ArrayGeneral<EstadisticaDetalle> = Dict.dataToArray(data!)
                hijo.auditorias = auditorias.Data
                hijo.tableView.reloadData()
                self.viewNoData.isHidden = auditorias.Data.count > 0
                self.containerData.isHidden = auditorias.Data.count <= 0
            }, error: nil)
            /*Rest.getData(Routes.forEstadisticaDetalle(self.codPersona, self.anho, self.mes, self.estadistica.Codigo), true, vcontroller: self, success: {(dict: NSDictionary) in
                let auditorias = Dict.toArrayEstadisticaDetalle(dict)
                hijo.auditorias = auditorias
                hijo.tableView.reloadData()
                self.viewNoData.isHidden = auditorias.count > 0
                self.containerData.isHidden = auditorias.count <= 0
            })*/
        case "06":
            Rest.getDataGeneral(Routes.forEstadisticaDetalle(self.codPersona, self.anho, self.mes, self.estadistica.Codigo), true, success: {(resultValue:Any?,data:Data?) in
                let simulacros: ArrayGeneral<EstadisticaDetalle> = Dict.dataToArray(data!)
                hijo.simulacros = simulacros.Data
                hijo.tableView.reloadData()
                self.viewNoData.isHidden = simulacros.Data.count > 0
                self.containerData.isHidden = simulacros.Data.count <= 0
            }, error: nil)
            /*Rest.getData(Routes.forEstadisticaDetalle(self.codPersona, self.anho, self.mes, self.estadistica.Codigo), true, vcontroller: self, success: {(dict: NSDictionary) in
                let simulacros = Dict.toArrayEstadisticaDetalle(dict)
                hijo.simulacros = simulacros
                hijo.tableView.reloadData()
                self.viewNoData.isHidden = simulacros.count > 0
                self.containerData.isHidden = simulacros.count <= 0
            })*/
        case "07":
            Rest.getDataGeneral(Routes.forEstadisticaDetalle(self.codPersona, self.anho, self.mes, self.estadistica.Codigo), true, success: {(resultValue:Any?,data:Data?) in
                let reuniones: ArrayGeneral<EstadisticaDetalle> = Dict.dataToArray(data!)
                hijo.reuniones = reuniones.Data
                hijo.tableView.reloadData()
                self.viewNoData.isHidden = reuniones.Data.count > 0
                self.containerData.isHidden = reuniones.Data.count <= 0
            }, error: nil)
            /*Rest.getData(Routes.forEstadisticaDetalle(self.codPersona, self.anho, self.mes, self.estadistica.Codigo), true, vcontroller: self, success: {(dict: NSDictionary) in
                let reuniones = Dict.toArrayEstadisticaDetalle(dict)
                hijo.reuniones = reuniones
                hijo.tableView.reloadData()
                self.viewNoData.isHidden = reuniones.count > 0
                self.containerData.isHidden = reuniones.count <= 0
            })*/
        case "08":
            Rest.getDataGeneral(Routes.forEstadisticaDetalle(self.codPersona, self.anho, self.mes, self.estadistica.Codigo), true, success: {(resultValue:Any?,data:Data?) in
                let comites: ArrayGeneral<EstadisticaDetalle> = Dict.dataToArray(data!)
                hijo.comites = comites.Data
                hijo.tableView.reloadData()
                self.viewNoData.isHidden = comites.Data.count > 0
                self.containerData.isHidden = comites.Data.count <= 0
            }, error: nil)/*Rest.getData(Routes.forEstadisticaDetalle(self.codPersona, self.anho, self.mes, self.estadistica.Codigo), true, vcontroller: self, success: {(dict: NSDictionary) in
                let comites = Dict.toArrayEstadisticaDetalle(dict)
                hijo.comites = comites
                hijo.tableView.reloadData()
                self.viewNoData.isHidden = comites.count > 0
                self.containerData.isHidden = comites.count <= 0
            })*/
        default:
            break
        }
        
        
    }
    
    @IBAction func clickEnAnho(_ sender: Any) {
        var anhos: [String] = []
        for i in (2014..<Utils.currentYear+1).reversed() {
            anhos.append("\(i)")
        }
        showDropdown(self.botonAnho, anhos, anhos)
    }
    
    @IBAction func clickEnMes(_ sender: Any) {
        showDropdown(self.botonMes, self.arrayMesDropdown, self.arrayMesPost)
    }
    
    @IBAction func clickEnBuscar(_ sender: Any) {
        buscar()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetFull" {
            let destination = segue.destination as! EstadDetFullTVC
            destination.tituloAnterior = estadistica.Descripcion
            destination.celdaComunValues = [["Nº Doc. de Referencia", self.detFullToSend.NroDocReferencia], ["Autor", self.detFullToSend.Responsable], ["Fecha de creación", self.detFullToSend.Fecha], ["Descripción", self.detFullToSend.Descripcion]]
            var adicionales: [[String]] = []
            let splits = self.detFullToSend.DatosAdicionales.components(separatedBy: ";")
            for i in 0..<splits.count {
                let fila = splits[i].components(separatedBy: ":")
                if fila.count > 1 {
                    adicionales.append([fila[0], fila[1]])
                }
            }
            destination.celdaAdicionalValues = adicionales
        }
    }
}
