//
//  Checkbox.swift
//  ChatSDK
//
//  Created by Ajay Mandrawal on 20/09/22.
//

import SwiftUI

struct Checkbox: View {
    @State var label:String
    @Binding var value:String
    @Binding var showErrorMsg:Bool?
    var body: some View {
        var values = value.split(separator: ",").map { String($0) }
        let index = values.firstIndex(of: label)
       
        HStack(){
            if (index != nil){
                Image(systemName: "checkmark.rectangle") .foregroundColor(Color(hexString: Constants.FORM_FIELD_TITLE_COLOR))
                    .font(.system(size: 14))
            } else
            {
                Image(systemName: "rectangle") .foregroundColor(Color(hexString: Constants.FORM_FIELD_TITLE_COLOR))
                    .font(.system(size: 14))

            }
            Text(label)
                .font(.system(size: Constants.FORM_FIELD_FONT_SIZE))
                .foregroundColor(Color(hexString: Constants.FORM_FIELD_TITLE_COLOR))
            Spacer()
        }
        .onTapGesture {
            showErrorMsg =  false
            if(index != nil){
                values.remove(at: index!)
                value = values.joined(separator: ",")
            } else {
                values.append(label)
                value = values.joined(separator: ",")
            }
        }
    }
}

//struct Checkbox_Previews: PreviewProvider {
//    @State  static var value:String? = "option "
//    static var previews: some View {
//        Checkbox(label: "option 1",value: $value)
//    }
//}
