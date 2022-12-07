//
//  VisitorMessage.swift
//  ProProfsChatSDK
//
//  Created by Ajay Mandrawal on 03/10/22.
//

import SwiftUI

struct VisitorMessage: View {
    @Binding  var message:Message
    @State var text_color:String
    @State var bg_color: String
    @State var account_id:String
    @State var showMessageTime:String = ""
    
    var body: some View {
        VStack(alignment: .trailing){
            VStack{
                if(message.rand_no != "i"){
                    Text(message.message).foregroundColor(Color(hexString: text_color))
                        .font(.system(size: 14))
                        .padding(15)
                } else {
                    AsyncImage(url: URL(string: "\(messageImageUrl())\(account_id)/\(message.message)"), scale: 7) { image in
                        image
                        //                                    .resizable()
                        //                                    .aspectRatio(contentMode: .fill)
                        
                    } placeholder: {
                        ProgressView()
                    }
                    //                    AsyncImage(url: URL(string: "\(messageImageUrl())\(account_id)/\(message.message)") , scale: 4)
                }
            }.background(
                RoundedCornersShape(corners: [.topLeft, .topRight, .bottomLeft], radius: 20)
                    .fill(Color(hexString: bg_color))
            )
            if(showMessageTime == "Y"){
                Text(message.msgtm)
                    .foregroundColor(Color.gray)
                    .font(.system(size: 12))
            }
            if (message.msg_status == "2"){
                Text("Seen")
                    .foregroundColor(Color(hexString: "#11e711"))
                    .font(.system(size: 12))
            } else {
                Text("Sent")
                    .foregroundColor(Color.gray)
                    .font(.system(size: 12))
            }
            
        }
    }
}

//struct VisitorMessage_Previews: PreviewProvider {
//    static var previews: some View {
//        VisitorMessage(message: Message(id_ip: "", message: "Hello, how can I help you today?", msg_status: "2", msgtm: "01:30 PM", pushurl: "0", rand_no: "", sno: "121964005", v_o: "v"),text_color: "#b82424",bg_color: "#3c8ac942")
//    }
//}
