//
//  List.swift
//  TodayMood
//
//  Created by Kanz on 2020/05/17.
//

import Foundation
/*
 {
   "next": "cD0xNDUx",
   "previous": null,
   "results": [
     {
       "id": 1451,
       "status": 15,
       "simple_summary": "2"
     }
   ]
 }
 */
struct List<T>: ModelType where T: ModelType {
    let next: String?
    let previous: String?
    let results: [T]
    
    enum CodingKeys: String, CodingKey {
        case next
        case previous
        case results
    }
}
