//
//  ReminderInfoModel.swift
//  iRemind
//
//  Created by Vijay Subrahmanian on 03/06/15.
//  Copyright (c) 2015 Vijay Subrahmanian. All rights reserved.
//

import Foundation

class ReminderInfoModel: NSObject, NSCoding {
    
    var name = ""
    var details = ""
    var time: NSDate?
    
    override init() {
        super.init()
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        self.init()
        self.name = aDecoder.decodeObjectForKey("nameKey") as! String
        self.details = aDecoder.decodeObjectForKey("detailsKey") as! String
        self.time = aDecoder.decodeObjectForKey("timeKey") as? NSDate
    }

    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.name, forKey: "nameKey")
        aCoder.encodeObject(self.details, forKey: "detailsKey")
        aCoder.encodeObject(self.time, forKey: "timeKey")
    }
}