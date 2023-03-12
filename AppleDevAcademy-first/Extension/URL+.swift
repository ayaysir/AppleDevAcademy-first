//
//  URL+.swift
//  AppleDevAcademy-first
//
//  Created by 윤범태 on 2023/03/12.
//

import Foundation

extension URL {
    func fileSize() -> Double {
        var fileSize: Double = 0.0
        var fileSizeValue = 0.0
        try? fileSizeValue = (self.resourceValues(forKeys: [URLResourceKey.fileSizeKey]).allValues.first?.value as! Double?)!
        if fileSizeValue > 0.0 {
            fileSize = (Double(fileSizeValue) / (1024 * 1024))
        }
        return fileSize
    }
    
    func checkFileExist() -> Bool {
        return FileManager.default.fileExists(atPath: self.path)
    }
}
