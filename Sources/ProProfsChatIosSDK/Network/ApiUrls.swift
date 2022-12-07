//
//  ApiUrls.swift
//  ChatSDK
//
//  Created by Ajay Mandrawal on 30/09/22.
//

import Foundation

enum ApiUrls:String{
    case GetSettings = "getchatsettings"
    case GetChatData = "chat"
    case SendVisitorMessage = "send_visitor_message"
    case PreChatUrl = "prechat"
    case OfflineUrl = "offlinemessage"
    case OperatorImageBaseUrl = "https://s01.live2support.com/"
    case SubmitRating = "submitrating"
    case CloseChat = "genrate_transcript"
    case UploadImage = "uploadimage"
    case UpdateMessageStatus = "updatemessagestatus"
    case PostChatUrl = "postchat"
}
