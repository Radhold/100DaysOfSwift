//
//  Note.swift
//  Milestone10-12
//
//  Created by Yaroslav Fomenko on 24.08.2021.
//

import UIKit

class Note: NSObject, NSCoding {
    var text: String
    var image: String
    
    init(text: String, image: String) {
        self.text = text
        self.image = image
    }
    
    required init(coder aDecoder: NSCoder) {
        text = aDecoder.decodeObject(forKey: "text") as? String ?? ""
        image = aDecoder.decodeObject(forKey: "image") as? String ?? ""
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(text, forKey: "text")
        aCoder.encode(image, forKey: "image")
    }
}
