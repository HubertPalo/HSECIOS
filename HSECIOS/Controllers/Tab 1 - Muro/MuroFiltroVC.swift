import UIKit

/*class MuroFiltroVC: UIViewController, UISearchBarDelegate {
    
    @IBOutlet weak var boton: UIButton!
    @IBOutlet weak var stackInf: UIStackView!
    @IBOutlet weak var totalRegistros: UILabel!
    @IBOutlet weak var viewContainer: UIView!
    
    var tipo = "MURO"
    var data: [String:String] = [:]
    
    var muro = MuroTVC()
    var pagina = 1
    let elemspp = 10
    var opcion = 0
    
    let searchBar = UISearchBar()
    let imageview = UIImageView.init()
    var shouldReset = false
    
    let opciones = [UIImage(named: "alloptions")!, UIImage(named: "facilito")!, UIImage(named: "observacion")!, UIImage(named: "inspeccion")!, UIImage(named: "noticia")]
    
    override func viewWillAppear(_ animated: Bool) {
        // searchBar.becomeFirstResponder()
        if self.shouldReset {
            self.searchBar.text = ""
            self.stackInf.isHidden = true
            self.viewContainer.isHidden = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.opcion = 0
        self.imageview.image = self.opciones[0]
        self.setSearchBarTitle()
        // searchBar.delegate = self
        // searchBar.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        print("despues - \(self.searchBar.frame)")
        self.muro = self.childViewControllers[0] as! MuroTVC
        self.muro.alScrollLimiteTop = {
            Rest.getDataGeneral(Routes.forMuro(1, 10), true, success: {(resultValue:Any?,data:Data?) in
                let arrayMuroElement: ArrayGeneral<MuroElement> = Dict.dataToArray(data!)
                self.muro.addMoreData(arrayMuroElement.Data)
            }, error: nil)
            /*Rest.getData(Routes.forMuro(1, 10), true, vcontroller: self, success: {(dict:NSDictionary) in
                self.muro.addMoreData(Dict.toArrayMuroElement(dict))
            })*/
        }
        self.muro.alScrollLimiteBot = {
            self.pagina = self.pagina + 1
            Rest.getDataGeneral(Routes.forMuro(1, 10), true, success: {(resultValue:Any?,data:Data?) in
                let arrayMuroElement: ArrayGeneral<MuroElement> = Dict.dataToArray(data!)
                self.muro.addMoreData(arrayMuroElement.Data)
            }, error: nil)
            /*Rest.getData(Routes.forMuro(1, 10), true, vcontroller: self, success: {(dict:NSDictionary) in
                self.muro.addMoreData(Dict.toArrayMuroElement(dict))
            })*/
        }
        /*self.muro.alClickCelda = { (unit:MuroElement) in
            if (unit.Codigo ?? "").starts(with: "OBS") {
                Tabs.indexObsDetalle = 1
                VCHelper.openObsDetalle(self, unit.Codigo!, unit.Tipo!, false)
            } else if (unit.Codigo ?? "").starts(with: "INS") {
                Tabs.indexInsDetalle = 1
                VCHelper.openInsDetalle(self, unit)
            } else if (unit.Codigo ?? "").starts(with: "NOT") {
                VCHelper.openNotDetalle(self, unit)
            } else if (unit.Codigo ?? "").starts(with: "OBF") {
                self.presentAlert("OBF", "Falta implementar", .alert, 2, nil, [], [], actionHandlers: [])
                // Alerts.presentError(type: "Falta implementar :v", viewController: self)
            }
        }*/
        
        
        // self.navigationItem.titleView = searchBar
        self.imageview.frame = CGRect.init(x: 10, y: 2, width: 26, height: 26)
        self.imageview.tintColor = UIColor.white
        self.boton.addSubview(self.imageview)
        self.boton.frame = CGRect.init(x: 0, y: 0, width: 45, height: 30)
        self.stackInf.isHidden = true
    }
    
    func loadTipo(_ tipo: String) {
        self.tipo = tipo
        switch tipo {
        case "MURO":
            self.opcion = 0
        case "NOT":
            self.opcion = 0
        default:
            break
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.searchBar.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
        switch self.tipo {
        case "MURO":
            Rest.getDataGeneral(Routes.forMuroFiltro(searchBar.text!, self.opcion, self.pagina, self.elemspp), true, success: {(resultValue:Any?,data:Data?) in
                let moreData: ArrayGeneral<MuroElement> = Dict.dataToArray(data!)
                self.stackInf.isHidden = false
                if moreData.Count > 0 {
                    self.totalRegistros.text = "Total registros encontrados: \(moreData.Count)"
                    // self.viewVacio.isHidden = true
                    self.viewContainer.isHidden = false
                    self.muro.addMoreData(moreData.Data)
                } else {
                    self.totalRegistros.text = "No se encontraron registros"
//                     self.viewVacio.isHidden = false
                    self.viewContainer.isHidden = true
                }
            }, error: nil)
        case "INS":
            Rest.getDataGeneral(Routes.forMuroFiltro(searchBar.text!, self.opcion, self.pagina, self.elemspp), true, success: {(resultValue:Any?,data:Data?) in
                let moreData: ArrayGeneral<MuroElement> = Dict.dataToArray(data!)
                self.stackInf.isHidden = false
                if moreData.Count > 0 {
                    self.totalRegistros.text = "Total registros encontrados: \(moreData.Count)"
                    // self.viewVacio.isHidden = true
                    self.viewContainer.isHidden = false
                    self.muro.addMoreData(moreData.Data)
                } else {
                    self.totalRegistros.text = "No se encontraron registros"
                    // self.viewVacio.isHidden = false
                    self.viewContainer.isHidden = true
                }
            }, error: nil)
        case "OBS":
            // Verificar
            Rest.getDataGeneral(Routes.forMuroFiltro(searchBar.text!, self.opcion, self.pagina, self.elemspp), true, success: {(resultValue:Any?,data:Data?) in
                let moreData: ArrayGeneral<MuroElement> = Dict.dataToArray(data!)
                self.stackInf.isHidden = false
                if moreData.Count > 0 {
                    self.totalRegistros.text = "Total registros encontrados: \(moreData.Count)"
                    // self.viewVacio.isHidden = true
                    self.viewContainer.isHidden = false
                    self.muro.addMoreData(moreData.Data)
                } else {
                    self.totalRegistros.text = "No se encontraron registros"
                    // self.viewVacio.isHidden = false
                    self.viewContainer.isHidden = true
                }
            }, error: nil)
        case "OBF":
            break
        default:
            break
        }
    }
    
    func aplicarFiltro(_ inicial: Bool) {
        if inicial {
            self.pagina = 1
        } else {
            self.pagina = self.pagina + (self.pagina % self.elemspp == 0 ? 1 : 0)
        }
        Rest.getDataGeneral(Routes.forMuroFiltro(self.searchBar.text!, self.opcion, self.pagina, self.elemspp), true, success: {(resultValue:Any?,data:Data?) in
            // let moreData: ArrayGeneral<MuroElement> = Dict.toArrayMuroElement(dict)
            let moreData: ArrayGeneral<MuroElement> = Dict.dataToArray(data!)
            
            self.stackInf.isHidden = false
            if moreData.Count > 0 {
                self.totalRegistros.text = "Total registros encontrados: \(moreData.Count)"
                // self.viewVacio.isHidden = true
                self.viewContainer.isHidden = false
                if inicial {
                    self.muro.data = moreData.Data
                    self.muro.tableView.reloadData()
                } else {
                    self.muro.addMoreData(moreData.Data)
                }
            } else {
                self.totalRegistros.text = "No se encontraron registros"
                // self.viewVacio.isHidden = false
                self.viewContainer.isHidden = true
            }
        }, error: nil)
    }
    
    
    @IBAction func clickBoton(_ sender: Any) {
        self.searchBar.endEditing(true)
        switch self.tipo {
        case "MURO":
            let popup = Utils.mainSB.instantiateViewController(withIdentifier: "muroFiltroPopUp") as! MuroFiltroPopUp
            popup.modalPresentationStyle = .overCurrentContext
            popup.alClickOpcion = {(opcion:Int) in
                self.imageview.image = self.opciones[opcion]
                self.opcion = opcion
                if self.searchBar.text != nil {
                   self.aplicarFiltro(true)
                }
            }
            self.present(popup, animated: true, completion: nil)
        case "OBS":
            VCHelper.openFiltroObservacion(self, {(data) in
                Rest.postDataGeneral(Routes.forMuroSearchO(), data, true, success: {(resultValue:Any?,data:Data?) in
                    print(resultValue)
                    let arrayMuroElement: ArrayGeneral<MuroElement> = Dict.dataToArray(data!)
                    self.muro.data = arrayMuroElement.Data
                    self.muro.tableView.reloadData()
                    self.stackInf.isHidden = false
                    self.viewContainer.isHidden = arrayMuroElement.Count <= 0
                    var contador = 0
                    for unit in arrayMuroElement.Data {
                        Images.downloadAvatar(unit.UrlObs ?? "", {() in
                            contador = contador + 1
                            if contador == arrayMuroElement.Data.count * 2 {
                                self.muro.tableView.reloadData()
                            }
                        })
                        Images.downloadImage(unit.UrlPrew ?? "", {() in
                            contador = contador + 1
                            if contador == arrayMuroElement.Data.count * 2 {
                                self.muro.tableView.reloadData()
                            }
                        })
                    }
                }, error: {(error) in
                    print(error)
                })
            })
        case "INS":
            VCHelper.openFiltroInspeccion(self, {(data) in
                print(data)
            })
        case "NOT":
            VCHelper.openFiltroNoticia(self, {(data) in
                print(data)
            })
        case "OBF":
            VCHelper.openFiltroInspeccion(self, {(data) in
                print(data)
            })
        default:
            break
        }
    }
}*/
