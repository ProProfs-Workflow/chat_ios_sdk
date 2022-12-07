//
//  ErrorMessage.swift
//  ChatSDK
//
//  Created by Ajay Mandrawal on 23/09/22.
//

import SwiftUI

struct ErrorMessage: View {
    var message:String
    var body: some View {
        HStack{
            Text(message)
                .foregroundColor(Color.red)
                .font(.system(size: Constants.ERROR_MSG_FONT_SIZE))
            Spacer()
        }
    }
}

//struct ErrorMessage_Previews: PreviewProvider {
//    static var previews: some View {
//        ErrorMessage()
//    }
//}
