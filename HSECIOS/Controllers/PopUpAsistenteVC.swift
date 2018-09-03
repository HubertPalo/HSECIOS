import UIKit

class PopUpAsistenteVC: UIViewController, UITextFieldDelegate{
    
    @IBOutlet weak var titulo: UILabel!
    
    @IBOutlet weak var iconTitulo: UIImageView!
    
    @IBOutlet weak var avatar: UIImageView!
    
    @IBOutlet weak var nombre: UILabel!
    
    @IBOutlet weak var cargo: UILabel!
    
    @IBOutlet weak var Coduser: UILabel!
    
    @IBOutlet weak var barTitulo: UIView!
    
    var dataPersona = Persona()
    var tituloPop = ""
    var tiempo: Double?
    var re: Float?
    var gr: Float?
    var bl: Float?
    var tipoIcon = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        
    }
    
    func loadData(){
        Images.loadAvatarFromDNI(dataPersona.NroDocumento ?? "", avatar, false)
        self.nombre.text = dataPersona.Nombres
        self.cargo.text = dataPersona.Cargo
        self.Coduser.text = dataPersona.CodPersona
        self.titulo.text = tituloPop
        self.barTitulo.backgroundColor = UIColor.init(red: CGFloat(re!/256), green: CGFloat(gr!/256), blue: CGFloat(bl!/256), alpha: 1)
        
        if tipoIcon == "Alert"{
            let yourImage: UIImage = UIImage(named: "alertaAmarilla")!
            self.iconTitulo.image = yourImage

        }else if tipoIcon == "check" {
            let yourImage: UIImage = UIImage(named: "whiteDoneCheck")!
            self.iconTitulo.image = yourImage

        }
        
        if let duration: Double = tiempo {
            let when = DispatchTime.now() + duration
            DispatchQueue.main.asyncAfter(deadline: when){
                //alert.dismiss(animated: true, completion: nil)
            self.navigationController?.popViewController(animated: true)
                self.dismiss(animated: true, completion: nil)
            }
        }
        
    }
    
}
