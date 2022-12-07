//
//  ChatFormField.swift
//  ChatSDK
//
//  Created by Ajay Mandrawal on 15/09/22.
//

import Foundation

struct ChatFormField: Identifiable, Hashable, Codable {
    let id = UUID()
    let fleg: String
    var fld_name: String
    var fld_type: String
    let js: String
    let jsmsg: String
    let sel_item: String
    let field_identifier: String
    let order: String
    let isname: String
    let isemail: String
    var value: String? = ""
    var showErrorMsg:Bool? = false
}
