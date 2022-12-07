//
//  FormFieldTitle.swift
//  ProProfsChatSDK
//
//  Created by Ajay Mandrawal on 03/11/22.
//

import SwiftUI

struct FormFieldTitle: View {
    @Binding var title:String
    @Binding var type:String
    @State var htmlValue: String = ""
    var body: some View {
        HStack {
            Text(type == FormFieldType.PRIVACY_POLICY.rawValue ? htmlValue : title )
                .foregroundColor(Color(hexString: Constants.FORM_FIELD_TITLE_COLOR))
                .font(.system(size: Constants.FORM_FIELD_FONT_SIZE))
            Text("*").foregroundColor(Color.red)
            Spacer()
        }.padding(.top,15)
            .onAppear(){
                if(type == FormFieldType.PRIVACY_POLICY.rawValue){
                    htmlValue = title.html2String.html2String
                }
            }
    }
}

//struct FormFieldTitle_Previews: PreviewProvider {
//    static var previews: some View {
//        FormFieldTitle(title: "Test")
//    }
//}
