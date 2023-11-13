//
//  ContentView.swift
//  pia12iosv3mon
//
//  Created by BillU on 2023-11-13.
//

import SwiftUI


struct ContentView: View {
    
    @State var thejoke : Chucknorrisinfo?
    
    @State var jokecategories = [String]()
    
    @State var searchtext = ""
    
    @State var errormessage = ""
    
    @State var isloading = false
    
    var isPreview: Bool {
        return ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
    }
    
    var body: some View {
        
        ZStack {
            VStack {
                
                VStack {
                    if thejoke != nil {
                        Text(thejoke!.created_at)
                        Text(thejoke!.value)
                    }
                }
                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                .frame(height: 200.0)
                .background(Color.gray)

                if errormessage != "" {
                    VStack {
                        Text(errormessage)
                            .foregroundColor(Color.white)
                    }
                    .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                    .frame(height: 100.0)
                    .background(Color.red)

                }

                
                HStack {
                    TextField("Search joke...", text: $searchtext)
                    
                    Button(action: {
                        loadapiForSearch(jokesearch: searchtext)
                    }, label: {
                        Text("Search")
                    })
                }
                
                Button(action: {
                    loadapiRandom()
                }, label: {
                    Text("Random joke")
                })
                
                List {
                    ForEach(jokecategories, id: \.self) { cat in
                        /*
                        Button(action: {
                            loadapiForCategory(jokecat: cat)
                        }, label: {
                            Text(cat)
                        })
                        */
                        
                        VStack {
                            Text(cat)
                        }
                        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                        .frame(height: 80)
                        .onTapGesture {
                            loadapiForCategory(jokecat: cat)
                        }
                        
                    }
                }
                
                
                
            }
            .padding()
            
            if isloading {
                VStack {
                    Text("LOADING...")
                    ProgressView()
                }
                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                .frame(maxHeight: .infinity)
                .background(Color.gray)
                .opacity(0.5)
            }
            
        }
        .onAppear() {
            Task {
                await loadcategories()
            }
        }
        
        
    }
    
    func loadcategories() async {
        
        if isPreview {
            jokecategories = ["A", "B", "C"]
            return
        }
        
        let apiurl = URL(string: "https://api.chucknorris.io/jokes/categories")!
        
        isloading = true
        do {
            let (data, _) = try await URLSession.shared.data(from: apiurl)
                        
            let decoder = JSONDecoder()
            
            if let categories = try? decoder.decode([String].self, from: data) {
                                
                jokecategories = categories
            }
            
            isloading = false
            
        } catch {
            print("Fel fel")
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
        
        if isPreview {
            thejoke = Chucknorrisinfo(id: "aaa", created_at: "xxx", value: "Joke joke joke")
            return
        }
        
        errormessage = ""
        
        let apiurl = URL(string: apiurlstring)!
        
        do {
            isloading = true
            let (data, _) = try await URLSession.shared.data(from: apiurl)
                        
            let decoder = JSONDecoder()
            
            if let chuckthing = try? decoder.decode(Chucknorrisinfo.self, from: data) {
                                
                thejoke = chuckthing
            }
            if let chuckthing = try? decoder.decode(ChucknorrisSearchresult.self, from: data) {
                
                if chuckthing.result.count > 0 {
                    thejoke = chuckthing.result[0]
                } else {
                    errormessage = "Nothing found!"
                }
            }
            isloading = false

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

#Preview {
    ContentView()
}




struct Chucknorrisinfo : Codable {
    var id : String
    var created_at : String
    var value : String
}


struct ChucknorrisSearchresult : Codable {
    var total : Int
    var result : [Chucknorrisinfo]
}
