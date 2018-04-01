//
//  memodetail.swift
//  memo
//
//  Created by 박기찬 on 2018. 3. 28..
//  Copyright © 2018년 박기찬. All rights reserved.
//

import UIKit
import CoreData

class memodetail : UIViewController {
    var flag: Bool = false
    @IBOutlet weak var deletebutton: UIButton!
    @IBOutlet weak var textview: UITextView!
    
    var memo: MemoEntity = MemoEntity()
    
    func acceptmemo (_ memo: MemoEntity){
        self.memo = memo
        flag = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if flag{
            deletebutton.isHidden = false
            self.textview.text = self.memo.content
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func deletebtnclicked(_ sender: UIButton) {
        self.deleteMemo(self.memo)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func backbtnclicked(_ sender: UIButton) {
        let content: String = textview.text
        if flag{
            self.update()
            self.dismiss(animated: true, completion: nil)
        }
        else if !content.isEmpty{
            self.save()
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func save(){
        let context = self.getContext()
        let entityDescription = NSEntityDescription.entity(forEntityName: "MemoEntity", in: context)
        let memo: MemoEntity = NSManagedObject(entity: entityDescription!, insertInto: context) as! MemoEntity
        memo.content = textview.text
        memo.date = NSDate()
        
        do {
            try context.save()
            
        }catch let error as NSError {
            
        }
    }
    
    func update(){
        let context = self.getContext()
        memo.content = textview.text
        memo.date = NSDate()
        
        do{
            try context.save()
        }
        catch let error as NSError {
            
        }
    }
    
    func deleteMemo(_ memo: MemoEntity) {
        let context = getContext()
        context.delete(memo)
        
        do {
            try context.save()
        }catch let error as NSError {
            
        }
    }

    
    func getContext() -> NSManagedObjectContext {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
}
