import UIKit

class FiltroNoticiaVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var campoCodigo: UITextField!
    @IBOutlet weak var campoTitulo: UITextField!
    @IBOutlet weak var campoAutor: UILabel!
    @IBOutlet weak var campoFechaInicio: UIButton!
    @IBOutlet weak var campoFechaFin: UIButton!
    
    var data: [String:String] = ["Elemperpage":"10", "Pagenumber": "1"]
    var alClickOK: ((_ data: [String:String]) -> Void)?
    var fechaInicio: Date?
    
    override func viewWillAppear(_ animated: Bool) {
        print("view will appear..")
        self.fechaInicio = nil
        self.campoCodigo.text = self.data["CodNoticia"]
        self.campoTitulo.text = self.data["Titulo"]
        self.campoAutor.text = self.data["Autor"]
        self.campoFechaInicio.setTitle("SELECCIONE FECHA", for: .normal)
        self.campoFechaFin.setTitle("SELECCIONE FECHA", for: .normal)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.campoCodigo.delegate = self
        self.campoTitulo.delegate = self
        self.campoCodigo.tag = 0
        self.campoTitulo.tag = 1
        self.campoFechaInicio.tag = 0
        self.campoFechaFin.tag = 1
    }
    
    func cleanData() {
        self.data = ["Elemperpage":"10", "Pagenumber": "1"]
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let campo = textField.tag == 1 ? "Titulo" : "CodNoticia"
        data[campo] = textField.text
        print(self.data)
    }
    
    @IBAction func clickEscogerAutor(_ sender: Any) {
        VCHelper.openFiltroPersona(self, {(persona:Persona) in
            self.campoAutor.text = persona.Nombres
            self.data["Autor"] = persona.CodPersona
        })
    }
    
    @IBAction func clickEscogerFecha(_ sender: Any) {
        let boton = sender as! UIButton
        let title = boton.tag == 0 ? "Fecha inicio" : "Fecha fin"
        Utils.openDatePicker(title, Date(), fechaInicio, Date(), chandler: {(date) in
            boton.setTitle(Utils.date2str(date, "dd 'de' MMM").uppercased(), for: .normal)
            if boton.tag == 0 {
                self.data["Fecha"] = Utils.date2str(date, "YYYY-MM-dd")
                self.fechaInicio = date
            } else {
                self.data["Fecha2"] = Utils.date2str(date, "YYYY-MM-dd")
            }
            print(self.data)
        })
    }
    
    
    @IBAction func clickOk(_ sender: Any) {
        self.alClickOK?(self.data)
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
}
