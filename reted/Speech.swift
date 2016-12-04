//
//  Speech.swift
//  reted
//
//  Created by seojungwon on 2016. 11. 29..
//  Copyright © 2016년 seojungwon. All rights reserved.
//

import UIKit

class Speech: NSObject {
    
    var name : String
    var duration: String
    var embed: String
    var grade: Int
    var img: String
    var rated1 : String
    var rated2 : String
    var title : String
    var views : String
    var releaseDate : String
    
    init(name: String, duration:String, embed: String, grade:Int, img:String, rated1: String, rated2: String,  title: String, views: String, releaseDate: String) {
        self.name = name
        self.duration = duration
        self.embed = embed
        self.grade = grade
        self.img = img
        self.rated1 = rated1
        self.rated2 = rated2
        self.title = title
        self.views = views
        self.releaseDate = releaseDate
    }
    
    convenience override init() {
        self.init(name: "", duration: "", embed: "", grade: 1, img: "", rated1: "", rated2: "", title: "", views: "", releaseDate: "")
    }
}
