//
//  MemoEntity+CoreDataProperties.swift
//  memo
//
//  Created by 박기찬 on 2018. 4. 1..
//  Copyright © 2018년 박기찬. All rights reserved.
//
//

import Foundation
import CoreData


extension MemoEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MemoEntity> {
        return NSFetchRequest<MemoEntity>(entityName: "MemoEntity")
    }

    @NSManaged public var content: String?
    @NSManaged public var date: NSDate?

}
