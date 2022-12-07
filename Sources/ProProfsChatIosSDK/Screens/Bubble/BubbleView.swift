//
//  BubbleView.swift
//  ChatSDK
//
//  Created by Ajay Mandrawal on 29/09/22.
//

import SwiftUI

struct BubbleView: View {
    @Binding var isOperatorOnline: Bool
    @State var chatStyle:ChatStyle
    @State var barBubbleText:String
    var body: some View {
        ZStack{
            if(chatStyle.embedded_window ==  BubbleType.BAR.rawValue){
                HStack{
                   
                    Image("third",bundle: getBundle())
                        .resizable()
                        .frame(width: 40, height: 40, alignment: .center)
                        .padding(.leading,5)
                    Text(barBubbleText).foregroundColor(Color.white)
                    Spacer()
                }
                
            } else {
                CircularBubbleView(chatStyle: chatStyle)
            }
        }
        .frame(width: chatStyle.embedded_window ==  BubbleType.BAR.rawValue ? 200 : 60,height: chatStyle.embedded_window ==  BubbleType.BAR.rawValue ? 50 : 60)
        .background(
            RoundedCornersShape(corners: chatStyle.embedded_window ==  BubbleType.BAR.rawValue ? [.topLeft, .topRight] : [.topLeft, .topRight, .bottomLeft, .bottomRight], radius: chatStyle.embedded_window ==  BubbleType.BAR.rawValue ? 10 : 20)
                .fill(Color(hexString: chatStyle.chead_color))
        )
//        .background(Color(hexString: chatStyle.chead_color))
//        .cornerRadius(30)
        .overlay(alignment: .topTrailing, content: {
            HStack{
                Circle()
                    .foregroundColor(Color(hexString: isOperatorOnline ? "1ded26" : "cccccc"))
                    .frame(width: 10,height: 10,alignment: .top)
                    .cornerRadius(5)
                    .padding(.trailing, chatStyle.embedded_window ==  BubbleType.BAR.rawValue ? 5 : 2)
                    .padding(.top, chatStyle.embedded_window ==  BubbleType.BAR.rawValue ? -3 : 5)
            }
        })
            
    }
}

//struct BubbleView_Previews: PreviewProvider {
//    @State var isOperatorOnline = true
//    static var previews: some View {
//        BubbleView(isOperatorOnline:$isOperatorOnline, chatStyle: ChatStyle(embedded_window: 3, chead_color: "db4d4b", cwin_size: "2", chat_window_position: "", dept_enable: "", opchat_enable: "", chat_visitor_name_color: "030303", chat_operator_name_color: "030303", rate_chat: "Y", addchtm_time: "", logo_img: "", pchatfrm: "", pchatfrmurl: "", cmailfrm: "", cmailfrmurl: "", waittime: "", custom_chat_bubble: "customlogo/47875_1659966774.png", no_offimg: ""), barBubbleText: "")
//    }
//}
