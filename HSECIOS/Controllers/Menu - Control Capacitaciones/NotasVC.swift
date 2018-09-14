import UIKit

class NotasVC: UIViewController, UITabBarDelegate, UITableViewDelegate, UITableViewDataSource{
    var cursoNotas: [Persona] = []
    
    var codCurso = ""
    @IBOutlet weak var tabNotas: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        Utils.setTitleAndImage(self,"Capacitación/Curso/Notas", UIImage(named: "cursos-1"))
        
        loadDatanoticia(self.codCurso,"")
        //loadData("006849")
        //loadData("005360", "")
        Utils.notasVC = self
        self.tabNotas.delegate=self
        self.tabNotas.dataSource=self
        print("\(codCurso) - notas")
    }
    
    func loadDatanoticia(_ codigo: String,_ verpopup: String)
    {
        
        Rest.getDataGeneral(Routes.forCapCursoNotas(codigo, 1, 14), true, success: {(resultValue:Any?,data:Data?) in
            let Notas: ArrayGeneral<Persona> = Dict.dataToArray(data!)
            
            if Notas.Data.count > 0 {
                self.cursoNotas = Notas.Data
                print(self.cursoNotas[0].Estado)
                self.tabNotas.reloadData()  //habilitar despues
            }
            
            if verpopup == "-1"{
                self.presentAlert(nil, "Ocurrio un error", .actionSheet, 2, nil, [], [], actionHandlers: [])
            } else if verpopup == "1" {
                self.presentAlert(nil, "Operación exitosa", .actionSheet, 2, nil, [], [], actionHandlers: [])
            }
            
        }, error: nil)
        
        
        
    }
    /*
     func mostrarPopup(_ verpopup: String){
     
     }
     */
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return cursoNotas.count
    }
    var indexSeleccionadas: [Bool] = []
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celdaT = tableView.dequeueReusableCell(withIdentifier: "celdanota") as! UserNotaVCell
        let unit = cursoNotas[indexPath.row]
        celdaT.Nombre.text = unit.Nombres
        if unit.Cargo == ""{celdaT.Cargo.text = " "} else { celdaT.Cargo.text = unit.Cargo}
        
        celdaT.NotaCurso.text = unit.Email
        celdaT.NotaCurso.layer.borderColor = UIColor.gray.cgColor
        celdaT.NotaCurso.layer.borderWidth = 0.5
        celdaT.NotaCurso.layer.cornerRadius = 5
        
        
        celdaT.backgroundColor = cursoNotas[indexPath.row].Estado == "E" ? UIColor.init(red: 202.0/255.0, green: 207.0/255.0, blue: 210.0/255.0, alpha: 1.0) : UIColor.clear
        
        
        
        //let endIndex = name.index(name.endIndex, offsetBy: -2)
        
        
        
        return celdaT
    }
    
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let currentOffset = scrollView.contentOffset.y
        if currentOffset <= -14 {
            //self.alScrollLimiteTop?()
            let cantidad = self.cursoNotas.count > 14 ? self.cursoNotas.count : 14
            Rest.getDataGeneral(Routes.forCapCursoNotas(self.codCurso, 1, 14), true, success: {(resultValue:Any?,data:Data?) in
                
                let Notas: ArrayGeneral<Persona> = Dict.dataToArray(data!)
                //self.TablaCap.isHidden = cursos.Data.count <= 0
                if Notas.Data.count > 0 {
                    self.cursoNotas = Notas.Data
                    self.tabNotas.reloadData()
                }
            }, error: nil)
        } else {
            let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
            if maximumOffset - currentOffset <= -14 {
                //self.alScrollLimiteBot?()
                var pagina = self.cursoNotas.count / 14
                if self.cursoNotas.count % 14 == 0 {
                    pagina = pagina + 1
                }
                Rest.getDataGeneral(Routes.forCapCursoNotas(self.codCurso, pagina, 14), true, success: {(resultValue:Any?,data:Data?) in
                    // let planes = Dict.toArrayPlanAccionPendiente(dict)
                    let Notas: ArrayGeneral<Persona> = Dict.dataToArray(data!)
                    
                    //self.TablaCap.isHidden = cursos.Data.count <= 0
                    self.addMoreData(array: Notas.Data)
                }, error: nil)
            }
        }
    }
    
    func addMoreData(array:[Persona]) {
        // var nuevaData: [PlanAccionPendiente] = []
        var codigos: [String] = []
        for i in 0..<self.cursoNotas.count {
            codigos.append(self.cursoNotas[i].CodPersona!)
        }
        for i in 0..<array.count {
            if !codigos.contains(array[i].CodPersona!) {
                self.cursoNotas.append(array[i])
            }
        }
        self.tabNotas.reloadData()
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        if cursoNotas[indexPath.row].Estado == "A"{
            let popup = Utils.capacitacionSB.instantiateViewController(withIdentifier: "NotaEditPopup") as! NotaEditPopupVC
            popup.modalPresentationStyle = .overCurrentContext
            //popup.dataPersona = cursoNotas[indexPath.row]
            popup.cursoNotas = cursoNotas
            popup.position = indexPath.row
            popup.codCurso = codCurso
            self.present(popup, animated: true, completion: nil)
        } else {
            self.presentAlert(nil, "Participante no tiene asistencia al curso", .actionSheet, 2, nil, [], [], actionHandlers: [])
        }
        
    }
    
    
    @IBAction func backBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    
    
    
}
class UserNotaVCell: UITableViewCell {
    
    @IBOutlet weak var NotaCurso: UILabel!
    
    @IBOutlet weak var Nombre: UILabel!
    
    @IBOutlet weak var Cargo: UILabel!
    
    @IBOutlet weak var bordeNota: UIView!
}

