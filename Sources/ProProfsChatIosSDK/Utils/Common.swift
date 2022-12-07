//
//  Common.swift
//  ProProfsChatSDK
//
//  Created by Ajay Mandrawal on 20/10/22.
//

import Foundation


func getTimeZone() -> Int{
    let timezone = TimeZone.current.secondsFromGMT() / 60
    return timezone
}

func getCurrentTime() -> String {
    let date = Date().getFormattedDate(format: "hh:mm a")
    return date
}


func getBundle() -> Bundle {
    let bundle:Bundle
    #if SWIFT_PACKAGE
    bundle = Bundle.module
    #else
    bundle = Bundle(identifier: "com.proprofs.ProProfsChatSDK")
    #endif
    return bundle
}
