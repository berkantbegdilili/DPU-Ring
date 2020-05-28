//
//  UlasimData.swift
//  KutahyaUlasim
//
//  Created by Berkant Beğdilili on 27.05.2020.
//  Copyright © 2020 Berkant Beğdilili. All rights reserved.
//

import Foundation
import SwiftSoup

class UlasimData{
    
    var unparsed:[String] = [String]()
    var parsed1:[String.SubSequence]? = [String.SubSequence]()
    var parsed2:[String.SubSequence]? = [String.SubSequence]()
    var today:String?
    var clock:String?
    
    func dateFormatter(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = .init(format: "EEEE")
        today = dateFormatter.string(from: Date()).lowercased()
        
        dateFormatter.dateFormat = .init(format: "HH:mm")
        clock = dateFormatter.string(from: Date())
    }
    
    func getData(){
          
          guard let url = URL(string: "http://www.kutahya.bel.tr/ulasim2mobil.asp?islem=saat&id=29") else {
              print("Geçerli bir URL girmediniz!")
              return
          }
          
          do {
              let html = try String(contentsOf: url, encoding: .utf8)
              let element: Elements = try SwiftSoup.parse(html).select("tr")
              
              for link:Element in element.array(){
                  try unparsed.append(link.getElementsContainingText(":").text())
              }
          
          } catch Exception.Error(let type, let message) {
              print(type)
              print(message)
          }catch{
              print(error)
          }
      }
      
    func dataParse(){
         
        if !unparsed.isEmpty {

            var i:Int = 1
            
            while i<unparsed.count{
                
                if unparsed[i].isEmpty{
                    unparsed.remove(at: i-1)
                    i += 1
                    continue
                }
                
                
                let temp = unparsed[i].split(separator: " ")
                                          
                if today! == "saturday"{
                    self.parsed1?.append(temp[6])
                    self.parsed2?.append(temp[17])
                }else if today! == "sunday"{
                    self.parsed1?.append(temp[8])
                    self.parsed2?.append(temp[19])
                }else{
                    self.parsed1?.append(temp[0])
                    self.parsed2?.append(temp[11])
                }
                
                i += 1
            }
            
        }
    }
    
    
}
