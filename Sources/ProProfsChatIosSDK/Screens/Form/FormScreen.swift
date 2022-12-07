//
//  FormScreen.swift
//  ProProfsChatSDK
//
//  Created by Ajay Mandrawal on 06/10/22.
//

import SwiftUI

struct FormScreen: View {
    @Binding  var chatSettingData:ChatSettingData!
    @Binding var site_id:String
    @State private var isOperatorOnline = false
    @State private var formType: FormType?
    @State private var formFields:[ChatFormField] = []
    @State private var formTexts:ChatFormText?
    @State private var dropdownList:[String]?
    @State private var dropdownIndex:Int?  = -1
    @State private var showDropdown:Bool = false
    @State private var showBackdrop:Bool = false
    @State private var showSpinner:Bool = false
    @State private var showAlertMessage: Bool = false
    @State private var scale = 1.0
    var backIconClick : () -> ()
    @State private var showCloseButton = false
    let preference = UserDefaults.standard
    @Binding var showPostChatForm:Bool
    @Binding var transcriptId:Int
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack{
            HeaderView(navigationTitle: chatSettingData.chat_header_text.chat_online_text, headerBackgroundColor: chatSettingData.chat_style.chead_color, showCloseButton:$showCloseButton, onBackIconClick: {
                backIconClick()
            },showCloseChatPopUp: {})
            ZStack{
                VStack{
                    ScrollView(){
                        
                        Text(formTexts?.beforesubmit ?? "")
                            .font(.system(size: 16))
                            .foregroundColor(Color(hexString: Constants.FORM_FIELD_TITLE_COLOR))
                            .multilineTextAlignment(.center)
                            .padding(.top,10)
                            .padding(.bottom,2)
                        if(formType?.rawValue == FormType.POST_CHAT.rawValue){
                            Rating(fill_color: chatSettingData.chat_style.chead_color, onRatingSelected:{_ in }, site_id: $site_id, chatSettingData: $chatSettingData)
                        }
                        
                        ForEach(formFields.indices,id: \.self){
                            index  in
                            FormFieldTitle(title: $formFields[index].fld_name, type: $formFields[index].fld_type)
                            if(formFields[index].fld_type == FormFieldType.TEXT.rawValue){
                                TextField("",text: $formFields[index].value.toUnwrapped(defaultValue: ""))
                                    .textFieldStyle(.roundedBorder).onTapGesture(perform: {
                                        formFields[index].showErrorMsg = false
                                    })
                                    .autocapitalization(formFields[index].isemail == "Y" ? .none : .sentences)
                                    .keyboardType(formFields[index].isemail == "Y" ? .emailAddress : .default)
                            }
                            else if(formFields[index].fld_type == FormFieldType.TEXTAREA.rawValue){
                                TextEditor(text: $formFields[index].value.toUnwrapped(defaultValue:""))
                                    .border(Color(hexString: Constants.TEXTAREA_BORDER_COLOR), width: 1)
                                    .frame(height:100).onTapGesture(perform: {
                                        formFields[index].showErrorMsg = false
                                    })
                                
                            }
                            else if(formFields[index].fld_type == FormFieldType.RADIO.rawValue){
                                
                                ForEach(formFields[index].sel_item.split(separator: ","), id: \.self) { option in
                                    RadioButton(label: String(option), value: $formFields[index].value)
                                        .padding(.top,4)
                                        .padding(.bottom,4)
                                        .onTapGesture {
                                            formFields[index].value =  String(option)
                                            formFields[index].showErrorMsg = false
                                        }
                                }
                                
                            }
                            else if(formFields[index].fld_type == FormFieldType.DROPDOWN.rawValue){
                                Button (action: {
                                    dropdownList =  formFields[index].sel_item.split(separator: ",").map{
                                        String($0)
                                    }
                                    dropdownIndex = index
                                    formFields[index].showErrorMsg = false
                                    showBackdrop = true
                                    showDropdown = true
                                }, label: {
                                    HStack{
                                        Text(String(formFields[index].value ?? "Select")).padding(8).foregroundColor(Color(hexString: Constants.FORM_FIELD_TITLE_COLOR))
                                        Spacer()
                                    }
                                    
                                })  .border(Color(hexString: Constants.TEXTAREA_BORDER_COLOR), width: 1)
                                    .cornerRadius(4)
                                
                            }
                            else {
                                ForEach(formFields[index].sel_item.split(separator: ","), id: \.self) { option in
                                    Checkbox(label: String(option), value: $formFields[index].value.toUnwrapped(defaultValue:""), showErrorMsg: $formFields[index].showErrorMsg)
                                        .padding(.top,4)
                                        .padding(.bottom,4)
                                }
                                
                            }
                            
                            if(formFields[index].showErrorMsg ?? false){
                                ErrorMessage(message: formFields[index].jsmsg)
                            }
                            
                        }
                        
                        Button(action: {
                            if(validateForm()){
                                if(formType == FormType.PRE_CHAT){
                                    submitPreChatForm()
                                } else if(formType == FormType.OFFLINE){
                                    submitOfflineForm()
                                } else if(formType == FormType.POST_CHAT) {
                                    submitPostChatForm(transcriptId: transcriptId)
                                }
                                
                            }
                        }, label: {
                            Spacer()
                            Text(formTexts?.txt_submit ?? "Submit")
                                .foregroundColor(.white)
                                .fontWeight(Font.Weight.medium)
                                .padding(.top, 7)
                                .padding(.bottom, 7)
                            Spacer()
                        }).background(Color(hexString: chatSettingData.chat_style.chead_color))
                            .cornerRadius(3)
                            .padding(EdgeInsets(top: 20, leading: 0, bottom: 0, trailing: 0))
                        
                        
                    }.onChange(of: chatSettingData.operator_status){ newValue in
                        getFormTypeData()
                    }
                    .onAppear(){
                        getFormTypeData()
                    }
                    
                    .padding(.leading, 20)
                    .padding(.trailing, 20)
                    .padding(.bottom, 20)
                    .padding(.top, 20)
                    FooterView()
                }
                
                if showBackdrop {
                    ZStack{
                        VStack{}
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(.gray)
                            .opacity(0.3)
                        if showDropdown {
                            Dropdown(selectedValue: $showDropdown,dropdwonList:dropdownList ?? [],  onItemSelected: {item in
                                showBackdrop = false
                                if(dropdownIndex != -1){
                                    formFields[dropdownIndex!].value = item
                                }
                                
                            }).background(Color.white)
                        }
                        if showSpinner {
                            ProgressView()
                        }
                        if showAlertMessage {
                            
                            AlertMessage(message_title: chatSettingData.chat_header_text.aftermail,
                                         button_left_text: "",
                                         button_right_text: "OK",
                                         onButtonLeftClick: {},
                                         onButtonRightClick: {
                                showAlertMessage = false
                                showBackdrop = false
                                backIconClick()
                            })
                        }
                    }
                    
                    .onTapGesture{
                    }
                }
            }
           
            
        }
    }
    
    
    func getFormTypeData(){
        if(showPostChatForm){
            formType = FormType.POST_CHAT
        } else {
            isOperatorOnline = chatSettingData.operator_status.isEmpty ? false : true
            if(isOperatorOnline){
                formType = FormType.PRE_CHAT
            } else {
                formType = FormType.OFFLINE
            }
        }
        
        formFields = getFormInputFields(data: chatSettingData.chat_form_field, formType: formType ?? FormType.OFFLINE)
        formTexts = getFormTextFields(data: chatSettingData.chat_form_text, formType: formType ?? FormType.OFFLINE)
    }
    
    
    func validateForm() -> Bool{
        var isValid = true
        $formFields.forEach{
            $field in
            if(field.js == "Y"){
                if(field.isemail == "Y"){
                    if(field.value == nil || field.value!.isEmpty){
                        field.showErrorMsg = true
                        isValid = false
                    } else if(!isValidEmail(field.value!)){
                        field.showErrorMsg = true
                        isValid = false
                    } else {
                        field.showErrorMsg = false
                    }
                }  else {
                    if(field.value == nil || field.value!.isEmpty){
                        field.showErrorMsg = true
                        isValid = false
                    } else {
                        field.showErrorMsg = false
                    }
                }
            }
            
        }
        return isValid
    }
    
    func submitPreChatForm(){
        showBackdrop = true
        showSpinner = true
        let form_params =  getFormParams(chatFormField: formFields, field_tag: "pp_fld_")
        preference.set(form_params.name, forKey: "visitor_name")
        preference.set(form_params.email, forKey: "visitor_email")
        let params:KeyValuePairs = [
            "ProProfs_session":String(chatSettingData.proprofs_session ),
            "ProProfs_language_id":String(chatSettingData.proprofs_language_id ),
            "ProProfs_site_id":site_id,
            "pp_operator_label":"0",
            "pp_group_label":"0",
            "pp_department_label":"0",
            "pp_visitor_email":form_params.email,
            "pp_visitor_name":form_params.name,
            "ProProfs_field_counter":formFields.count,
            "ProProfs_device_id":"",
            "AccountCode":String(chatSettingData.chat_inner_account ),
            "DepartmentRouting":"",
            "ProProfs_Chat_l2s_cv":"https://www.proprofschat.com/chat-page/?id=\(String(chatSettingData.proprofs_session ))",
            "ProProfs_Current_URL_manual":""
            
        ] as KeyValuePairs<String, Any>
        
        var body:String = ""
        
        for param in params {
            body.append("\(param.key)=\(param.value)&")
        }
        
        for param in form_params.dynamicParams {
            body.append("\(String(param.first!.key))=\(String(param.first?.value ?? ""))&")
        }
        guard let url =  URL(string: "\(currentEnvironment())\(ApiUrls.PreChatUrl.rawValue)") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = body.dropLast().data(using: .utf8)
        
        URLSession.shared.dataTask(with: request) { (data , response, error) in
            
        }.resume()
    }
    
    func submitPostChatForm(transcriptId : Int){
        showBackdrop = true
        showSpinner = true
        let form_params =  getFormParams(chatFormField: formFields, field_tag: "post_pp_fld_")
        preference.set(form_params.name, forKey: "visitor_name")
        preference.set(form_params.email, forKey: "visitor_email")
        let params:KeyValuePairs = [
            "proprofs_transcript":transcriptId,
            "post_ProProfs_rating":String(chatSettingData.proprofs_language_id ),
            "post_ProProfs_session":chatSettingData.proprofs_session,
            "post_ProProfs_language_id":chatSettingData.proprofs_language_id,
            "post_ProProfs_site_id":site_id
            
        ] as KeyValuePairs<String, Any>
        
        var body:String = ""
        
        for param in params {
            body.append("\(param.key)=\(param.value)&")
        }
        
        for param in form_params.dynamicParams {
            body.append("\(String(param.first!.key))=\(String(param.first?.value ?? ""))&")
        }
        let params2:KeyValuePairs = [
            "post_ProProfs_field_counter":formFields.count,
            "AccountCode":String(chatSettingData.chat_inner_account ),
        ] as KeyValuePairs<String, Any>
        
        
        for param in params2 {
            body.append("\(param.key)=\(param.value)&")
        }
        guard let url =  URL(string: "\(currentEnvironment())\(ApiUrls.PostChatUrl.rawValue)") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = body.dropLast().data(using: .utf8)
        
        URLSession.shared.dataTask(with: request) { (data , response, error) in
            
        }.resume()
        showSpinner = false
        presentationMode.wrappedValue.dismiss()
    }
    
    func submitOfflineForm(){
        showBackdrop = true
        showSpinner = true
        let form_params =  getFormParams(chatFormField: formFields, field_tag: "off_pp_fld_")
        preference.set(form_params.name, forKey: "visitor_name")
        preference.set(form_params.email, forKey: "visitor_email")
        let params1:KeyValuePairs = [
            "pp_time_tracker_status":"0",
            "off_ProProfs_session":String(chatSettingData.proprofs_session),
            "off_ProProfs_language_id":String(chatSettingData.proprofs_language_id),
            "off_ProProfs_site_id":site_id,
            "pp_department_offline_label":"0",
            "off_pp_visitor_name":form_params.name,
            "off_pp_visitor_email":form_params.email,
        ] as KeyValuePairs<String, Any>
        
        var body:String = ""
        for param in params1 {
            body.append("\(param.key)=\(param.value)&")
        }
        
        for param in form_params.dynamicParams {
            body.append("\(String(param.first!.key))=\(String(param.first?.value ?? ""))&")
        }
        
        let params2:KeyValuePairs = [
            "off_ProProfs_field_counter":formFields.count,
            "ProProfs_device_id":"",
            "AccountCode":String(chatSettingData.chat_inner_account ),
            "DepartmentRouting1":"0",
            "ProProfs_Current_URL_manual":"chat_sdk"
            
        ] as KeyValuePairs<String, Any>
        
        
        for param in params2 {
            body.append("\(param.key)=\(param.value)&")
        }
        
        guard let url =  URL(string: "\(currentEnvironment())\(ApiUrls.OfflineUrl.rawValue)") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = body.dropLast().data(using: .utf8)
        
        URLSession.shared.dataTask(with: request) { (data , response, error) in
            showSpinner = false
            showAlertMessage = true
        }.resume()
    }
}

//struct FormScreen_Previews: PreviewProvider {
//    static var previews: some View {
//        FormScreen()
//    }
//}
