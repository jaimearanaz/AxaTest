//
//  HTTPResponseMocked.swift
//  AxaTestTests
//
//  Created by Jaime Aranaz on 2/6/22.
//

import XCTest
import Mockingjay

class HTTPResponseMocked: XCTest {
 
    func setJsonResponse(fromFile name: String, httpCode: Int) {
        
        if let data = readJson(fromFileName: name) {
            let download = Download.content(data)
            let httpResponse = http(httpCode, headers: nil, download: download)
            stub(everything, httpResponse)
        } else {
            XCTFail("it could not read JSON file named \(name).json")
        }
    }
    
    func setJsonResponse(fromFile name: String) {
        
        if let data = readJson(fromFileName: name) {
            stub(everything, jsonData(data))
        } else {
            XCTFail("it could not read JSON file named \(name).json")
        }
    }

    private func readJson(fromFileName name: String) -> Data? {
        
        let bundle = Bundle(for: type(of: self))
        if let path = bundle.path(forResource: name, ofType: "json") {
            let fileManager = FileManager.default
            let data = fileManager.contents(atPath: path)
            return data
        } else {
            return nil
        }
    }
}
