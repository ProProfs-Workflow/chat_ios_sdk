//
//  enviroment.swift
//  ChatSDK
//
//  Created by Ajay Mandrawal on 30/09/22.
//

import Foundation

enum Enviroment : String{
    case DEVELOPMENT = ""
    case PRODUCTION = "https://s01.live2support.com/dashboardv2/chatwindow/"
}

func messageImageUrl() -> String {
    if(currentEnvironment() ==  Enviroment.PRODUCTION.rawValue){
        return "https://live2support-root.s3.amazonaws.com/l2s-media/"
    } else {
        return ""
    }
}

func currentEnvironment() -> String{
    return Enviroment.PRODUCTION.rawValue
}
