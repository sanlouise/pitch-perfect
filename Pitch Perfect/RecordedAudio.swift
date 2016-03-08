//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Sandra Adams-Hallie on Mar/7/16.
//  Copyright © 2016 Sandra Adams-Hallie. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject{
    var filePathUrl: NSURL!
    var title: String!
    
    init(filePathUrl: NSURL, title: String) {
        
        self.filePathUrl = filePathUrl
        self.title = title
    }

}

