//
//  RadioButton.swift
//  ChatSDK
//
//  Created by Ajay Mandrawal on 20/09/22.
//

import SwiftUI

struct RadioButton: View {
    @State var label:String
    @Binding var value:String?
    var body: some View {
        HStack{
            if (label == value){
                Image(systemName: "dot.circle")
                    .foregroundColor(Color(hexString: Constants.FORM_FIELD_TITLE_COLOR))
                        .font(.system(size: 14))
            } else
            {
                Image(systemName: "circle")
                    .foregroundColor(Color(hexString: Constants.FORM_FIELD_TITLE_COLOR))
                        .font(.system(size: 14))
            }
            Text(label)
                .font(.system(size: Constants.FORM_FIELD_FONT_SIZE))
                .foregroundColor(Color(hexString: Constants.FORM_FIELD_TITLE_COLOR))
            Spacer()
        }.onAppear(){
        }
    }
}

struct RadioButton_Previews: PreviewProvider {
    @State  static var value:String? = "option 1"
    static var previews: some View {
        RadioButton(label: "option 1",value: $value)
    }
}
