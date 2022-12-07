//
//  Message.swift
//  ChatSDK
//
//  Created by Ajay Mandrawal on 23/09/22.
//

import Foundation



struct Message: Codable, Equatable {
    let id_ip: String?
    let message: String
    var msg_status: String
    let msgtm: String
    let pushurl: String
    let rand_no: String?
    var sno: String
    let v_o: String
}

