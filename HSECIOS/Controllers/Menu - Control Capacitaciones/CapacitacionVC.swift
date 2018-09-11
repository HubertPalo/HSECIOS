
import UIKit

class CapacitacionVC: UIViewController, UITabBarDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tabBar: UITabBar!
    @IBOutlet weak var Cursos: UILabel!
    @IBOutlet weak var botonAnho: UIButton!
    @IBOutlet weak var botonMes: UIButton!
    
    @IBOutlet weak var textoSinOcurrencias: UILabel!
    
    @IBOutlet weak var imgsearch: UIImageView!
    @IBOutlet weak var TablaCap: UITableView!
    //
    var datainfo = ""
    var cursosCap: [CapCursoGeneral] = []
    var externalCount = -1
    //var capacitacion = CapacitacionVC()
    
    var anho = Utils.date2str(Date(), "YYYY")
    var mes = Utils.date2str(Date(), "MM")
    //var cursos;
    //var ejemplo = [String]()
    var rightLabels: [String] = ["-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-"]
    var splitExpositor = [String]()
    
    
    func cleanData() {
        self.cursosCap = []
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Utils.menuCapRecibidas=self
        //imgsearch.image = imgsearch.image?.withRenderingMode(.alwaysTemplate)
        //imgsearch.tintColor = .white
        
        self.TablaCap.delegate=self
        self.TablaCap.dataSource=self
        
        
        Utils.setTitleAndImage(self, "Capacitaciones", Images.minero)
        self.tabBar.delegate = self
        self.Cursos.text = "Cursos"
        
        self.textoSinOcurrencias.text = ""
        self.textoSinOcurrencias.isHidden = false
        self.TablaCap.isHidden = true
        
        self.botonAnho.setTitle(Utils.date2str(Date(), "YYYY"), for: .normal)
        self.botonMes.setTitle(Utils.date2str(Date(), "MMMM"), for: .normal)
        
    }
    
    func initialLoad() {
        self.externalCount = -1
        self.anho = Utils.date2str(Date(), "YYYY")
        self.mes = Utils.date2str(Date(), "MM")
        self.Cursos.text = "Cursos"
        self.textoSinOcurrencias.text = ""
        self.textoSinOcurrencias.isHidden = false
        self.botonAnho.setTitle(Utils.date2str(Date(), "YYYY"), for: .normal)
        self.botonMes.setTitle(Utils.date2str(Date(), "MMMM"), for: .normal)
        
        Rest.getDataGeneral(Routes.forCapacitacionGeneral("*", self.anho, self.mes, 1, 10), true, success: {(resultValue:Any?,data:Data?) in
            // let planes = Dict.toArrayPlanAccionPendiente(dict)
            let cursos: ArrayGeneral<CapCursoGeneral> = Dict.dataToArray(data!)
            self.externalCount = cursos.Count
            self.Cursos.text = "(\(cursos.Count)) Cursos"
            self.textoSinOcurrencias.isHidden = cursos.Data.count > 0
            self.textoSinOcurrencias.text = "No hubo ocurrencias"
            self.TablaCap.isHidden = cursos.Data.count <= 0
            
            if cursos.Data.count > 0 {
                self.cursosCap = cursos.Data
                self.TablaCap.reloadData()
            }
        }, error: nil)
    }
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        let index = tabBar.items!.index(of: item)
        Utils.menuVC.showTabIndexAt(index!)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cursosCap.count
    }
    
    //añadir valores a la tabla
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: "celda") as! CapacitacionVCell
        let unit = cursosCap[indexPath.row]
        celda.curso.text = Utils.searchMaestroDescripcion("CTEM", unit.CodTema ?? "")
        celda.Fecha.text = Utils.str2date2str(unit.Fecha ?? "")
        celda.Hora.text = Utils.Duracion_curso(String(describing: unit.Duracion!))  //?? "" //convertir a horas
        celda.Empresa.text = Utils.searchMaestroDescripcion("CEMP", unit.Empresa ?? "")
        celda.Tipo.text = Utils.searchMaestroDescripcion("CTIP", unit.Tipo ?? "")
        celda.recurrencia.isHidden = unit.Recurrence == "0"
        
        //searchMaestroDescripcion
        //CodTema
        return celda
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let currentOffset = scrollView.contentOffset.y
        if currentOffset <= -10 {
            //self.alScrollLimiteTop?()
            let cantidad = self.cursosCap.count > 10 ? self.cursosCap.count : 10
            
            Rest.getDataGeneral(Routes.forCapacitacionGeneral("*", self.anho, self.mes, 1, cantidad), true, success: {(resultValue:Any?,data:Data?) in
                // let planes = Dict.toArrayPlanAccionPendiente(dict)
                let cursos: ArrayGeneral<CapCursoGeneral> = Dict.dataToArray(data!)
                self.externalCount = cursos.Count
                self.Cursos.text = "(\(cursos.Count)) Cursos"
                self.textoSinOcurrencias.isHidden = self.cursosCap.count > 0
                self.textoSinOcurrencias.text = "No hubo ocurrencias"
                self.TablaCap.isHidden = cursos.Data.count <= 0
                
                if cursos.Data.count > 0 {
                    self.cursosCap = cursos.Data
                    self.TablaCap.reloadData()
                } }, error: nil)
            
        } else {
            let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
            if maximumOffset - currentOffset <= -10 {
                //self.alScrollLimiteBot?()
                var pagina = self.cursosCap.count / 10
                pagina = pagina + 1
                if self.externalCount != -1 && self.cursosCap.count == self.externalCount {
                    return
                }
                /*if self.cursosCap.count % 10 == 0 {
                    pagina = pagina + 1
                }*/
                Rest.getDataGeneral(Routes.forCapacitacionGeneral("*", self.anho, self.mes, pagina, 10), true, success: {(resultValue:Any?,data:Data?) in
                    // let planes = Dict.toArrayPlanAccionPendiente(dict)
                    let cursos: ArrayGeneral<CapCursoGeneral> = Dict.dataToArray(data!)
                    self.externalCount = cursos.Count
                    self.Cursos.text = "(\(cursos.Count)) Cursos"
                    self.textoSinOcurrencias.isHidden = self.cursosCap.count > 0
                    self.textoSinOcurrencias.text = "No hubo ocurrencias"
                    self.TablaCap.isHidden = self.cursosCap.count <= 0
                    self.cursosCap.append(contentsOf: cursos.Data)
                    self.TablaCap.reloadData()
                    /*if cursos.Data.count > 0 {
                        self.addMoreData(array: cursos.Data)
                    }*/
                }, error: nil)
            }
        }
    }
    
    func addMoreData(array:[CapCursoGeneral]) {
        // var nuevaData: [PlanAccionPendiente] = []
        var codigos: [String] = []
        for i in 0..<self.cursosCap.count {
            codigos.append(self.cursosCap[i].CodCurso!)
        }
        for i in 0..<array.count {
            if !codigos.contains(array[i].CodCurso!) {
                self.cursosCap.append(array[i])
            }
        }
        self.TablaCap.reloadData()
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
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        let unit = self.cursosCap[indexPath.row]
        datainfo=unit.CodCurso ?? ""
        //Utils.capCursoDetalle.loadData(datainfo)
        self.performSegue(withIdentifier: "asd", sender: self)
        
        
        /*
         let vc = CapCursoDetalle()
         vc.codCurso = datainfo
         //Utils.capCursoDetalle.loadData()
         navigationController?.pushViewController(vc, animated: true)
         */
    }
    
    
    @IBAction func ClickBuscar(_ sender: Any) {
        Rest.getDataGeneral(Routes.forCapacitacionGeneral("*", self.anho, self.mes, 1, 10), true, success: {(resultValue:Any?,data:Data?) in
            // let planes = Dict.toArrayPlanAccionPendiente(dict)
            let cursos: ArrayGeneral<CapCursoGeneral> = Dict.dataToArray(data!)
            self.externalCount = cursos.Count
            self.Cursos.text = "(\(cursos.Count)) Cursos"
            self.textoSinOcurrencias.isHidden = cursos.Data.count > 0
            self.textoSinOcurrencias.text = "No hubo ocurrencias"
            self.TablaCap.isHidden = cursos.Data.count <= 0
            
            if cursos.Data.count > 0 {
                self.cursosCap = cursos.Data
                self.TablaCap.reloadData()
            }
        }, error: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.destination is CapCursoDetalle
        {
            let vc = segue.destination as? CapCursoDetalle
            //vc?.loadData(datainfo)
            vc?.codCurso = datainfo
            //vc?.rightLabels = rightLabels
            //vc?.splitExpositor = splitExpositor
            
            //
        }
    }
    
    @IBAction func ClickTopIzq(_ sender: Any) {
        Utils.menuVC.showTabIndexAt(0)
        //Utils.openMenuTab()
        
    }
    
    
    
    
}

class CapacitacionVCell: UITableViewCell {
    
    @IBOutlet weak var curso: UILabel!
    @IBOutlet weak var Fecha: UILabel!
    @IBOutlet weak var Hora: UILabel!
    @IBOutlet weak var recurrencia: UIImageView!
    @IBOutlet weak var Empresa: UILabel!
    
    @IBOutlet weak var Tipo: UILabel!
    
    
}
