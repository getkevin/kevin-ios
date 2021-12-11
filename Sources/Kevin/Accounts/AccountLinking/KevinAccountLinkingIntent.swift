//
//  KevinAccountLinkingIntent.swift
//  kevin.iOS
//
//  Created by Edgar Žigis on 8/1/21.
//  Copyright © 2021 kevin.. All rights reserved.
//

import Foundation

internal class KevinAccountLinkingIntent: IKevinIntent {
    
    internal class Initialize: KevinAccountLinkingIntent {
        
        let configuration: KevinAccountLinkingConfiguration
        
        init(configuration: KevinAccountLinkingConfiguration) {
            self.configuration = configuration
        }
    }

    internal class HandleLinkingCompleted: KevinAccountLinkingIntent {
        
        public let url: URL
        public let error: Error?
        public let configuration: KevinAccountLinkingConfiguration
        
        init(url: URL, error: Error?, configuration: KevinAccountLinkingConfiguration) {
            self.url = url
            self.error = error
            self.configuration = configuration
        }
    }
}
