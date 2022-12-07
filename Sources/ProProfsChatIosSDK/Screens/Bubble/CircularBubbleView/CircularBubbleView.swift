//
//  CircularBubbleView.swift
//  ChatSDK
//
//  Created by Ajay Mandrawal on 29/09/22.
//

import SwiftUI

struct CircularBubbleView: View {
    var BASE_URL = "https://live2support-root.s3.amazonaws.com/l2s-media/theme-media/"
    @State var chatStyle:ChatStyle
    var body: some View {
        if(chatStyle.embedded_window ==  CircularBubbleType.ICON_3.rawValue){
            Image("third",bundle: getBundle())
                .resizable()
                .frame(width: 50, height: 50, alignment: .center)
        } else if(chatStyle.embedded_window ==  CircularBubbleType.ICON_7.rawValue){
            Image("seven",bundle: getBundle())
                .resizable()
                .frame(width: 50, height: 50, alignment: .center)
        } else if(chatStyle.embedded_window ==  CircularBubbleType.ICON_10.rawValue){
            Image("ten",bundle: getBundle())
                .resizable()
                .frame(width: 50, height: 50, alignment: .center)
        }
        else if(chatStyle.embedded_window ==  CircularBubbleType.ICON_12.rawValue){
           Image("twelve",bundle: getBundle())
               .resizable()
               .frame(width: 50, height: 50, alignment: .center)
       }
        else if(chatStyle.embedded_window ==  CircularBubbleType.MALE.rawValue){
           Image("male",bundle: getBundle())
               .resizable()
               .frame(width: 75, height: 75, alignment: .center)
       }
        else if(chatStyle.embedded_window ==  CircularBubbleType.MALE.rawValue){
           Image("female",bundle: getBundle())
               .resizable()
               .frame(width: 75, height: 75, alignment: .center)
       }
        else if(chatStyle.embedded_window ==  CircularBubbleType.CUSTOM_URL.rawValue){
            AsyncImage(url: URL(string: "\(BASE_URL)\(chatStyle.custom_chat_bubble)"),scale: 3)
                .clipShape(Circle())
       }
        else if(chatStyle.embedded_window ==  CircularBubbleType.TEXT_CHAT.rawValue){
            Text("Chat").foregroundColor(.white)
                .font(.system(size: 16,weight: .bold))
        }
        
        else {
            if(chatStyle.embedded_window ==  CircularBubbleType.TEXT_HELP.rawValue){
                Text("Help").foregroundColor(.white)
                    .font(.system(size: 16,weight: .bold))
            }
        }
    }
}

struct CircularBubbleView_Previews: PreviewProvider {
    static var previews: some View {
        CircularBubbleView(chatStyle: ChatStyle(embedded_window: 3, chead_color: "db4d4b", cwin_size: "2", chat_window_position: "", dept_enable: "", opchat_enable: "", chat_visitor_name_color: "030303", chat_operator_name_color: "030303", rate_chat: "Y", addchtm_time: "", logo_img: "", pchatfrm: "", pchatfrmurl: "", cmailfrm: "", cmailfrmurl: "", waittime: "", custom_chat_bubble: "", no_offimg: ""))
    }
}
