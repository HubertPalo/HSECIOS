import UIKit
import DropDown

class EstadDetalleVC: UIViewController {
    
    @IBOutlet weak var botonAnho: UIButton!
    @IBOutlet weak var botonMes: UIButton!
    @IBOutlet weak var containerExtra: UIView!
    @IBOutlet weak var containerMuro: UIView!
    @IBOutlet weak var sinOcurrencias: UILabel!
    @IBOutlet weak var titulo: UILabel!
    @IBOutlet weak var iconoSearch: UIImageView!
    
    var padreLabelMes = ""
    var padreMes = ""
    var padreAnho = ""
    
    var estadistica = EstadisticaGral()
    var dropdown = DropDown()
    var anho = ""
    var mes = ""
    var codPersona = ""
    
    var alClickCelda: ((_ elemento: MuroElement) -> Void)?
    var alClickEditar: ((_ elemento: MuroElement) -> Void)?
    var alScrollLimiteTop: (() -> Void)?
    var alScrollLimiteBot: (() -> Void)?
    
    var data = ["ObservadoPor":"", "Lugar":"", "CodUbicacion":"", "FechaInicio":"", "FechaFin":""]
    
    let arrayMesDropdown = ["*", "Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio", "Julio", "Agosto", "Setiembre", "Octubre", "Noviembre", "Diciembre"]
    let arrayMesPost = ["", "01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12"]
    
    var detFullToSend = EstadisticaDetalle()
    
    var pageNo = 1
    var elemsPP = 10
    
    var hijoMuro = MuroTVC()
    var hijoExtra = EstadDetalleTVC()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Utils.setTitleAndImage(self, "Ficha/Estadística", UIImage(named: "ficha")!)
        self.iconoSearch.image = UIImage.init(named: "search")?.withRenderingMode(.alwaysTemplate)
        self.iconoSearch.tintColor = UIColor.white
        
        self.hijoExtra = self.childViewControllers[0] as! EstadDetalleTVC
        self.hijoMuro = self.childViewControllers[1] as! MuroTVC
        
        self.sinOcurrencias.isHidden = false
        self.containerMuro.isHidden = true
        self.containerExtra.isHidden = true
        
        botonMes.setTitle(padreLabelMes, for: .normal)
        botonAnho.setTitle(padreAnho, for: .normal)
        self.mes = self.padreMes
        self.anho = self.padreAnho
        titulo.text = "\(estadistica.Descripcion ?? "") (\(estadistica.Ejecutados ?? 0))"
        buscar(pageNo, elemsPP)
    }
    
    func buscar(_ pageNo: Int, _ elemsPP: Int ) {
        /*let hijo = self.childViewControllers[0] as! EstadDetalleTVC
        hijo.categoria = estadistica.Codigo ?? ""*/
        switch estadistica.Codigo ?? "" {
        case "-1":
            Rest.getDataGeneral(Routes.forFiltroFacilitoEstadistica(codPersona, anho == "*" ? "-" : anho, mes, pageNo, elemsPP), true, success: {(resultValue:Any?,data:Data?) in
                let arrayFacilito: ArrayGeneral<FacilitoElement> = Dict.dataToArray(data!)
                var arrayMuroElement = [MuroElement]()
                for unit in arrayFacilito.Data {
                    arrayMuroElement.append(unit.toMuroElement())
                }
                self.hijoMuro.data = arrayMuroElement
                self.hijoMuro.tableView.reloadData()
                for unit in arrayFacilito.Data {
                    if (unit.UrlObs ?? "") != "" {
                        Images.downloadAvatar(unit.UrlObs!, {() in
                            self.hijoMuro.tableView.reloadData()
                        })
                    }
                    if (unit.UrlPrew ?? "") != "" {
                        Images.downloadImage(unit.UrlPrew!, {() in
                            self.hijoMuro.tableView.reloadData()
                        })
                    }
                }
                
                self.containerExtra.isHidden = true
                self.containerMuro.isHidden = arrayFacilito.Data.count <= 0
                self.sinOcurrencias.isHidden = arrayFacilito.Data.count > 0
            }, error: nil)
        case "00":
            Rest.getDataGeneral(Routes.forPlanAccionGeneral(self.codPersona, anho, mes, pageNo, elemsPP), true, success: {(resultValue:Any?,data:Data?) in
                let planes: ArrayGeneral<PlanAccionGeneral> = Dict.dataToArray(data!)
                let hijo = self.childViewControllers[0] as! EstadDetalleTVC
                hijo.categoria = self.estadistica.Codigo ?? ""
                hijo.planesAccion = planes.Data
                hijo.tableView.reloadData()
                // self.viewNoData.isHidden = planes.Data.count > 0
                self.containerExtra.isHidden = planes.Data.count <= 0
            }, error: nil)
        case "01":
            self.data = [:]
            self.data["ObservadoPor"] = self.codPersona
            self.data["Lugar"] = "\(pageNo)"
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
            }
            if self.anho == "*" {
                let dates = Utils.getAllYearsRange()
                self.data["FechaInicio"] = dates.initialDate
                self.data["FechaFin"] = dates.endDate
            }
            Rest.postDataGeneral(Routes.forMuroSearchO(), self.data, true, success: {(resultValue:Any?,data:Data?) in
                let arrayUnit: ArrayGeneral<MuroElement> = Dict.dataToArray(data!)
                self.containerExtra.isHidden = true
                self.containerMuro.isHidden = arrayUnit.Count <= 0
                self.sinOcurrencias.isHidden = arrayUnit.Count > 0
                self.hijoMuro.data = arrayUnit.Data
                self.hijoMuro.tableView.reloadData()
                var contador = 0
                for unit in arrayUnit.Data {
                    Images.downloadAvatar(unit.UrlObs ?? "", {() in
                        contador = contador + 1
                        if contador == arrayUnit.Data.count * 2 {
                            self.hijoMuro.tableView.reloadData()
                        }
                    })
                    Images.downloadImage(unit.UrlPrew ?? "", {() in
                        contador = contador + 1
                        if contador == arrayUnit.Data.count * 2 {
                            self.hijoMuro.tableView.reloadData()
                        }
                    })
                }
            }, error: nil)
        case "02":
            self.data = [:]
            self.data["Elemperpage"] = "\(elemsPP)"
            self.data["Pagenumber"] = "\(pageNo)"
            self.data["CodTipo"] = self.codPersona
            if self.mes == "" {
                self.data["FechaP"] = "\(self.anho)-01-01"
                self.data["Fecha"] = "\(self.anho)-12-31"
            } else {
                self.data["FechaP"] = "\(self.anho)-\(self.mes)-01"
                self.data["Fecha"] = "\(self.anho)-\(self.mes)-31"
            }
            Rest.postDataGeneral(Routes.forMuroSearchI(), self.data, true, success: {(resultValue:Any?,data:Data?) in
                let arrayUnit: ArrayGeneral<MuroElement> = Dict.dataToArray(data!)
                self.containerExtra.isHidden = true
                self.containerMuro.isHidden = arrayUnit.Count <= 0
                self.sinOcurrencias.isHidden = arrayUnit.Count > 0
                self.hijoMuro.data = arrayUnit.Data
                self.hijoMuro.tableView.reloadData()
                var contador = 0
                for unit in arrayUnit.Data {
                    Images.downloadAvatar(unit.UrlObs ?? "", {() in
                        contador = contador + 1
                        if contador == arrayUnit.Data.count * 2 {
                            self.hijoMuro.tableView.reloadData()
                        }
                    })
                    Images.downloadImage(unit.UrlPrew ?? "", {() in
                        contador = contador + 1
                        if contador == arrayUnit.Data.count * 2 {
                            self.hijoMuro.tableView.reloadData()
                        }
                    })
                }
            }, error: nil)
        case "03":
            Rest.getDataGeneral(Routes.forEstadisticaDetalle(self.codPersona, self.anho, self.mes, self.estadistica.Codigo ?? ""), true, success: {(resultValue:Any?,data:Data?) in
                let arrayUnit: ArrayGeneral<EstadisticaDetalle> = Dict.dataToArray(data!)
                self.containerMuro.isHidden = true
                self.containerExtra.isHidden = arrayUnit.Count <= 0
                self.sinOcurrencias.isHidden = arrayUnit.Count > 0
                self.hijoExtra.incidentes = arrayUnit.Data
                self.hijoExtra.tableView.reloadData()
                var contador = 0
                for unit in arrayUnit.Data {
                    Images.downloadAvatar(unit.ResponsableDNI ?? "", {() in
                        contador = contador + 1
                        if contador == arrayUnit.Data.count {
                            self.hijoExtra.tableView.reloadData()
                        }
                    })
                }
                
            }, error: nil)
        case "04":
            Rest.getDataGeneral(Routes.forEstadisticaDetalle(self.codPersona, self.anho, self.mes, self.estadistica.Codigo ?? ""), true, success: {(resultValue:Any?,data:Data?) in
                let arrayUnit: ArrayGeneral<EstadisticaDetalle> = Dict.dataToArray(data!)
                self.containerMuro.isHidden = true
                self.containerExtra.isHidden = arrayUnit.Count <= 0
                self.sinOcurrencias.isHidden = arrayUnit.Count > 0
                self.hijoExtra.iperc = arrayUnit.Data
                self.hijoExtra.tableView.reloadData()
                var contador = 0
                for unit in arrayUnit.Data {
                    Images.downloadAvatar(unit.ResponsableDNI ?? "", {() in
                        contador = contador + 1
                        if contador == arrayUnit.Data.count {
                            self.hijoExtra.tableView.reloadData()
                        }
                    })
                }
            }, error: nil)
        case "05":
            Rest.getDataGeneral(Routes.forEstadisticaDetalle(self.codPersona, self.anho, self.mes, self.estadistica.Codigo ?? ""), true, success: {(resultValue:Any?,data:Data?) in
                let arrayUnit: ArrayGeneral<EstadisticaDetalle> = Dict.dataToArray(data!)
                self.containerMuro.isHidden = true
                self.containerExtra.isHidden = arrayUnit.Count <= 0
                self.sinOcurrencias.isHidden = arrayUnit.Count > 0
                self.hijoExtra.auditorias = arrayUnit.Data
                self.hijoExtra.tableView.reloadData()
                var contador = 0
                for unit in arrayUnit.Data {
                    Images.downloadAvatar(unit.ResponsableDNI ?? "", {() in
                        contador = contador + 1
                        if contador == arrayUnit.Data.count {
                            self.hijoExtra.tableView.reloadData()
                        }
                    })
                }
            }, error: nil)
        case "06":
            Rest.getDataGeneral(Routes.forEstadisticaDetalle(self.codPersona, self.anho, self.mes, self.estadistica.Codigo ?? ""), true, success: {(resultValue:Any?,data:Data?) in
                let arrayUnit: ArrayGeneral<EstadisticaDetalle> = Dict.dataToArray(data!)
                self.containerMuro.isHidden = true
                self.containerExtra.isHidden = arrayUnit.Count <= 0
                self.sinOcurrencias.isHidden = arrayUnit.Count > 0
                self.hijoExtra.simulacros = arrayUnit.Data
                self.hijoExtra.tableView.reloadData()
                var contador = 0
                for unit in arrayUnit.Data {
                    Images.downloadAvatar(unit.ResponsableDNI ?? "", {() in
                        contador = contador + 1
                        if contador == arrayUnit.Data.count {
                            self.hijoExtra.tableView.reloadData()
                        }
                    })
                }
            }, error: nil)
        case "07":
            Rest.getDataGeneral(Routes.forEstadisticaDetalle(self.codPersona, self.anho, self.mes, self.estadistica.Codigo ?? ""), true, success: {(resultValue:Any?,data:Data?) in
                let arrayUnit: ArrayGeneral<EstadisticaDetalle> = Dict.dataToArray(data!)
                self.containerMuro.isHidden = true
                self.containerExtra.isHidden = arrayUnit.Count <= 0
                self.sinOcurrencias.isHidden = arrayUnit.Count > 0
                self.hijoExtra.reuniones = arrayUnit.Data
                self.hijoExtra.tableView.reloadData()
                var contador = 0
                for unit in arrayUnit.Data {
                    Images.downloadAvatar(unit.ResponsableDNI ?? "", {() in
                        contador = contador + 1
                        if contador == arrayUnit.Data.count {
                            self.hijoExtra.tableView.reloadData()
                        }
                    })
                }
            }, error: nil)
        case "08":
            Rest.getDataGeneral(Routes.forEstadisticaDetalle(self.codPersona, self.anho, self.mes, self.estadistica.Codigo ?? ""), true, success: {(resultValue:Any?,data:Data?) in
                let arrayUnit: ArrayGeneral<EstadisticaDetalle> = Dict.dataToArray(data!)
                self.containerMuro.isHidden = true
                self.containerExtra.isHidden = arrayUnit.Count <= 0
                self.sinOcurrencias.isHidden = arrayUnit.Count > 0
                self.hijoExtra.comites = arrayUnit.Data
                self.hijoExtra.tableView.reloadData()
                var contador = 0
                for unit in arrayUnit.Data {
                    Images.downloadAvatar(unit.ResponsableDNI ?? "", {() in
                        contador = contador + 1
                        if contador == arrayUnit.Data.count {
                            self.hijoExtra.tableView.reloadData()
                        }
                    })
                }
            }, error: nil)
        default:
            break
        }
        
        
    }
    
    @IBAction func clickEnAnho(_ sender: Any) {
        let anhos = Utils.getYearArray(true)
        let boton = sender as! UIButton
        Utils.showDropdown(boton, anhos, {(indice,item) in
            self.anho = item
        })
    }
    
    @IBAction func clickEnMes(_ sender: Any) {
        let boton = sender as! UIButton
        Utils.showDropdown(boton, self.arrayMesDropdown, {(indice,item) in
            self.mes = self.arrayMesPost[indice]
        })
    }
    
    @IBAction func clickEnBuscar(_ sender: Any) {
        buscar(1, 10)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetFull" {
            let destination = segue.destination as! EstadDetFullTVC
            destination.tituloAnterior = estadistica.Descripcion ?? ""
            destination.celdaComunValues = [["Nº Doc. de Referencia", self.detFullToSend.NroDocReferencia ?? ""], ["Autor", self.detFullToSend.Responsable ?? ""], ["Fecha de creación", Utils.str2date2str(self.detFullToSend.Fecha ?? "")], ["Descripción", self.detFullToSend.Descripcion ?? ""]]
            var adicionales: [[String]] = []
            let splits = (self.detFullToSend.DatosAdicionales ?? "").components(separatedBy: ";")
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
