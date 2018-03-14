import UIKit

class LoginVC : UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var username: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var checkSaveData: UIImageView!
    
    override func viewDidAppear(_ animated: Bool) {
        username.text = Config.loginUsername
        password.text = Config.loginPassword
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(self.storyboard == UIStoryboard.init(name: "Main", bundle: nil))
        if Config.loginSaveFlag {
            checkSaveData.image = UIImage(named: "checked")
        } else {
            checkSaveData.image = UIImage(named: "unchecked")
        }
        username.delegate = self
        password.delegate = self
        
        // Añadir iconos a la izquierda de los inputText
        let userImagenView = UIImageView(image: Images.user)
        userImagenView.contentMode = .scaleAspectFit
        userImagenView.frame = CGRect.init(x: 0, y: 0, width: 30, height: 20)
        let lockImagenView = UIImageView(image: Images.lock)
        lockImagenView.contentMode = .scaleAspectFit
        lockImagenView.frame = CGRect.init(x: 0, y: 0, width: 30, height: 20)
        username.leftView = userImagenView
        username.leftViewMode = .always
        password.leftView = lockImagenView
        password.leftViewMode = .always
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func successLogin() {
        if Config.loginSaveFlag {
            Config.saveLogin(username.text!, password.text!)
        }
        HLogin.getUserInfo(vcontroller: self, success: successGettingUserData, error: errorLogin(_:))
    }
    
    func successGettingUserData() {
        HConfig.updateGlobals()
        self.performSegue(withIdentifier: "oklogin", sender: self)
    }
    
    func errorLogin(_ error: String) {
        print(error)
    }
    
    @IBAction func clickEnRecuerdame(_ sender: Any) {
        
        Config.loginSaveFlag = !Config.loginSaveFlag
        Config.save("configLoginSaveFlag")
        if Config.loginSaveFlag {
            Config.saveLogin(username.text!, password.text!)
            checkSaveData.image = Images.checked
        } else {
            checkSaveData.image = Images.unchecked
        }
    }
    
    @IBAction func clickEnLogin(_ sender: Any) {
        Helper.getData(Routes.forLogin(username.text!, password.text!), true, vcontroller: self, success: {(str:String) in
            Utils.token = str
            if Config.loginSaveFlag {
                Config.saveLogin(self.username.text!, self.password.text!)
            }
            Helper.getData(Routes.forUserData(), true, vcontroller: self, success: {(dict: NSDictionary) in
                Dict.extractUserData(dict)
                HConfig.updateGlobals()
                self.performSegue(withIdentifier: "oklogin", sender: self)
            })
            //HLogin.getUserInfo(vcontroller: self, success: successGettingUserData, error: errorLogin(_:))
        })
        HLogin.login(username.text!, password.text!, vcontroller: self, success: successLogin, error: errorLogin(_:))
    }
    
    
    
}
