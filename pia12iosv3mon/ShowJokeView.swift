//
//  ShowJokeView.swift
//  pia12iosv3mon
//
//  Created by BillU on 2023-11-16.
//

import SwiftUI

struct ShowJokeView: View {
    
    @Environment (\.dismiss) var dismiss
    
    //@State var bigjoke : Chucknorrisinfo
    
    //@StateObject var apistuff = ChuckAPI()
    
    @StateObject var bigapi : ChuckAPI
    
    var body: some View {
        VStack {
            if bigapi.thejoke != nil {
                Text(bigapi.thejoke!.value)
                    .font(.largeTitle)
            }
            
            Button(action: {
                bigapi.loadapiRandom()
            }, label: {
                Text("Random")
            })
            
            
            Button(action: {
                dismiss()
            }, label: {
                Text("Close")
            })
            
        }
    }
}

#Preview {
    ShowJokeView(bigapi: ChuckAPI())
}
