//
//  ChatSettingData.swift
//  ChatDemo
//
//  Created by Ajay Mandrawal on 15/09/22.
//

import Foundation

struct ChatSettingData: Codable {
    let site_setting: SiteSettings
    var chat_header_text: ChatHeaderText
    let chat_style: ChatStyle
    let chat_style_extra: ChatStyleExtra
    let chat_form_text: [ChatFormText]
    let chat_form_field: [ChatFormField]
    let chat_inner_account: String
    let proprofs_language_id: String
    let proprofs_session: String
    let ProProfs_accounts: String
    var operator_status: [Operator]
    var chat_status: ChatStatus
    let static_language: StaticLanguage?
    let _ProProfs_SDK_Status: String
}
