import UIKit

class PlanesAccionVC: UIViewController, UITabBarDelegate {
    
    @IBOutlet weak var tabBar: UITabBar!
    
    @IBOutlet weak var estadisticas: UILabel!
    
    @IBOutlet weak var botonAnho: UIButton!
    
    @IBOutlet weak var botonMes: UIButton!
    
    @IBOutlet weak var sinOcurrencias: UILabel!
    
    @IBOutlet weak var tablaContainer: UIView!
    
    var tabla = PlanesAccionPendTVC()
    var anho = Utils.date2str(Date(), "YYYY")
    var mes = Utils.date2str(Date(), "MM")
    var shouldReload = false
    let mesesShow = ["*", "Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio", "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre"]
    let mesesRest = ["", "01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12"]
    var pagina = 1
    
    var mesUsado = ""
    var anhoUsado = ""
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if shouldReload {
            Rest.getDataGeneral(Routes.forPlanesAccionPendientes(Utils.userData.CodPersona ?? "", self.anho, self.mes, 1, 10), true, success: {(resultValue:Any?,data:Data?) in
                let planes: ArrayGeneral<PlanAccionGeneral> = Dict.dataToArray(data!)
                self.estadisticas.text = "(\(planes.Count)) Pendientes"
                self.sinOcurrencias.isHidden = planes.Data.count > 0
                self.sinOcurrencias.text = "No hubo ocurrencias"
                self.tablaContainer.isHidden = planes.Data.count <= 0
                if planes.Data.count > 0 {
                    self.tabla.planes = planes.Data
                    self.tabla.tableView.reloadData()
                }
                var contador = 0
                for unit in planes.Data {
                    Images.downloadAvatar(unit.CodSolicitadoPor ?? "", {() in
                        contador = contador + 1
                        if contador == planes.Data.count * 2 {
                            self.tabla.tableView.reloadData()
                        }
                    })
                    Images.downloadImage(unit.CodSolicitadoPor ?? "", {() in
                        contador = contador + 1
                        if contador == planes.Data.count * 2 {
                            self.tabla.tableView.reloadData()
                        }
                    })
                }
            }, error: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Utils.menuPlanesPendientes = self
        self.tabla = self.childViewControllers[0] as! PlanesAccionPendTVC
        self.pagina = 1
        self.anho = Utils.date2str(Date(), "YYYY")
        self.mes = Utils.date2str(Date(), "MM")
        self.estadisticas.text = "Estadisticas"
        self.sinOcurrencias.isHidden = true
        self.tablaContainer.isHidden = true
        self.botonAnho.setTitle(self.anho, for: .normal)
        self.botonMes.setTitle(self.mesesShow[Int(self.mes)!], for: .normal)
        
        self.tabla.forceUpdateFromFather = {
            let cantidad = self.tabla.planes.count > 10 ? self.tabla.planes.count : 10
            Rest.getDataGeneral(Routes.forPlanesAccionPendientes(Utils.userData.CodPersona ?? "", self.anhoUsado, self.mesUsado, 1, cantidad), true, success: {(resultValue:Any?,data:Data?) in
                let planes: ArrayGeneral<PlanAccionGeneral> = Dict.dataToArray(data!)
                self.estadisticas.text = "(\(planes.Count)) Pendientes"
                self.sinOcurrencias.isHidden = planes.Data.count > 0
                self.sinOcurrencias.text = "No hubo ocurrencias"
                self.tablaContainer.isHidden = planes.Data.count <= 0
                if planes.Data.count > 0 {
                    self.tabla.planes = planes.Data
                    self.tabla.tableView.reloadData()
                }
                var contador = 0
                for unit in planes.Data {
                    Images.downloadAvatar(unit.CodSolicitadoPor ?? "", {() in
                        contador = contador + 1
                        if contador == planes.Data.count * 2 {
                            self.tabla.tableView.reloadData()
                        }
                    })
                    Images.downloadImage(unit.CodSolicitadoPor ?? "", {() in
                        contador = contador + 1
                        if contador == planes.Data.count * 2 {
                            self.tabla.tableView.reloadData()
                        }
                    })
                }
            }, error: nil)
        }
        
        self.tabla.alScrollLimiteTop = {
            let cantidad = self.tabla.planes.count > 10 ? self.tabla.planes.count : 10
            Rest.getDataGeneral(Routes.forPlanesAccionPendientes(Utils.userData.CodPersona ?? "", self.anho, self.mes, 1, cantidad), true, success: {(resultValue:Any?,data:Data?) in
                let planes: ArrayGeneral<PlanAccionGeneral> = Dict.dataToArray(data!)
                self.estadisticas.text = "(\(planes.Count)) Pendientes"
                self.sinOcurrencias.isHidden = planes.Data.count > 0
                self.sinOcurrencias.text = "No hubo ocurrencias"
                self.tablaContainer.isHidden = planes.Data.count <= 0
                if planes.Data.count > 0 {
                    self.tabla.planes = planes.Data
                    self.tabla.tableView.reloadData()
                }
                var contador = 0
                for unit in planes.Data {
                    Images.downloadAvatar(unit.CodSolicitadoPor ?? "", {() in
                        contador = contador + 1
                        if contador == planes.Data.count * 2 {
                            self.tabla.tableView.reloadData()
                        }
                    })
                    Images.downloadImage(unit.CodSolicitadoPor ?? "", {() in
                        contador = contador + 1
                        if contador == planes.Data.count * 2 {
                            self.tabla.tableView.reloadData()
                        }
                    })
                }
            }, error: nil)
        }
        self.tabla.alScrollLimiteBot = {
            print(self.tabla.planes.count)
            /*var pagina = self.tabla.planes.count / 10
            if self.tabla.planes.count % 10 == 0 {
                pagina = pagina + 1
            }*/
            self.pagina = self.pagina + 1
            
            Rest.getDataGeneral(Routes.forPlanesAccionPendientes(Utils.userData.CodPersona ?? "", self.anho, self.mes, self.pagina, 10), true, success: {(resultValue:Any?,data:Data?) in
                // let planes = Dict.toArrayPlanAccionPendiente(dict)
                let planes: ArrayGeneral<PlanAccionGeneral> = Dict.dataToArray(data!)
                self.estadisticas.text = "(\(planes.Count)) Pendientes"
                self.sinOcurrencias.isHidden = planes.Data.count > 0
                self.sinOcurrencias.text = "No hubo ocurrencias"
                self.tablaContainer.isHidden = planes.Data.count <= 0
                if planes.Data.count > 0 {
                    self.tabla.planes.append(contentsOf: planes.Data)
                    self.tabla.tableView.reloadData()
                    // self.tabla.addMoreData(array: planes.Data)
                }
                var contador = 0
                for unit in planes.Data {
                    Images.downloadAvatar(unit.CodSolicitadoPor ?? "", {() in
                        contador = contador + 1
                        if contador == planes.Data.count * 2 {
                            self.tabla.tableView.reloadData()
                        }
                    })
                    Images.downloadImage(unit.CodSolicitadoPor ?? "", {() in
                        contador = contador + 1
                        if contador == planes.Data.count * 2 {
                            self.tabla.tableView.reloadData()
                        }
                    })
                }
            }, error: nil)
        }
        
        Utils.setTitleAndImage(self, "Planes de acción", Images.minero)
        self.tabBar.delegate = self
    }
    
    func initialLoad() {
        // self.anho = Utils.date2str(Date(), "YYYY")
        // self.mes = Utils.date2str(Date(), "MM")
        /*self.estadisticas.text = "Estaditicas"
        self.sinOcurrencias.text = ""
        self.sinOcurrencias.isHidden = false
        self.tablaContainer.isHidden = true*/
        // self.botonAnho.setTitle(Utils.date2str(Date(), "YYYY"), for: .normal)
        // self.botonMes.setTitle(Utils.date2str(Date(), "MMMM"), for: .normal)
        
        self.anhoUsado = self.anho
        self.mesUsado = self.mes
        Rest.getDataGeneral(Routes.forPlanesAccionPendientes(Utils.userData.CodPersona ?? "", self.anho, self.mes, 1, 10), true, success: {(resultValue:Any?,data:Data?) in
            // let planes = Dict.toArrayPlanAccionPendiente(dict)
            let planes: ArrayGeneral<PlanAccionGeneral> = Dict.dataToArray(data!)
            self.estadisticas.text = "(\(planes.Count)) Pendientes"
            self.sinOcurrencias.isHidden = planes.Data.count > 0
            self.sinOcurrencias.text = "No hubo ocurrencias"
            self.tablaContainer.isHidden = planes.Data.count <= 0
            if planes.Data.count > 0 {
                self.tabla.planes = planes.Data
                self.tabla.tableView.reloadData()
            }
            var contador = 0
            for unit in planes.Data {
                Images.downloadAvatar(unit.CodSolicitadoPor ?? "", {() in
                    contador = contador + 1
                    if contador == planes.Data.count * 2 {
                        self.tabla.tableView.reloadData()
                    }
                })
                Images.downloadImage(unit.CodSolicitadoPor ?? "", {() in
                    contador = contador + 1
                    if contador == planes.Data.count * 2 {
                        self.tabla.tableView.reloadData()
                    }
                })
            }
        }, error: nil)
        
    }
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        let index = tabBar.items!.index(of: item)
        Utils.menuVC.showTabIndexAt(index!)
    }
    
    @IBAction func ClickBotonAnho(_ sender: Any) {
        let boton = sender as! UIButton
        let anhos = Utils.getYearArray(true)
        /* var data = ["*"]
        data.append(contentsOf: anhos)*/
        Utils.showDropdown(boton, anhos, {(index,item) in
            self.anho = item
            if self.anho == "*" {
                self.mes = ""
                self.botonMes.setTitle("*", for: .normal)
            }
        })
    }
    
    @IBAction func ClickBotonMes(_ sender: Any) {
        if self.anho == "*" {
            return
        }
        let data = ["*", "Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio", "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre"]
        Utils.showDropdown(sender as! UIButton, data, {(index,item) in
            let codigoMes = ["", "01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12"]
            self.mes = codigoMes[index]
            print(self.mes)
        })
    }
    
    @IBAction func ClickBuscar(_ sender: Any) {
        self.pagina = 1
        self.mesUsado = self.mes
        self.anhoUsado = self.anho
        Rest.getDataGeneral(Routes.forPlanesAccionPendientes(Utils.userData.CodPersona ?? "", self.anho, self.mes, 1, 10), true, success: {(resultValue:Any?,data:Data?) in
            // let planes = Dict.toArrayPlanAccionPendiente(dict)
            let planes: ArrayGeneral<PlanAccionGeneral> = Dict.dataToArray(data!)
            self.estadisticas.text = "(\(planes.Count)) Pendientes"
            self.sinOcurrencias.isHidden = planes.Data.count > 0
            self.sinOcurrencias.text = "No hubo ocurrencias"
            self.tablaContainer.isHidden = planes.Data.count <= 0
            if planes.Data.count > 0 {
                self.tabla.planes = planes.Data
                self.tabla.tableView.reloadData()
            }
            var contador = 0
            for unit in planes.Data {
                Images.downloadAvatar(unit.CodSolicitadoPor ?? "", {() in
                    contador = contador + 1
                    if contador == planes.Data.count * 2 {
                        self.tabla.tableView.reloadData()
                    }
                })
                Images.downloadImage(unit.CodSolicitadoPor ?? "", {() in
                    contador = contador + 1
                    if contador == planes.Data.count * 2 {
                        self.tabla.tableView.reloadData()
                    }
                })
            }
        }, error: nil)
    }
    
    @IBAction func ClickTopIzq(_ sender: Any) {
        Utils.menuVC.showTabIndexAt(0)
    }
    
}
