//
//  ChatHeader.swift
//  ProProfsChatSDK
//
//  Created by Ajay Mandrawal on 14/10/22.
//

import SwiftUI

struct ChatHeader: View {
    @Binding var operator_details:OperatorDetail?
    @Binding var site_id:String
    @Binding var chatSettingData: ChatSettingData!
    @State var fill_color:String
    @State var rating = 0
    var onRatingSelected : (Int) -> ()
    var body: some View {
        HStack {
            if(showDefaultImage(url: operator_details?.photourl ?? "")){
                Image("operator_default_image",bundle: getBundle())
                    .resizable()
                    .frame(width: 60, height: 60, alignment: .center)
            } else {
                let  url = operator_details?.photourl ?? ""
                if(url.contains("http")){
                    AsyncImage(url: URL(string: operator_details?.photourl ?? ""),scale: 8)
                        .frame(width: 60, height: 60, alignment: .center)
                        .clipShape(Circle())
                } else {
                    AsyncImage(url: URL(string: "\(ApiUrls.OperatorImageBaseUrl.rawValue)\(operator_details?.photourl ?? "")"),scale: 8)
                        .frame(width: 60, height: 60, alignment: .center)
                        .clipShape(Circle())
                }
                
            }
            
            VStack(alignment: .leading,spacing: 5){
                Text(operator_details?.name ?? "")
                    .foregroundColor(Color(hexString: Constants.FORM_FIELD_TITLE_COLOR))
                if(chatSettingData.chat_style.rate_chat == "Y"){
                    Rating(fill_color: fill_color, onRatingSelected:{_ in }, site_id: $site_id, chatSettingData: $chatSettingData)
                }
            }.padding(10)
            
            Spacer()
        }
        .padding(12)
        
    }
    
    func showDefaultImage(url:String) -> Bool{
        if(url == ""){
            return true
        } else {
            let splited_array = url.split(separator: ".")
            if(splited_array.last == "svg"){
                return true
            }
            return false
        }
    }
    
    func rateToOperator(rating:Int){
        let body = "Site_id=\(site_id)&ProProfs_Session=\(chatSettingData.proprofs_session)&ProProfs_rating=\(rating)"
        guard let url =  URL(string: "\(currentEnvironment())\(ApiUrls.SubmitRating.rawValue)") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = body.data(using: .utf8)
        URLSession.shared.dataTask(with: request) { (data , response, error) in
            
        }.resume()
    }
}

//struct ChatHeader_Previews: PreviewProvider {
//    static var previews: some View {
//        @State  var operator_details:OperatorDetail? = OperatorDetail(name: "Ajay", photourl: "String")
//        ChatHeader(operator_details: operator_details)
//    }
//}
