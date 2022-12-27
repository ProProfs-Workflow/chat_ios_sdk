//
//  ChatScreen.swift
//  ChatSDK
//
//  Created by Ajay Mandrawal on 27/09/22.
//

import SwiftUI

public struct ChatScreen: View {
    @Binding var chatData: ChatData
    @Binding var oldChatData: ChatData!
    @Binding var lastMessageId:String
    @State private var messages:[Message] = []
    @Binding  var chatSettingData:ChatSettingData!
    @Binding var site_id:String
    @State private var visitor_message:String = ""
    @State private var showSpinner = true
    @State private var showAlert = false
    @State private var operator_detail :OperatorDetail? = OperatorDetail(name: "", photourl: "")
    @State private var image = UIImage()
    @State private var imageExtension: String = ""
    @State private var showSheet = false
    @State private var showCloseButton = false
    var backIconClick : () -> ()
    var showPostChatForm : (Int) -> ()
    
    public var body: some View {
        VStack{
            HeaderView(navigationTitle: chatSettingData.chat_header_text.chat_online_text, headerBackgroundColor: chatSettingData.chat_style.chead_color, showCloseButton:$showCloseButton, onBackIconClick: {
                backIconClick()
            }, showCloseChatPopUp: {
                showAlert = true
            })
            
            ZStack{
                VStack{
                    ChatHeader(operator_details: $operator_detail,site_id: $site_id,chatSettingData: $chatSettingData, fill_color: chatSettingData.chat_style.chead_color,onRatingSelected: {
                        rating in
                    })
                    Divider()
                    ScrollView{
                        ScrollViewReader{value in
                            VStack{
                                ForEach(messages.indices,id: \.self){
                                    index  in
                                    if(messages[index].v_o == "o"){
                                        HStack{
                                            OperatorMessage(message: messages[index],text_color: chatSettingData.chat_style.chat_operator_name_color, account_id: chatSettingData.ProProfs_accounts, showMessageTime: chatSettingData.chat_style.addchtm_time )
                                                .padding(.trailing,20)
                                            Spacer()
                                        }
                                    }
                                    if(messages[index].v_o == "v"){
                                        HStack{
                                            Spacer()
                                            VisitorMessage(message: $messages[index], text_color: chatSettingData.chat_style.chat_visitor_name_color , bg_color: chatSettingData.chat_style.chead_color , account_id: chatSettingData.ProProfs_accounts, showMessageTime: chatSettingData.chat_style.addchtm_time )
                                                .padding(.leading,20)
                                        }
                                    }
                                }
                            }.id("scroll_to_last_message")
                                .onChange(of: messages){ new in
                                    value.scrollTo("scroll_to_last_message")
                                }
                        }
                    }  .padding(.leading,15)
                        .padding(.trailing,15)
                        .onChange(of: chatData.operator_details){ newValue in
                            operator_detail = chatData.operator_details.first
                        }
                        .onChange(of: chatData.messages_status, perform: { newValue in
                            updateVistorMessageStatus(messageStatusList:newValue)
                        })
                        .onChange(of: chatData.messages){ newValue in
                            if(!(chatData.messages.isEmpty)){
                                if(lastMessageId == "0"){
                                    messages = chatData.messages
                                } else {
                                    messages.append(contentsOf: chatData.messages)
                                }
                                lastMessageId = (chatData.messages.last!.sno)
                                updateMessageStatus()
                            }
                            
                            if(messages.isEmpty){
                                showSpinner = true
                            } else {
                                showSpinner = false
                                showCloseButton = true
                            }
                        }.onAppear(){
                            if(oldChatData != nil){
                                lastMessageId = "0"
                                messages  = oldChatData.messages
                                operator_detail = oldChatData.operator_details.first
                                if(messages.isEmpty){
                                    showSpinner = true
                                } else {
                                    showSpinner = false
                                    showCloseButton = true
                                }
                            }
                            
                        }
                    
                    HStack{
                        TextField(chatSettingData.static_language?.placeholder_text ?? "",text:$visitor_message)
                            .textFieldStyle(.roundedBorder)
                        if(chatSettingData.chat_style_extra.filetransfer == "Y"){
                            Image(systemName: "paperclip.circle.fill")
                                .sheet(isPresented: $showSheet) {
                                    // Pick an image from the photo library:
                                    ImagePicker(sourceType: .photoLibrary, selectedImage: self.$image, imageExtension:$imageExtension).onDisappear(){
                                        
                                        if(image.size.width != 0.0){
                                            let imageData =  image.jpegData(compressionQuality: 1)
                                            let imageBase64String = imageData?.base64EncodedString()
                                            uploadImage(file: imageBase64String!, fileExtension: imageExtension)
                                        }
                                        
                                    }
                                    
                                    //  If you wish to take a photo from camera instead:
                                    // ImagePicker(sourceType: .camera, selectedImage: self.$image)
                                }
                                .font(.system(size:30))
                                .foregroundColor(Color(hexString: Constants.CHAT_ATTACHMENT_BTN_BACKGROUND_COLOR))  .onTapGesture {
                                    showSheet = true
                                }
                        }
                        
                        
                        Image(systemName: "greaterthan.circle.fill")
                            .font(.system(size:30))
                            .foregroundColor(Color(hexString: chatSettingData.chat_style.chead_color ))
                            .onTapGesture(perform: {
                                if(visitor_message.trimmingCharacters(in: .whitespacesAndNewlines) != ""){
                                    sendVisitorMessage()
                                }
                            })
                    }.padding(20)
                    
                    FooterView()
                    
                }
                
                if (showSpinner || showAlert) {
                    ZStack{
                        VStack{}
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(.gray)
                            .opacity(0.3)
                        if showSpinner {
                            ProgressView()
                        }
                        if showAlert {
                            AlertMessage(message_title: chatSettingData.static_language?.closing_text ?? "",
                                         button_left_text: chatSettingData.static_language?.end_chat_text ?? "",
                                         button_right_text: chatSettingData.static_language?.continue_text ?? "",
                                         onButtonLeftClick: {
                                showSpinner = true
                                showAlert = false
                                closeChat()
                            },
                                         onButtonRightClick: {
                                showAlert = false
                            })
                        }
                    }
                    .onTapGesture{
                    }
                }
            }
        }
    }
    
    func updateVistorMessageStatus(messageStatusList:[VisitorMessageStatus]){
        let visitor_unseen_messages = messages.filter{ $0.msg_status == "0" && $0.v_o == "v"}
        if(!visitor_unseen_messages.isEmpty){
            for(_, message) in visitor_unseen_messages.enumerated() {
                let seen_message_sno = String(messageStatusList.first{$0.sno == message.sno && $0.msg_status == "2"}?.sno ?? "")
                if(seen_message_sno != ""){
                    let seen_message_index = Int(messages.firstIndex{$0.sno == seen_message_sno} ?? -1)
                    if(seen_message_index != -1){
                        messages[seen_message_index].msg_status = "2"
                    }
                    
                }
                
            }
        }
        
    }
    
    func sendVisitorMessage(){
        let body = "ProProfs_Session=\(String(chatSettingData.proprofs_session ))&ProProfs_Message=\(visitor_message)"
        let message =  Message(id_ip: "", message: visitor_message, msg_status: "0", msgtm: getCurrentTime(), pushurl: "", rand_no: "", sno: "null", v_o: "v")
        messages.append(message)
        visitor_message = ""
        guard let url =  URL(string: "\(currentEnvironment())\(ApiUrls.SendVisitorMessage.rawValue)") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = body.data(using: .utf8)
        URLSession.shared.dataTask(with: request) { (data , response, error) in
            if let data = data{
                if let response = try? JSONDecoder().decode(VisitorMessageResponse.self, from: data){
                    updateVisitorLastMessageId(id: String(response.id))
                } else {
                    
                }
            }
        }.resume()
    }
    
    func updateVisitorLastMessageId(id:String){
        if(messages.last?.v_o == "v"){
            messages[messages.count - 1].sno = id
        }
    }
    
    func updateMessageStatus(){
        let body = "ProProfs_Session=\(String(chatSettingData.proprofs_session ))"
        guard let url =  URL(string: "\(currentEnvironment())\(ApiUrls.UpdateMessageStatus.rawValue)") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = body.data(using: .utf8)
        URLSession.shared.dataTask(with: request) { (data , response, error) in
        }.resume()
    }
    
    func closeChat(){
        let body = "ProProfs_Session=\(String(chatSettingData.proprofs_session ))&ProProfs_site_id=\(site_id)&ProProfs_closed_by=2"
        guard let url =  URL(string: "\(currentEnvironment())\(ApiUrls.CloseChat.rawValue)") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = body.data(using: .utf8)
        URLSession.shared.dataTask(with: request) { (data , response, error) in
            
            if let data = data{
                if let response = try? JSONDecoder().decode(CloseChatResponse.self, from: data){
                    self.showPostChatForm(response.transcriptId)
                } else {
                    
                }
            }
            
        }.resume()
    }
    
    func uploadImage(file:String,fileExtension:String){
        let body = "pp_img_counter=5&session_id_image=\(String(chatSettingData.proprofs_session ))&site_id=\(site_id)&from=sdk&sdk_image_url=data:image/\(fileExtension);base64,\(file)"
        guard let url =  URL(string: "\(currentEnvironment())\(ApiUrls.UploadImage.rawValue)") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = body.data(using: .utf8)
        URLSession.shared.dataTask(with: request) { (data , response, error) in
            
            if let data = data{
                if let response = try? JSONDecoder().decode(ImageUploadResponse.self, from: data){
                    let message =  Message(id_ip: "", message: response.file_name, msg_status: "0", msgtm: getCurrentTime(), pushurl: "", rand_no: "i", sno: String(response.id), v_o: "v")
                    messages.append(message)
                } else {
                    
                }
            }
        }.resume()
    }
}

//struct ChatScreen_Previews: PreviewProvider {
//    static var previews: some View {
//        ChatScreen()
//    }
//}
