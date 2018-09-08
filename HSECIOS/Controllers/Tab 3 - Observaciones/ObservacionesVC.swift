import UIKit

class ObservacionesVC: UIViewController, UISearchBarDelegate {
    
    @IBOutlet weak var botonTopIzq: UIBarButtonItem!
    @IBOutlet weak var botonTopDer: UIBarButtonItem!
    
    @IBOutlet weak var ocurrenciasView: UIView!
    @IBOutlet weak var ocurrenciasText: UILabel!
    @IBOutlet weak var muroContainer: UIView!
    
    var muro = MuroTVC()
    var data: [String:String] = ["Lugar": "1", "CodUbicacion": "10"]
    var isSearching = false
    var searchedText = false
    var textSearched = ""
    var dataUsed: [String:String] = ["Lugar": "1", "CodUbicacion": "10"]
    var muroDataTemp = [MuroElement]()
    var pagina = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setTitleAndImage("Observaciones", Images.minero)
        self.ocurrenciasView.isHidden = true
        self.muro = self.childViewControllers[0] as! MuroTVC
        self.muro.alScrollLimiteTop = {
            self.pagina = 1
            let cantidad = self.muro.data.count > 10 ? self.muro.data.count : 10
            if self.searchedText {
                Rest.getDataGeneral(Routes.forMuroFiltro(self.textSearched, 2, self.pagina, 10), true, success: {(resultValue:Any?,data:Data?) in
                    let arrayMuroElement: ArrayGeneral<MuroElement> = Dict.dataToArray(data!)
                    self.muroContainer.isHidden = arrayMuroElement.Count <= 0
                    self.muro.data = arrayMuroElement.Data
                    self.muro.tableView.reloadData()
                    var contador = 0
                    for unit in arrayMuroElement.Data {
                        if (unit.UrlObs ?? "") != "" {
                            Images.downloadAvatar(unit.UrlObs!, {() in
                                self.muro.tableView.reloadData()
                            })
                        }
                        Images.downloadImage(unit.UrlPrew ?? "", {() in
                            contador = contador + 1
                            if contador == arrayMuroElement.Data.count {
                                self.muro.tableView.reloadData()
                            }
                        })
                    }
                }, error: nil)
            } else {
                self.data["Lugar"] = "1"
                self.data["CodUbicacion"] = "\(cantidad)"
                Rest.postDataGeneral(Routes.forMuroSearchO(), self.data, true, success: {(resultValue:Any?,data:Data?) in
                    let arrayMuroElement: ArrayGeneral<MuroElement> = Dict.dataToArray(data!)
                    self.muro.data = arrayMuroElement.Data
                    self.muroDataTemp = self.muro.data
                    self.muro.tableView.reloadData()
                    var contador = 0
                    for unit in arrayMuroElement.Data {
                        if (unit.UrlObs ?? "") != "" {
                            Images.downloadAvatar(unit.UrlObs!, {() in
                                self.muro.tableView.reloadData()
                            })
                        }
                        Images.downloadImage(unit.UrlPrew ?? "", {() in
                            contador = contador + 1
                            if contador == arrayMuroElement.Data.count {
                                self.muro.tableView.reloadData()
                            }
                        })
                    }
                }, error: nil)
            }
        }
        self.muro.alScrollLimiteBot = {
            self.pagina = self.pagina + 1
            if self.searchedText {
                Rest.getDataGeneral(Routes.forMuroFiltro(self.textSearched, 2, self.pagina, 10), true, success: {(resultValue:Any?,data:Data?) in
                    let arrayMuroElement: ArrayGeneral<MuroElement> = Dict.dataToArray(data!)
                    self.muro.data.append(contentsOf: arrayMuroElement.Data)
                    self.muroContainer.isHidden = self.muro.data.count == 0
                    self.muro.tableView.reloadData()
                    var contador = 0
                    for unit in arrayMuroElement.Data {
                        if (unit.UrlObs ?? "") != "" {
                            Images.downloadAvatar(unit.UrlObs!, {() in
                                self.muro.tableView.reloadData()
                            })
                        }
                        Images.downloadImage(unit.UrlPrew ?? "", {() in
                            contador = contador + 1
                            if contador == arrayMuroElement.Data.count {
                                self.muro.tableView.reloadData()
                            }
                        })
                    }
                }, error: nil)
            } else {
                self.dataUsed["Lugar"] = "\(self.pagina)"
                Rest.postDataGeneral(Routes.forMuroSearchO(), self.dataUsed, true, success: {(resultValue:Any?,data:Data?) in
                    let arrayMuroElement: ArrayGeneral<MuroElement> = Dict.dataToArray(data!)
                    self.muro.data.append(contentsOf: arrayMuroElement.Data)
                    self.muroDataTemp = self.muro.data
                    self.muro.tableView.reloadData()
                    var contador = 0
                    for unit in arrayMuroElement.Data {
                        if (unit.UrlObs ?? "") != "" {
                            Images.downloadAvatar(unit.UrlObs!, {() in
                                self.muro.tableView.reloadData()
                            })
                        }
                        Images.downloadImage(unit.UrlPrew ?? "", {() in
                            contador = contador + 1
                            if contador == arrayMuroElement.Data.count {
                                self.muro.tableView.reloadData()
                            }
                        })
                    }
                }, error: nil)
            }
        }
        Rest.postDataGeneral(Routes.forMuroSearchO(), self.data, true, success: {(resultValue:Any?,data:Data?) in
            let arrayMuroElement: ArrayGeneral<MuroElement> = Dict.dataToArray(data!)
            self.muroDataTemp = arrayMuroElement.Data
            self.muro.data = arrayMuroElement.Data
            self.muro.tableView.reloadData()
            var contador = 0
            for unit in arrayMuroElement.Data {
                if (unit.UrlObs ?? "") != "" {
                    Images.downloadAvatar(unit.UrlObs!, {() in
                        self.muro.tableView.reloadData()
                    })
                }
                Images.downloadImage(unit.UrlPrew ?? "", {() in
                    contador = contador + 1
                    if contador == arrayMuroElement.Data.count {
                        self.muro.tableView.reloadData()
                    }
                })
            }
        }, error: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        self.textSearched = searchBar.text ?? ""
        self.searchedText = true
        // self.pagina = 1
        Rest.getDataGeneral(Routes.forMuroFiltro(searchBar.text!, 2, 1, 10), true, success: {(resultValue:Any?,data:Data?) in
            let arrayMuroElement: ArrayGeneral<MuroElement> = Dict.dataToArray(data!)
            self.muroContainer.isHidden = arrayMuroElement.Count <= 0
            self.ocurrenciasView.isHidden = false
            self.ocurrenciasText.text = "Total registros encontrados: \(arrayMuroElement.Count)"
            self.muro.data = arrayMuroElement.Data
            self.muro.tableView.reloadData()
            var contador = 0
            for unit in arrayMuroElement.Data {
                if (unit.UrlObs ?? "") != "" {
                    Images.downloadAvatar(unit.UrlObs!, {() in
                        self.muro.tableView.reloadData()
                    })
                }
                Images.downloadImage(unit.UrlPrew ?? "", {() in
                    contador = contador + 1
                    if contador == arrayMuroElement.Data.count {
                        self.muro.tableView.reloadData()
                    }
                })
            }
        }, error: nil)
    }
    
    @IBAction func clickTopIzq(_ sender: Any) {
        if self.isSearching {
            self.isSearching = false
            self.searchedText = false
            self.setTitleAndImage("Observaciones", Images.observacion)
            self.botonTopDer.image = UIImage.init(named: "search25x25")
            self.botonTopIzq.image = UIImage.init(named: "menu30x30")
            self.ocurrenciasView.isHidden = true
            self.muroContainer.isHidden = false
            self.muro.data = self.muroDataTemp
            self.muro.tableView.reloadData()
        } else {
            Utils.openMenu()
        }
    }
    
    @IBAction func clickTopDer(_ sender: Any) {
        if self.isSearching {
            VCHelper.openFiltroObservacion(self, {(data) in
                self.dataUsed = data
                self.searchedText = false
                Rest.postDataGeneral(Routes.forMuroSearchO(), data, true, success: {(resultValue:Any?,data:Data?) in
                    print(resultValue)
                    let arrayMuroElement: ArrayGeneral<MuroElement> = Dict.dataToArray(data!)
                    self.muro.data = arrayMuroElement.Data
                    self.muro.tableView.reloadData()
                    // self.stackInf.isHidden = false
                    // self.viewContainer.isHidden = arrayMuroElement.Count <= 0
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
        } else {
            self.isSearching = true
            self.setSearchBarTitle()
            self.botonTopDer.image = UIImage.init(named: "SearchFiltro")
            self.botonTopIzq.image = UIImage.init(named: "back")
        }
    }
}
