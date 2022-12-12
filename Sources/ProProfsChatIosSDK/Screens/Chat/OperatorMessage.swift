//
//  OperatorMessage.swift
//  ProProfsChatSDK
//
//  Created by Ajay Mandrawal on 03/10/22.
//

import SwiftUI

struct OperatorMessage: View {
    @State  var message:Message
    @State var text_color:String
    @State var account_id:String
    @State var showMessageTime:String = ""
    var body: some View {
        VStack(alignment: .leading){
            VStack{
                if(message.rand_no != "i"){
                    Text(message.message).foregroundColor(Color(hexString: text_color))
                        .font(.system(size: 14))
                        .padding(15)
                } else {
                    AsyncImage(url: URL(string: "\(messageImageUrl())\(account_id)/\(message.message)"), scale: 7) { image in
                        image
                    } placeholder: {
                        ProgressView()
                    }
                }
            }.background(
                RoundedCornersShape(corners: [.topLeft, .topRight, .bottomRight], radius: 20)
                    .fill(Color(hexString: Constants.OPERATOR_BUBBLE_BACKGROUND_COLOR))
            )
            if(showMessageTime == "Y"){
                Text(message.msgtm)
                    .foregroundColor(Color.gray)
                    .font(.system(size: 12))
            }
        }
    }
}

//struct OperatorMessage_Previews: PreviewProvider {
//    static var previews: some View {
//        OperatorMessage(message: Message(id_ip: "admin", message: "Hello, how can I help you today?", msg_status: "0", msgtm: "01:30 PM", pushurl: "0", rand_no: "admin522", sno: "121964005", v_o: "o"),text_color: Constants.OPERATOR_BUBBLE_TEXT_COLOR)
//    }
//}
