//
//  SwiftLoad.swift
//  TUIVideoSeat
//
//  Created by WesleyLei on 2022/9/23.
//  Copyright © 2022 Tencent. All rights reserved.
//

import Foundation
import TUICore

extension NSObject {
    @objc class func swiftLoad() {
        let _ = TUICallKit.createInstance()

        TUICore.registerService(TUICore_TUICallingService, object: TUICallKitService.instance)
        
        TUICore.registerService(TUICore_TUIAudioMessageRecordService, object: TUIAudioMessageRecordService.instance)
        
        TUICore.registerExtension(TUICore_TUIChatExtension_NavigationMoreItem_MinimalistExtensionID,
                                  object: TUICallKitExtension.instance)
        TUICore.registerExtension(TUICore_TUIChatExtension_InputViewMoreItem_ClassicExtensionID,
                                  object: TUICallKitExtension.instance)
        TUICore.registerExtension(TUICore_TUIContactExtension_FriendProfileActionMenu_ClassicExtensionID,
                                  object: TUICallKitExtension.instance)
        TUICore.registerExtension(TUICore_TUIContactExtension_FriendProfileActionMenu_MinimalistExtensionID,
                                  object: TUICallKitExtension.instance)
        TUICore.registerExtension(TUICore_TUIGroupExtension_GroupInfoCardActionMenu_MinimalistExtensionID,
                                  object: TUICallKitExtension.instance)
        
        TUICore.registerObjectFactory(TUICore_TUICallingObjectFactory, objectFactory: TUICallKitObjectFactory.instance)
        
    }
}
