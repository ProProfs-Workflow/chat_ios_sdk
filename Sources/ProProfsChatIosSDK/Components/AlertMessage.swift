//
//  AlertMessage.swift
//  ProProfsChatSDK
//
//  Created by Ajay Mandrawal on 17/10/22.
//

import SwiftUI

struct AlertMessage: View {
    @State var message_title:String
    @State var button_left_text:String
    @State var button_right_text:String
    var onButtonLeftClick : () -> ()
    var onButtonRightClick : () -> ()
    
    var body: some View {
        VStack{
            Text(message_title)
                .font(.system(size: 16))
                .foregroundColor(Color(hexString: Constants.FORM_FIELD_TITLE_COLOR))
                .padding(10)
            HStack{
                Spacer()
                Button(action: {
                    self.onButtonLeftClick()
                }, label: {
                    Text(button_left_text)
                })
                
                Button(action: {
                    self.onButtonRightClick()
                }, label: {
                    Text(button_right_text)
                })
            }.padding(10)
        }.background(Color.white)
            .frame(width:300)
    }
}

//struct AlertMessage_Previews: PreviewProvider {
//    static var previews: some View {
//        AlertMessage()
//    }
//}
