//
//  Video.swift
//  BaseProjectSwift
//
//  Created by Bé Gạo on 25/3/25.
//
import Foundation
import UIKit

struct Video: Identifiable, Hashable {
    var id: UUID = .init()
    var fileURL: URL
    var thumbnail: UIImage?
}

let files = [
    URL(fileURLWithPath: Bundle.main.path(forResource: "Video_1", ofType: "mp4") ?? ""),
    URL(fileURLWithPath: Bundle.main.path(forResource: "Video_2", ofType: "mp4") ?? ""),
    URL(fileURLWithPath: Bundle.main.path(forResource: "Video_3", ofType: "mp4") ?? ""),
    URL(fileURLWithPath: Bundle.main.path(forResource: "Video_4", ofType: "mp4") ?? ""),
    URL(fileURLWithPath: Bundle.main.path(forResource: "Video_5", ofType: "mp4") ?? ""),
    URL(fileURLWithPath: Bundle.main.path(forResource: "Video_6", ofType: "mp4") ?? "")
    
].compactMap({ Video(fileURL: $0)})
