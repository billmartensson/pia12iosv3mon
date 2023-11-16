//
//  ChuckAPI.swift
//  pia12iosv3mon
//
//  Created by BillU on 2023-11-16.
//

import Foundation

class ChuckAPI : ObservableObject {
    
    /*
    var fakeresult = "tom från början"
    
    func fakeload() {
        DispatchQueue.main.async {
            self.fakeresult = "Banan"
        }
        
    }
    */
    
    
    
    
    @Published var isloading = false
    
    @Published var jokecategories = [String]()
    
    @Published var thejoke : Chucknorrisinfo?
    
    @Published var errormessage = ""
    
    func loadcategories() {
        Task {
            if ChuckHelper().isPreview {
                jokecategories = ["A", "B", "C"]
                return
            }
            
            let apiurl = URL(string: "https://api.chucknorris.io/jokes/categories")!
            
            DispatchQueue.main.async {
                self.isloading = true
            }
            do {
                let (data, _) = try await URLSession.shared.data(from: apiurl)
                
                let decoder = JSONDecoder()
                
                DispatchQueue.main.async {
                    if let categories = try? decoder.decode([String].self, from: data) {
                        
                        self.jokecategories = categories
                    }
                    self.isloading = false
                }
            } catch {
                print("Fel fel")
            }
        }
    }
    
    func loadapiForSearch(jokesearch : String) {
        Task {
            await loadapi(apiurlstring: "https://api.chucknorris.io/jokes/search?query="+jokesearch)

        }
    }
    
    func loadapiForCategory(jokecat : String) {
        Task {
            await loadapi(apiurlstring: "https://api.chucknorris.io/jokes/random?category="+jokecat)

        }
    }
    
    
    func loadapiRandom() {
        Task {
            await loadapi(apiurlstring: "https://api.chucknorris.io/jokes/random")

        }
    }
    
    func loadapi(apiurlstring : String) async {
        
        if ChuckHelper().isPreview {
            thejoke = Chucknorrisinfo(id: "aaa", created_at: "xxx", value: "Joke joke joke")
            return
        }
        
        DispatchQueue.main.async {
            self.errormessage = ""
        }
        
        let apiurl = URL(string: apiurlstring)!
        
        do {
            DispatchQueue.main.async {
                self.isloading = true
            }
            let (data, _) = try await URLSession.shared.data(from: apiurl)
                        
            let decoder = JSONDecoder()
            
            if let chuckthing = try? decoder.decode(Chucknorrisinfo.self, from: data) {
                
                DispatchQueue.main.async {
                    self.thejoke = chuckthing
                }
            }
            if let chuckthing = try? decoder.decode(ChucknorrisSearchresult.self, from: data) {
                
                if chuckthing.result.count > 0 {
                    DispatchQueue.main.async {
                        self.thejoke = chuckthing.result[0]
                    }
                } else {
                    DispatchQueue.main.async {
                        self.errormessage = "Nothing found!"
                    }
                }
            }
            DispatchQueue.main.async {
                self.isloading = false
            }
        } catch {
            print("Fel fel")
        }
    }
    
    
    func oldloadapi() async {
        print("load api stuff")
        
        let apiurl = URL(string: "https://api.chucknorris.io/jokes/random")!
        
        /*
        do {
            let apistring = try String(contentsOf: apiurl)
            print(apistring)
            joketext = apistring
        } catch {
            print("Nu blev det fel")
        }
         */
        
        do {
            let (data, _) = try await URLSession.shared.data(from: apiurl)
            
            print(data.count)
            
            let decoder = JSONDecoder()
            
            if let chuckthing = try? decoder.decode(Chucknorrisinfo.self, from: data) {
                
                print(chuckthing.value)
                
                //joketext = chuckthing.value
            }
            
            
            
        } catch {
            print("Fel fel")
        }
    }
    
}
