//
//  FileReader.swift
//  SpaceInvaders
//
//  Created by administrator on 23.03.2021.
//  Copyright © 2021 administrator. All rights reserved.
//

import Foundation

class FileReader {
    private func readLocalFile(forName name: String) -> Data? {
        do {
            if let bundlePath = Bundle.main.path(forResource: name,
                                                 ofType: "json"),
                let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
                return jsonData
            }
        } catch {
            print(error)
        }
        
        return nil
    }
    private func parse(jsonData: Data) -> JsonData? {
        var decodedData = JsonData()
        do {
            decodedData = try JSONDecoder().decode(JsonData.self,
                                                       from: jsonData)
            return decodedData
        } catch {
            print("decode error")
        }
        return decodedData
    }
    func read(path : String) -> JsonData?{
        if let localData = self.readLocalFile(forName: path) {
            let jsonData = self.parse(jsonData: localData)
            return jsonData
        }
        return nil
    }
}
