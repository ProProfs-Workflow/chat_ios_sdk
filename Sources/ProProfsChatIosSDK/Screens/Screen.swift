//
//  Screen.swift
//  ProProfsChatSDK
//
//  Created by Ajay Mandrawal on 10/10/22.
//


import SwiftUI

struct Screen: View {
    @Binding var chatData: ChatData
    @Binding  var chatSettingData:ChatSettingData!
    @Binding var lastMessageId:String
    @Binding var oldChatData: ChatData!
    @Binding var site_id:String
    @State var showPostChatForm = false
    @State var transcriptId = 0
    var resetChatData : () -> ()
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack{
            if(chatSettingData.chat_status.status == ChatStatusType.IDLE.rawValue || chatSettingData.chat_status.status == ChatStatusType.CLOSED.rawValue){
                FormScreen( chatSettingData: $chatSettingData, site_id: $site_id, backIconClick:{
                    presentationMode.wrappedValue.dismiss()
                }, showPostChatForm: $showPostChatForm, transcriptId: $transcriptId).onAppear(){
                    resetChatData().self
                }
            } else {
                ChatScreen(chatData: $chatData, oldChatData:   $oldChatData, lastMessageId: $lastMessageId, chatSettingData: $chatSettingData, site_id: $site_id,backIconClick:{
                    presentationMode.wrappedValue.dismiss()
                }, showPostChatForm: {transcriptId in
                    self.transcriptId = Int(transcriptId)
                    showPostChatForm = !showPostChatForm
                })
            }
        }
    }
}
