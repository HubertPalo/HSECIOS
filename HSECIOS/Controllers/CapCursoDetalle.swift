import UIKit

class CapCursoDetalle: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    @IBOutlet var tabCurso: UITableView!
    
    @IBOutlet weak var Item1: UIButton!
    
    @IBOutlet weak var Item_add: UIButton!
    var codCurso = ""
    var fecha = ""
    var duracion = 0
    let leftLabels: [String] = ["Código","Empresa","Tema","Tipo","Area HSEC","Lugar","Fecha inicio", "Fecha Fin", "Puntaje Total", "% de aprobación","Vigencia","Capacidad","Duración"]
    var rightLabels: [String] = ["-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-"]
    var splitExpositor = [String]()
    var section2ShouldShow = false
    var section3ShouldShow = false
    var section3Title = ""
    var dataFechaCod = [String]()
    var dataFechaDes = [String]()
    
    /*
     override func viewWillAppear(_ animated: Bool) {
     self.tabCurso.reloadData()
     }
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        Item_add.widthAnchor.constraint(equalToConstant: CGFloat(25)).isActive = true
        //Item1.widthAnchor.constraint(equalToConstant: CGFloat(25)).isActive = true
        
        loadData(self.codCurso)
        //UIButton().add
        self.tabCurso.reloadData()
        Utils.setTitleAndImage2(self,"Capacitación/Curso      ", UIImage(named: "cursos-1"))
        //Utils.setButtonImage(self.Item1, UIImage(named: "checkAsis")!)
        
        let imagen = Images.resize(UIImage(named: "checkAsis")!, 22, 22)
        let imagenAdd = Images.resize(UIImage(named: "notasCapa")!, 22, 22)
        
        let imagennueva = imagen.withRenderingMode(.alwaysTemplate)
        let imgAdd = imagenAdd.withRenderingMode(.alwaysTemplate)
        
        self.Item1.setImage(imagennueva, for: .normal)
        self.Item_add.setImage(imgAdd, for: .normal)
        /*
         let rightAddBarButtonItem:UIBarButtonItem = UIBarButtonItem(title: "Add", style: UIBarButtonItemStyle.plain, target: self, action: #selector(CapCursoDetalle.addTapped))
         // 3
         self.navigationItem.setRightBarButtonItems([rightAddBarButtonItem], animated: true)
         */
        
        Utils.capCursoDetalle = self
        self.tabCurso.delegate = self
        self.tabCurso.dataSource = self
        //print(self.codCurso)
        //loadData(self.codCurso)
    }
    
    /*@objc func addTapped (sender:UIButton) {
     print("add pressed")
     }*/
    override func viewDidAppear(_ animated: Bool) {
        //loadData(self.codCurso)
        
        self.tabCurso.reloadData()
    }
    func cleanData() {
        self.rightLabels = ["-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-", "-"]
        self.tabCurso.reloadData()
    }
    
    func loadData(_ codigo: String){
        
        let datos1 = codigo
        Rest.getDataGeneral(Routes.forCapCursoDetalle(datos1), true, success: {(resultValue:Any?,data:Data?) in
            let CursoDet: Curso = Dict.dataToUnit(data!)!
            self.fecha = CursoDet.Fecha!
            self.duracion = CursoDet.Duracion!
            self.rightLabels = [CursoDet.CodCurso ?? "", Utils.searchMaestroDescripcion("CEMP",CursoDet.Empresa ?? ""), Utils.searchMaestroDescripcion("CTEM", CursoDet.CodTema ?? ""), Utils.searchMaestroDescripcion("CTIP", CursoDet.Tipo ?? ""), Utils.searchMaestroDescripcion("AREA",CursoDet.Area ?? ""), Utils.searchMaestroDescripcion("CLUG", CursoDet.Lugar ?? ""),  Utils.fechaconHora(CursoDet.Fecha ?? ""), self.sumaFecha(CursoDet.Fecha ?? "",duracion: CursoDet.Duracion!),  CursoDet.PuntajeTotal ?? "", String(describing:"\(CursoDet.PuntajeP!)%"), self.vigencia(CursoDet.Vigencia ?? ""), CursoDet.Capacidad ?? "",Utils.Duracion_curso(String(describing: CursoDet.Duracion!))]
            //print (self.vigencia(CursoDet.Vigencia ?? ""))
            //print (self.rightLabels[1])
            self.splitExpositor = (CursoDet.Expositores ?? "").components(separatedBy: ";")
            self.tabCurso?.reloadData()
            
        }, error: nil)
        //return rightLabels
        //self.tabCurso.reloadData()
    }
    func sumaFecha(_ fecha: String, duracion: Int) -> String {
        let tempIn = Utils.str2date(fecha)
        let tempFin = tempIn?.addingTimeInterval(TimeInterval(60*duracion))
        return Utils.date2hora(tempFin)
    }
    func vigencia(_ vigencia: String) -> String {
        var dataV = ""
        var val = vigencia.split(separator: "-")
        if val[1] != "5" {
            dataV = "\(val[0]) "
        }
        dataV = "\(dataV)\(Utils.searchMaestroStatic("VIGENCIA", String(val[1])))"
        return dataV
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        //loadData(codCurso)
        return 2
    }
    //modificar acorde a la data
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 0 {
            return CGFloat.leastNonzeroMagnitude
        }
        return CGFloat(40)
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 0 {
            return nil
        }
        return tabCurso.dequeueReusableCell(withIdentifier: "celda2")!.contentView
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return self.leftLabels.count
        case 1:
            return self.splitExpositor.count
            /*case 2:
             return self.mejoras.count*/
        default:
            return 0
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let celda = tableView.dequeueReusableCell(withIdentifier: "celda1") as! Celda1Curso
            celda.texto1.text = self.leftLabels[indexPath.row]
            celda.texto2.text = self.rightLabels[indexPath.row]
            return celda
        }
        
        //let unit = self.splitExpositor[indexPath.row]
        let celda = tableView.dequeueReusableCell(withIdentifier: "celda3") as! Celda3Expositor
        
        let exp = (self.splitExpositor[indexPath.row] ).components(separatedBy: ":")
        if exp[0] != "" {
            celda.texto1.text = exp[0]
            celda.texto2.text = exp[1]
        }
        /*
         //if unit.Cargo == ""{celdaT.Cargo.text = " "} else { celdaT.Cargo.text = unit.Cargo}
         */
        
        //(CursoDet.Expositores ?? "").components(separatedBy: ";")
        
        return celda
        
    }
    
    @IBAction func verNota(_ sender: Any) {
        //self.performSegue(withIdentifier: "segn", sender: self)
        
        
    }
    
    @IBAction func verAsistencia(_ sender: Any) {
        //self.performSegue(withIdentifier: "sega", sender: self)
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.destination is NotasVC //|| segue.destination is AsistenciaVC
        {
            let vc = segue.destination as? NotasVC
            //vc?.loadData(datainfo)
            vc?.codCurso = codCurso
            
        } else if segue.destination is AsistenciaVC
        {
            // armar el array
            armarObjeto ()
            let vc = segue.destination as? AsistenciaVC
            //vc?.loadData(datainfo)
            vc?.codCurso = codCurso
            vc?.indiceF = String (fecha.prefix(10))
            vc?.dataFechaCod = dataFechaCod
            vc?.dataFechaDes = dataFechaDes
        }
    }
    
    
    
    func armarObjeto () /*-> [Maestro]*/ {
        //dataCombox(fecha)  render
        print(fecha)
        let startDate = Utils.str2date(fecha)
        //var t = startDate.
        //var endDate = nil
        dataFechaCod = [String]()
        dataFechaDes = [String]()
        let endDate = startDate?.addingTimeInterval(TimeInterval(60*duracion))
        var currentDate = startDate;
        // .orderedDescending
        var count = 0
        while (currentDate! <= endDate! || Utils.date2str(currentDate) == Utils.date2str(endDate)) {
            count = count+1
            let dato = String(describing: currentDate!)
            print(dato)
            
            dataFechaCod.append(String (dato.prefix(10)))
            dataFechaDes.append(Utils.dateShort(currentDate!))
            //"EEE d MMM"
            
            //var dataFechaCod = [String]()
            //var dataFechaDes = [String]()
            currentDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate!)
            
        }
        print(count)
        
    }
    
    @IBAction func close(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
}


class Celda1Curso: UITableViewCell {
    @IBOutlet weak var texto1: UILabel!
    @IBOutlet weak var texto2: UILabel!
    
    
}

class Celda2Sub: UITableViewCell {
    @IBOutlet weak var subs: UILabel!
}

class Celda3Expositor: UITableViewCell {
    @IBOutlet weak var texto1: UILabel!
    @IBOutlet weak var texto2: UILabel!
}
