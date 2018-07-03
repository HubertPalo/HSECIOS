import UIKit

class LoginVC : UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var username: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var checkSaveData: UIImageView!
    
    @IBOutlet weak var inputsStack: UIStackView!
    
    @IBOutlet weak var iconoPassword: UIImageView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    let iconosPassword = [UIImage(named: "eye"), UIImage(named: "eyelock")]
    
    override func viewWillAppear(_ animated: Bool) {
        Utils.progressIndicator = self.activityIndicator
        print("\(Config.loginUsername) - \(Config.loginPassword)")
        username.text = Config.loginUsername
        password.text = Config.loginPassword
        inputsStack.isHidden = Config.loginSaveFlag
        if Config.loginSaveFlag {
            checkSaveData.image = UIImage(named: "checked")
        } else {
            checkSaveData.image = UIImage(named: "unchecked")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.activityIndicator.isHidden = true
        Utils.progressIndicator = self.activityIndicator
        username.delegate = self
        password.delegate = self
        username.text = Config.loginUsername
        password.text = Config.loginPassword
        
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
        
        var rightButton  = UIButton(type: .custom)
        // rightButton.setImage(UIImage(named: "eye"), for: .normal)
        
        rightButton.frame = CGRect(x:2, y:2, width:26, height:26)
        rightButton.addTarget(self, action: #selector(self.changePasswordState), for: .touchUpInside)
        password.rightViewMode = .always
        password.rightView = rightButton
        
        if Config.loginSaveFlag {
            checkSaveData.image = UIImage(named: "checked")
            self.clickEnLogin(self)
        } else {
            checkSaveData.image = UIImage(named: "unchecked")
        }
    }
    
    /*func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }*/
    
    @objc func changePasswordState() {
        password.isSecureTextEntry = !password.isSecureTextEntry
        self.iconoPassword.tag = 1 - self.iconoPassword.tag
        self.iconoPassword.image = self.iconosPassword[self.iconoPassword.tag]
        if let existingText = password.text, password.isSecureTextEntry {
            password.deleteBackward()
            
            if let textRange = password.textRange(from: password.beginningOfDocument, to: password.endOfDocument) {
                password.text = existingText
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    /*func successLogin() {
        if Config.loginSaveFlag {
            Config.saveLogin(username.text!, password.text!)
        }
        HLogin.getUserInfo(vcontroller: self, success: successGettingUserData, error: errorLogin(_:))
    }*/
    
    func successGettingUserData() {
        //HConfig.updateGlobals()
        self.performSegue(withIdentifier: "oklogin", sender: self)
    }
    
    func errorLogin(_ error: String) {
        print(error)
        self.inputsStack.isHidden = false
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
        Rest.postDataGeneral(Routes.forLogin(), ["username":username.text!, "password":password.text!, "domain":"anyaccess"], true, success: {(resultValue:Any?,data:Data?) in
            let str = resultValue as! String
            Utils.token = str
            if Config.loginSaveFlag {
                Config.saveLogin(self.username.text!, self.password.text!)
            }
            Rest.getDataGeneral(Routes.forUserData(), true, success: {(resultValue:Any?,data:Data?) in
                Utils.userData = Dict.dataToUnit(data!)!
                Config.getAllMaestro()
                self.performSegue(withIdentifier: "oklogin", sender: self)
            }, error: {(error) in
                print("Error : \(error)")
                self.inputsStack.isHidden = false
            })
        }, error: {(error) in
            self.inputsStack.isHidden = false
            print(error)
        })
    }
    
    
    
}
