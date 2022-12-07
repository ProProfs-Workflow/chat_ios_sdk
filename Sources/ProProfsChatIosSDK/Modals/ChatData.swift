//
//  ChatData.swift
//  ChatSDK
//
//  Created by Ajay Mandrawal on 23/09/22.
//

import Foundation

struct ChatData: Codable {
    let chat_status: String
    var messages: [Message]
    let operator_status: [Operator]
    let messages_status: [VisitorMessageStatus]
    let operator_details: [OperatorDetail]
}
