//
//  ContentView.swift
//  pia12iosv3mon
//
//  Created by BillU on 2023-11-13.
//

import SwiftUI


struct ContentView: View {
        
    @State var searchtext = ""
    
    @StateObject var apistuff = ChuckAPI()
    
    @State var showjoke = false
    
    
    
    var body: some View {
        
        ZStack {
            VStack {
                VStack {
                    if apistuff.thejoke != nil {
                        Text(ChuckHelper().fixdate(indate: apistuff.thejoke!.created_at))
                        Text(apistuff.thejoke!.value)
                        
                        Button(action: {
                            showjoke = true
                        }, label: {
                            Text("Show joke")
                        })
                        .sheet(isPresented: $showjoke, content: {
                            ShowJokeView(bigapi: apistuff)
                        })
                    }
                }
                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                .frame(height: 200.0)
                .background(Color.fancyBlue)

                if apistuff.errormessage != "" {
                    VStack {
                        Text(apistuff.errormessage)
                            .foregroundColor(Color.white)
                    }
                    .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                    .frame(height: 100.0)
                    .background(Color.red)
                    
                }

                
                HStack {
                    TextField("Search joke...", text: $searchtext)
                        .onChange(of: searchtext) { oldValue, newValue in
                            print("Changing from \(oldValue) to \(newValue)")
                        }
                    
                    Button(action: {
                        apistuff.loadapiForSearch(jokesearch: searchtext)
                    }, label: {
                        Text("Search")
                    })
                }
                
                Button(action: {
                    apistuff.loadapiRandom()
                }, label: {
                    Text("Random joke")
                })
                
                
                List {
                    ForEach(apistuff.jokecategories, id: \.self) { cat in
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
                            apistuff.loadapiForCategory(jokecat: cat)
                        }
                        
                    }
                }
                
                
                
            }
            .padding()
            
            if apistuff.isloading {
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
            apistuff.loadcategories()
        }
        .onChange(of: apistuff.isloading) { oldValue, newValue in
            if(apistuff.isloading) {
                print("Nu ladda")
            } else {
                print("Inte ladda mer")
            }
            
        }
        
    }
    
    
}

#Preview {
    ContentView()
}



