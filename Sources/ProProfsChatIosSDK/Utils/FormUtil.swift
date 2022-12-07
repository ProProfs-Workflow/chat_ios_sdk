//
//  FormUtil.swift
//  ChatSDK
//
//  Created by Ajay Mandrawal on 16/09/22.
//

import Foundation


func getFormInputFields(data: [ChatFormField], formType:FormType) -> [ChatFormField]{
    return data.filter { ChatFormField in
        ChatFormField.fleg == formType.rawValue
    }
}

func getFormTextFields(data: [ChatFormText], formType: FormType) -> ChatFormText {
    return data.filter { ChatFormText in
        ChatFormText.fleg == formType.rawValue
    }[0]
}

func isValidEmail(_ email: String) -> Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    
    let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailPred.evaluate(with: email)
}

func getFormParams(chatFormField: [ChatFormField], field_tag: String) -> FormSubmitParam{
    let dynamicParam:[KeyValuePairs<String, String>] = []
    var formSubmitParam = FormSubmitParam(name: "", email: "", dynamicParams:dynamicParam )
    for(index, field) in chatFormField.enumerated() {
        if(field.fld_type ==  FormFieldType.TEXT.rawValue){
            if(field.isname == "Y"){
                formSubmitParam.name =  field.value ?? ""
            } else if(field.isemail == "Y"){
                formSubmitParam.email = field.value ?? ""
            } else {
                formSubmitParam.dynamicParams.append(["\(field_tag)\(index + 1)": field.value ?? ""])
            }
        } else {
            formSubmitParam.dynamicParams.append(["\(field_tag)\(index + 1)": field.value ?? ""])
        }
    }
    
    return formSubmitParam
}

func getPostString(body:String, params:[String:Any]) -> String
    {
        var data = [String]()
        for(key, value) in params
        {
            if(key != ""){
                data.append(key + "=\(value)")
            }
           
        }
        return body + data.map { String($0) }.joined(separator: "&")
    }
