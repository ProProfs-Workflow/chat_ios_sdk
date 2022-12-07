//
//  FooterView.swift
//  ProProfsChatSDK
//
//  Created by Ajay Mandrawal on 08/11/22.
//

import SwiftUI

struct FooterView: View {
    var body: some View {
        HStack(alignment: .center){
            Text("Powered By")
                .foregroundColor(Color(hexString: "737373"))
                .font(.system(size: 10))
            
            Image("footer_logo",bundle: getBundle())
                .resizable()
                .frame(width: 50, height: 10, alignment: .center)
                
        }
    }
}

struct FooterView_Previews: PreviewProvider {
    static var previews: some View {
        FooterView()
    }
}
