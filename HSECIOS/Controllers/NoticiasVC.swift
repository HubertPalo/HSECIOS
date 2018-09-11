import UIKit

class NoticiasVC: UIViewController, UITabBarDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var botonTopIzq: UIBarButtonItem!
    @IBOutlet weak var botonTopDer: UIBarButtonItem!
    
    @IBOutlet weak var quitarFiltroView: UIView!
    @IBOutlet weak var ocurrenciasView: UIView!
    @IBOutlet weak var ocurrenciasText: UILabel!
    @IBOutlet weak var muroContainer: UIView!
    
    @IBOutlet weak var tabBar: UITabBar!
    
    var muro = MuroTVC()
    // var params = ["Elemperpage":"10", "Pagenumber": "1"]
    var shouldReload = false
    var externalCount = -1
    var externalCountText = -1
    var data: [String:String] = ["Elemperpage":"10", "Pagenumber": "1"]
    var isSearching = false
    var searchedText = false
    var textSearched = ""
    // var dataUsed: [String:String] = ["Elemperpage":"10", "Pagenumber": "1"]
    var muroDataTemp = [MuroElement]()
    var pagina = 1
    var elempp = 1
    /*override func viewDidAppear(_ animated: Bool) {
        if shouldReload {
            Rest.postDataGeneral(Routes.forMuroSearchN(), params, true, success: {(resultValue:Any?,data:Data?) in
                let arrayMuroElement: ArrayGeneral<MuroElement> = Dict.dataToArray(data!)
                self.muro.addMoreData(arrayMuroElement.Data)
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
    }*/
    
    func loadNoticias() {
        self.externalCount = -1
        Rest.postDataGeneral(Routes.forMuroSearchN(), self.data, true, success: {(resultValue:Any?,data:Data?) in
            let arrayMuroElement: ArrayGeneral<MuroElement> = Dict.dataToArray(data!)
            // self.muro.addMoreData(arrayMuroElement.Data)
            self.muro.data = arrayMuroElement.Data
            self.muroDataTemp = self.muro.data
            self.muro.tableView.reloadData()
            self.externalCount = arrayMuroElement.Count
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setTitleAndImage("Noticias", Images.minero)
        self.ocurrenciasView.isHidden = true
        self.muro = self.childViewControllers[0] as! MuroTVC
        self.muro.alScrollLimiteTop = {() in
            self.pagina = 1
            let cantidad = self.muro.data.count > self.elempp ? self.muro.data.count : self.elempp
            self.data["Elemperpage"] = "\(cantidad)"
            self.data["Pagenumber"] = "\(self.pagina)"
            Rest.postDataGeneral(Routes.forMuroSearchN(), self.data, true, success: {(resultValue:Any?,data:Data?) in
                let arrayMuroElement: ArrayGeneral<MuroElement> = Dict.dataToArray(data!)
                self.muroContainer.isHidden = arrayMuroElement.Count <= 0
                self.muro.data = arrayMuroElement.Data
                self.externalCount = self.searchedText ? self.externalCount : arrayMuroElement.Count
                self.externalCountText = !self.searchedText ? self.externalCountText : arrayMuroElement.Count
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
        self.muro.alScrollLimiteBot = {() in
            self.pagina = self.pagina + 1
            // let cantidad = 10
            print(self.externalCount)
            print(self.muro.data.count)
            print(self.externalCount)
            if (self.searchedText && self.externalCountText != -1 && self.muro.data.count >= self.externalCountText) || (!self.searchedText && self.externalCount != -1 && self.muro.data.count >= self.externalCount){
                return
            }
            
            self.data["Elemperpage"] = "\(self.elempp)"
            self.data["Pagenumber"] = "\(self.pagina)"
            Rest.postDataGeneral(Routes.forMuroSearchN(), self.data, true, success: {(resultValue:Any?,data:Data?) in
                let arrayMuroElement: ArrayGeneral<MuroElement> = Dict.dataToArray(data!)
                self.muro.data.append(contentsOf: arrayMuroElement.Data)
                self.muroContainer.isHidden = self.muro.data.count <= 0
                self.muro.tableView.reloadData()
                self.externalCount = self.searchedText ? self.externalCount : arrayMuroElement.Count
                self.externalCountText = !self.searchedText ? self.externalCountText : arrayMuroElement.Count
                
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
        self.tabBar.delegate = self
    }
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        let index = tabBar.items!.index(of: item)
        Utils.menuVC.showTabIndexAt(index!)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        self.textSearched = searchBar.text ?? ""
        self.searchedText = true
        self.pagina = 1
        self.data["Elemperpage"] = "\(self.elempp)"
        self.data["Pagenumber"] = "\(self.pagina)"
        self.data["Titulo"] = self.textSearched
        Rest.postDataGeneral(Routes.forMuroSearchN(), self.data, true, success: {(resultValue:Any?,data:Data?) in
            let arrayMuroElement: ArrayGeneral<MuroElement> = Dict.dataToArray(data!)
            self.muro.data = arrayMuroElement.Data
            self.ocurrenciasView.isHidden = false
            self.ocurrenciasText.text = "Total registros encontrados: \(arrayMuroElement.Count)"
            self.muroContainer.isHidden = self.muro.data.count <= 0
            self.muro.tableView.reloadData()
            self.externalCount = self.searchedText ? self.externalCount : arrayMuroElement.Count
            self.externalCountText = !self.searchedText ? self.externalCountText : arrayMuroElement.Count
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
    
    @IBAction func clickQuitarFiltro(_ sender: Any) {
        self.quitarFiltroView.isHidden = true
        self.data = ["Elemperpage":"10", "Pagenumber": "\(pagina)"]
        
        self.isSearching = false
        self.searchedText = false
        self.setTitleAndImage("Noticias", Images.minero)
        self.botonTopDer.image = UIImage.init(named: "search25x25")
        self.botonTopIzq.image = UIImage.init(named: "menu30x30")
        self.ocurrenciasView.isHidden = true
        self.muroContainer.isHidden = false
        self.muro.data = self.muroDataTemp
        self.muro.tableView.reloadData()
    }
    
    @IBAction func clickTopIzq(_ sender: Any) {
        if self.isSearching {
            self.isSearching = false
            self.searchedText = false
            self.setTitleAndImage("Noticias", Images.minero)
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
            VCHelper.openFiltroNoticia(self, {(data) in
                self.data = data
                self.quitarFiltroView.isHidden = false
                self.searchedText = false
                Rest.postDataGeneral(Routes.forMuroSearchN(), self.data, true, success: {(resultValue:Any?,data:Data?) in
                    let arrayMuroElement: ArrayGeneral<MuroElement> = Dict.dataToArray(data!)
                    self.muroContainer.isHidden = arrayMuroElement.Count <= 0
                    self.ocurrenciasView.isHidden = false
                    self.ocurrenciasText.text = "Total registros encontrados: \(arrayMuroElement.Count)"
                    self.muro.data = arrayMuroElement.Data
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
            })
        } else {
            self.isSearching = true
            self.setSearchBarTitle()
            self.botonTopDer.image = UIImage.init(named: "SearchFiltro")
            self.botonTopIzq.image = UIImage.init(named: "back")
        }
    }
    
}
