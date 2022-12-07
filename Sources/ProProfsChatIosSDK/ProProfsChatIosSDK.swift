import SwiftUI

public struct ProProfsChatIosSDK: View {
    let preference = UserDefaults.standard
        let timer = Timer.publish(every: 6, on: .main, in: .common).autoconnect()
        @State private var chatSettingData:ChatSettingData!
        @State private  var lastMessageId = "0"
        @State var site_id:String
        @State private var oldChatData: ChatData!
        @State private var chatData: ChatData
        @State private var isOperatorOnline = false
        @State private var showWindow = false
        
        public init(site_id: String) {
            _site_id = State(initialValue: site_id)
            _chatData = State(initialValue:   ChatData(chat_status: "1", messages: [], operator_status: [], messages_status: [], operator_details: []))
        }
        
        public var body: some View {
            VStack{
                if(chatSettingData != nil && chatSettingData._ProProfs_SDK_Status == "1"){
                    BubbleView(isOperatorOnline:$isOperatorOnline, chatStyle: chatSettingData.chat_style, barBubbleText: chatSettingData.chat_header_text.chat_online_text )
                        .onAppear(){
                            isOperatorOnline = chatSettingData.operator_status.count == 0 ? false :true
                        }
                        .onReceive(timer) { input  in
                            getChatData(site_id: site_id)
                        }
                        .onTapGesture {
                            showWindow = true
                        }
                        .fullScreenCover(isPresented: $showWindow) {
                            Screen(chatData: $chatData, chatSettingData: $chatSettingData, lastMessageId: $lastMessageId, oldChatData: $oldChatData, site_id: $site_id, resetChatData: {
                                oldChatData = nil
                                preference.set("", forKey: "visitor_name")
                                preference.set("", forKey: "visitor_email")
                            })
                        }
                }                
            }.onAppear(){
                getData(site_id: site_id)
            }
        }

        func getData(site_id:String)  {
            guard let url =  URL(string: "\(currentEnvironment())\(ApiUrls.GetSettings.rawValue)") else { return }
            let params:[String:String] = [
                "site_id":site_id,
                "proprofs_language_id":"",
                "ProProfs_Session":preference.string(forKey: "session_id") ?? "",
                "ProProfs_Current_URL":"sdk_\(site_id)",
                "ProProfs_refferal_URL":"",
                "ProProfs_device_id":"",
                "ProProfs_Chat_Token":"",
                "ProProfs_Chat_Email":"",
                "ProProfs_Chat_l2s_cv":"",
                "AccountCode":"",
                "ProProfsGroupIdHardCoded":"",
                "_ProProfs_custom_langauge_for_bot":"",
                "var_pp_kb_tracker":"0"]
            
            let postString = getPostString(body:"", params: params)
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.httpBody = postString.data(using: .utf8)
            URLSession.shared.dataTask(with: request) { (data , response, error) in
                if let data = data{
                    if let response = try? JSONDecoder().decode(ChatSettingData.self, from: data){
                        self.chatSettingData = response
                        preference.set(chatSettingData.proprofs_session, forKey: "session_id")
                    } else {
                    }
                }
            }.resume()
        }
        
        func getChatData(site_id:String){
            guard let url =  URL(string: "\(currentEnvironment())\(ApiUrls.GetChatData.rawValue)") else { return }
            let params:[String:String] = [
                "site_id":site_id,
                "proprofs_language_id":String(chatSettingData.proprofs_language_id ),
                "ProProfs_Session":String(chatSettingData.proprofs_session ),
                "ProProfs_Msg_Counter":lastMessageId,
                "ProProfs_Visitor_TimeZone":String(getTimeZone()),
                "ProProfs_invitation_type":"",
                "ProProfs_Current_URL":"chat_sdk",
                "ProProfsGroupIdHardCoded":"",
                "ProProfs_Visitor_name":preference.string(forKey: "visitor_name") ?? "",
                "ProProfs_Visitor_email":preference.string(forKey: "visitor_email") ?? "",
                "ProProfs_typing_message":""
            ]
            let postString = getPostString(body:"", params: params)
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.httpBody = postString.data(using: .utf8)
            URLSession.shared.dataTask(with: request) { (data , response, error) in
                if let data = data{
                    if let response = try? JSONDecoder().decode(ChatData.self, from: data){
                        chatSettingData.operator_status = response.operator_status
                        chatSettingData.chat_status.status = response.chat_status
                        isOperatorOnline = chatSettingData.operator_status.count == 0 ? false :true
                        chatData = response
                        if(lastMessageId == "0"){
                            oldChatData = chatData
                        }
                    }
                }
            }.resume()
        }
}
