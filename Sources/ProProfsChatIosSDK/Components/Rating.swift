//
//  Rating.swift
//  ProProfsChatSDK
//
//  Created by Ajay Mandrawal on 18/10/22.
//

import SwiftUI

struct Rating: View {
    @State var fill_color:String
    @State var rating = 0
    var onRatingSelected : (Int) -> ()
    @Binding var site_id:String
    @Binding var chatSettingData: ChatSettingData!
    
    var body: some View {
        HStack {
            Image(systemName: rating  > 0 ? "star.fill" : "star").onTapGesture {
                rating = 1
                onRatingSelected(1)
                rateToOperator(rating: 1)
            }
                .foregroundColor(Color(hexString: fill_color))
            Image(systemName: rating  > 1 ? "star.fill" : "star")
                .onTapGesture {
                    rating = 2
                    onRatingSelected(2)
                    rateToOperator(rating: 2)
                }
                .foregroundColor(Color(hexString: fill_color))
            
            Image(systemName: rating  > 2 ? "star.fill" : "star")
                .onTapGesture {
                    rating = 3
                    onRatingSelected(3)
                    rateToOperator(rating: 3)
                }
                .foregroundColor(Color(hexString: fill_color))
            
            Image(systemName: rating  > 3 ? "star.fill" : "star")
                .onTapGesture {
                    rating = 4
                    onRatingSelected(4)
                    rateToOperator(rating: 4)
                }
                .foregroundColor(Color(hexString: fill_color))
            
            Image(systemName: rating  > 4 ? "star.fill" : "star")
                .foregroundColor(Color(hexString: fill_color))
                .onTapGesture {
                    rating = 5
                    onRatingSelected(5)
                    rateToOperator(rating: 5)
                }
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

//struct Rating_Previews: PreviewProvider {
//    static var previews: some View {
//        Rating()
//    }
//}
