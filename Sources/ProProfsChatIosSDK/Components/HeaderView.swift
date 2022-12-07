//
//  HeaderView.swift
//  ChatSDK
//
//  Created by Ajay Mandrawal on 19/09/22.
//

import SwiftUI

struct HeaderView: View {
    @State var navigationTitle = ""
    @State var headerBackgroundColor: String
    @Binding var showCloseButton:Bool
    var onBackIconClick : () -> ()
    var showCloseChatPopUp: () -> ()
    var body: some View {
        HStack{
            Image("third",bundle: getBundle())
                .resizable()
                .frame(width: 40, height: 40, alignment: .center)
                .padding(.leading, 20)
            Text(navigationTitle)
                .padding()
                .foregroundColor(Color.white)
            Spacer()
            Button(action : {
                onBackIconClick.self()
                
            }){
                Image(systemName: "chevron.down").foregroundColor(Color.white)
            }
            .font(.system(size: 22))
            .padding(.leading, 10)
            .padding(.trailing, 10)
            if(showCloseButton){
                Button(action : {
                    showCloseChatPopUp.self()
                    
                }){
                    Image(systemName: "xmark").foregroundColor(Color.white)
                }
                .font(.system(size: 18))
                .padding(.trailing, 20)
                
            }
            
        }
        .background(Color(hexString: headerBackgroundColor))
    }
}

struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderView( headerBackgroundColor: "4d4d4d", showCloseButton: .constant(true), onBackIconClick: {}, showCloseChatPopUp: {})
    }
}
