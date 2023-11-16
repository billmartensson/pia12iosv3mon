//
//  ChuckHelper.swift
//  pia12iosv3mon
//
//  Created by BillU on 2023-11-16.
//

import Foundation

class ChuckHelper {
    
    var isPreview: Bool {
        return ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
    }
    
    func fixdate(indate : String) -> String {
        // 2020-01-05 13:42:19.104863
        let dateformat = DateFormatter()
        dateformat.dateFormat = "yyyy-MM-dd HH:mm:ssssss"
        
        let thedate = dateformat.date(from: indate)
                
        return "17/12 2023"
    }
    
}
