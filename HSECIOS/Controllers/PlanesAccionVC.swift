import UIKit

class PlanesAccionVC: UIViewController, UITabBarDelegate {
    
    @IBOutlet weak var tabBar: UITabBar!
    
    @IBOutlet weak var estadisticas: UILabel!
    
    @IBOutlet weak var botonAnho: UIButton!
    
    @IBOutlet weak var botonMes: UIButton!
    
    @IBOutlet weak var textoSinOcurrencias: UILabel!
    
    @IBOutlet weak var tablaContainer: UIView!
    
    var tabla = PlanesAccionPendTVC()
    var anho = Utils.date2str(Date(), "YYYY")
    var mes = Utils.date2str(Date(), "MM")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Utils.menuPlanesPendientes = self
        self.tabla = self.childViewControllers[0] as! PlanesAccionPendTVC
        
        
        self.tabla.alScrollLimiteTop = {
            let cantidad = self.tabla.planes.count > 10 ? self.tabla.planes.count : 10
            Rest.getDataGeneral(Routes.forPlanesAccionPendientes(Utils.userData.CodPersona ?? "", self.anho, self.mes, 1, cantidad), true, success: {(resultValue:Any?,data:Data?) in
                let planes: ArrayGeneral<PlanAccionGeneral> = Dict.dataToArray(data!)
                // let planes = Dict.toArrayPlanAccionPendiente(dict)
                self.estadisticas.text = "(\(planes.Count)) Pendientes"
                self.textoSinOcurrencias.isHidden = planes.Data.count > 0
                self.textoSinOcurrencias.text = "No hubo ocurrencias"
                self.tablaContainer.isHidden = planes.Data.count <= 0
                if planes.Data.count > 0 {
                    self.tabla.planes = planes.Data
                    self.tabla.tableView.reloadData()
                }
            }, error: nil)
        }
        self.tabla.alScrollLimiteBot = {
            var pagina = self.tabla.planes.count / 10
            if self.tabla.planes.count % 10 == 0 {
                pagina = pagina + 1
            }
            Rest.getDataGeneral(Routes.forPlanesAccionPendientes(Utils.userData.CodPersona ?? "", self.anho, self.mes, pagina, 10), true, success: {(resultValue:Any?,data:Data?) in
                // let planes = Dict.toArrayPlanAccionPendiente(dict)
                let planes: ArrayGeneral<PlanAccionGeneral> = Dict.dataToArray(data!)
                self.estadisticas.text = "(\(planes.Count)) Pendientes"
                self.textoSinOcurrencias.isHidden = planes.Data.count > 0
                self.textoSinOcurrencias.text = "No hubo ocurrencias"
                self.tablaContainer.isHidden = planes.Data.count <= 0
                if planes.Data.count > 0 {
                    self.tabla.addMoreData(array: planes.Data)
                }
            }, error: nil)
        }
        
        Utils.setTitleAndImage(self, "Planes de acción", Images.minero)
        self.tabBar.delegate = self
        self.estadisticas.text = "Estaditicas"
        self.textoSinOcurrencias.text = ""
        self.textoSinOcurrencias.isHidden = false
        self.tablaContainer.isHidden = true
        self.botonAnho.setTitle(Utils.date2str(Date(), "YYYY"), for: .normal)
        self.botonMes.setTitle(Utils.date2str(Date(), "MMMM"), for: .normal)
    }
    
    func initialLoad() {
        self.anho = Utils.date2str(Date(), "YYYY")
        self.mes = Utils.date2str(Date(), "MM")
        self.estadisticas.text = "Estaditicas"
        self.textoSinOcurrencias.text = ""
        self.textoSinOcurrencias.isHidden = false
        self.tablaContainer.isHidden = true
        self.botonAnho.setTitle(Utils.date2str(Date(), "YYYY"), for: .normal)
        self.botonMes.setTitle(Utils.date2str(Date(), "MMMM"), for: .normal)
        Rest.getDataGeneral(Routes.forPlanesAccionPendientes(Utils.userData.CodPersona ?? "", self.anho, self.mes, 1, 10), true, success: {(resultValue:Any?,data:Data?) in
            // let planes = Dict.toArrayPlanAccionPendiente(dict)
            let planes: ArrayGeneral<PlanAccionGeneral> = Dict.dataToArray(data!)
            self.estadisticas.text = "(\(planes.Count)) Pendientes"
            self.textoSinOcurrencias.isHidden = planes.Data.count > 0
            self.textoSinOcurrencias.text = "No hubo ocurrencias"
            self.tablaContainer.isHidden = planes.Data.count <= 0
            if planes.Data.count > 0 {
                self.tabla.planes = planes.Data
                self.tabla.tableView.reloadData()
            }
        }, error: nil)
    }
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        let index = tabBar.items!.index(of: item)
        Utils.menuVC.showTabIndexAt(index!)
    }
    
    @IBAction func ClickBotonAnho(_ sender: Any) {
        let anhos = Utils.getYearArray()
        var data = ["*"]
        data.append(contentsOf: anhos)
        Utils.showDropdown(sender as! UIButton, data, {(index,item) in
            self.anho = item
            print(self.anho)
        })
    }
    
    @IBAction func ClickBotonMes(_ sender: Any) {
        let data = ["*", "Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio", "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre"]
        Utils.showDropdown(sender as! UIButton, data, {(index,item) in
            let codigoMes = ["", "01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12"]
            self.mes = codigoMes[index]
            print(self.mes)
        })
    }
    
    @IBAction func ClickBuscar(_ sender: Any) {
        Rest.getDataGeneral(Routes.forPlanesAccionPendientes(Utils.userData.CodPersona ?? "", self.anho, self.mes, 1, 10), true, success: {(resultValue:Any?,data:Data?) in
            // let planes = Dict.toArrayPlanAccionPendiente(dict)
            let planes: ArrayGeneral<PlanAccionGeneral> = Dict.dataToArray(data!)
            self.estadisticas.text = "(\(planes.Count)) Pendientes"
            self.textoSinOcurrencias.isHidden = planes.Data.count > 0
            self.textoSinOcurrencias.text = "No hubo ocurrencias"
            self.tablaContainer.isHidden = planes.Data.count <= 0
            if planes.Data.count > 0 {
                self.tabla.planes = planes.Data
                self.tabla.tableView.reloadData()
            }
        }, error: nil)
    }
    
    @IBAction func ClickTopIzq(_ sender: Any) {
        Utils.menuVC.showTabIndexAt(0)
    }
    
}
