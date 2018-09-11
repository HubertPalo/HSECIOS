import UIKit

class MuroVC: UIViewController, UISearchBarDelegate {
    
    @IBOutlet weak var botonTopIzq: UIBarButtonItem!
    @IBOutlet weak var botonTopDer: UIBarButtonItem!
    @IBOutlet weak var ocurrenciasView: UIView!
    @IBOutlet weak var ocurrenciasText: UILabel!
    @IBOutlet weak var muroContainer: UIView!
    @IBOutlet weak var opcionesFiltroView: UIView!
    @IBOutlet weak var agregarFOIView: UIView!
    
    var observaciones: [MuroElement] = []
    var muro = MuroTVC()
    var isSearching = false
    var searchedText = false
    var textSearched = ""
    var muroDataTemp = [MuroElement]()
    var pagina = 1
    var opcionFiltro = 0
    var opcionFiltroUsada = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setTitleAndImage("HSEC", Images.minero)
        self.ocurrenciasView.isHidden = true
        self.opcionesFiltroView.isHidden = true
        self.muro = self.childViewControllers[0] as! MuroTVC
        self.muro.alScrollLimiteTop = {
            self.pagina = 1
            let cantidad = self.muro.data.count > 10 ? self.muro.data.count : 10
            if self.searchedText {
                Rest.getDataGeneral(Routes.forMuroFiltro(self.textSearched, self.opcionFiltroUsada, self.pagina, 10), true, success: {(resultValue:Any?,data:Data?) in
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
                Rest.getDataGeneral(Routes.forMuro(self.pagina, cantidad), true, success: {(resultValue:Any?,data:Data?) in
                    let arrayMuroElement: ArrayGeneral<MuroElement> = Dict.dataToArray(data!)
                    self.muro.data = arrayMuroElement.Data
                    self.muroDataTemp = self.muro.data
                    self.muro.tableView.reloadData()
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
                }, error: nil)
                /*Rest.postDataGeneral(Routes.forMuroSearchO(), self.data, true, success: {(resultValue:Any?,data:Data?) in
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
                }, error: nil)*/
            }
        }
        self.muro.forzarActualizacion = {
            self.muro.alScrollLimiteTop?()
        }
        self.muro.alScrollLimiteBot = {
            self.pagina = self.pagina + 1
            if self.searchedText {
                Rest.getDataGeneral(Routes.forMuroFiltro(self.textSearched, self.opcionFiltroUsada, self.pagina, 10), true, success: {(resultValue:Any?,data:Data?) in
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
                Rest.getDataGeneral(Routes.forMuro(self.pagina, 10), true, success: {(resultValue:Any?,data:Data?) in
                    let arrayMuroElement: ArrayGeneral<MuroElement> = Dict.dataToArray(data!)
                    self.muro.data.append(contentsOf: arrayMuroElement.Data)
                    self.muroDataTemp = self.muro.data
                    self.muro.tableView.reloadData()
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
                    }, error: nil)
            }
            
            

        }
        Rest.getDataGeneral(Routes.forMuro(1,10), true, success: {(resultValue:Any?,data:Data?) in
            let arrayMuroElement: ArrayGeneral<MuroElement> = Dict.dataToArray(data!)
            self.muro.data = arrayMuroElement.Data
            self.muroDataTemp = self.muro.data
            self.muro.tableView.reloadData()
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
        Rest.getDataGeneral(Routes.forMuroFiltro(self.textSearched, self.opcionFiltroUsada, self.pagina, 10), true, success: {(resultValue:Any?,data:Data?) in
            let arrayMuroElement: ArrayGeneral<MuroElement> = Dict.dataToArray(data!)
            self.muroContainer.isHidden = arrayMuroElement.Count <= 0
            self.ocurrenciasView.isHidden = false
            self.agregarFOIView.isHidden = true
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
            self.setTitleAndImage("HSEC", Images.minero)
            self.botonTopDer.image = UIImage.init(named: "search25x25")
            self.botonTopIzq.image = UIImage.init(named: "menu30x30")
            self.ocurrenciasView.isHidden = true
            self.muroContainer.isHidden = false
            self.agregarFOIView.isHidden = false
            self.muro.data = self.muroDataTemp
            self.muro.tableView.reloadData()
        } else {
            Utils.openMenu()
        }
    }
    
    @IBAction func clickTopDer(_ sender: Any) {
        if self.isSearching {
            self.opcionesFiltroView.isHidden = !self.opcionesFiltroView.isHidden
            self.muroContainer.isHidden = !self.muroContainer.isHidden
            
            /*VCHelper.openFiltroObservacion(self, {(data) in
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
            })*/
        } else {
            // self.opcionesFiltroView.isHidden = true
            // self.muroContainer.isHidden = true
            // self.agregarFOIView.isHidden = true
            
            self.isSearching = true
            self.setSearchBarTitle()
            self.opcionFiltroUsada = 0
            self.opcionFiltro = 0
            self.botonTopDer.image = UIImage.init(named: "alloptions25x25")?.withRenderingMode(.alwaysOriginal)
            self.botonTopIzq.image = UIImage.init(named: "back")
        }
    }
    
    @IBAction func clickOpcion(_ sender: Any) {
        let boton = sender as! UIButton
        self.opcionFiltro = boton.tag
        self.opcionFiltroUsada = self.searchedText ? self.opcionFiltroUsada : self.opcionFiltro
        self.opcionesFiltroView.isHidden = true
        self.muroContainer.isHidden = false
        let imagenes = [UIImage(named: "alloptions25x25")!.withRenderingMode(.alwaysOriginal), UIImage(named: "facilito25x25")!.withRenderingMode(.alwaysOriginal), UIImage(named: "observacion25x25")!.withRenderingMode(.alwaysOriginal), UIImage(named: "inspeccion25x25")!.withRenderingMode(.alwaysOriginal), UIImage(named: "noticia25x25")!.withRenderingMode(.alwaysOriginal)]
        self.botonTopDer.image = imagenes[boton.tag]
        if searchedText {
            self.opcionFiltroUsada = self.opcionFiltro
            self.pagina = 1
            Rest.getDataGeneral(Routes.forMuroFiltro(self.textSearched, self.opcionFiltroUsada, self.pagina, 10), true, success: {(resultValue:Any?,data:Data?) in
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
    }
    
    
    @IBAction func clickAddFacilito(_ sender: Any) {
        VCHelper.openUpsertFacilito(self, "ADD", "", nil)
    }
    
    @IBAction func clickAddObservacion(_ sender: Any) {
        VCHelper.upsertObservacion(self, "ADD", "")
    }
    
    @IBAction func clickAddInspeccion(_ sender: Any) {
        VCHelper.upsertInspeccion(self, "ADD", "", nil)
    }
}
