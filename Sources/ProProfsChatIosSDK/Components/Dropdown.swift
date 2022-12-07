//
//  Dropdown.swift
//  ChatSDK
//
//  Created by Ajay Mandrawal on 22/09/22.
//

import SwiftUI

struct Dropdown: View {
    @Binding var selectedValue:Bool
    @State var dropdwonList:[String]
    var onItemSelected : (String) -> ()
    
    var body: some View {
        
        VStack{
            ForEach(dropdwonList,id: \.self){
                item in
                HStack(){
                    Button(action: {
                        selectedValue = false
                        onItemSelected.self(item)
                    }, label: {
                        HStack{
                            Spacer()
                            Text(item)
                            Spacer()
                        }
                    })
                    .padding(10)
                    .frame(width:300)
                
                }.onTapGesture(perform: {
                    selectItem(item: item)
                })
                Divider()
            }
        }
            .frame(width: 300)
    }
    
    func selectItem(item:String){
        selectedValue = false
        onItemSelected.self(item)
    }
}

//struct Dropdown_Previews: PreviewProvider {
//   static var  list = ["Option1","Option2"]
//    static var previews: some View {
//        Dropdown(list: list, selectedItem: selectedAnswer())
//    }
//    
//    static func selectedAnswer() -> Void{
//     
//    }
//}
