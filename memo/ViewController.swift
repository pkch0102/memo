//
//  ViewController.swifts
//  memo
//
//  Created by 박기찬 on 2018. 3. 25..
//  Copyright © 2018년 박기찬. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableview: UITableView!
    
    var memoList: [MemoEntity] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getMemoList()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
        let more = UITableViewRowAction(style: .normal, title: "Delete") { action, index in
            let dialog = UIAlertController(title: "알람", message: "삭제하시겠습니까?", preferredStyle: .alert)
            let action = UIAlertAction(title: "네", style: UIAlertActionStyle.default){ (action: UIAlertAction) -> Void in
                let memo: MemoEntity = self.memoList[editActionsForRowAt.row]
                self.deleteMemo(memo)
                self.getMemoList()
            }
            let action2 = UIAlertAction(title: "아니요", style: UIAlertActionStyle.default)
            
            dialog.addAction(action)
            dialog.addAction(action2)
            self.present(dialog, animated: true, completion: nil)
        }
        more.backgroundColor = .red
        
        
        return [more]
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.memoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: memolistCell = tableView.dequeueReusableCell(withIdentifier: "memolistCell", for: indexPath) as! memolistCell
        cell.momecontent.tag = indexPath.row
        let memo: MemoEntity = self.memoList[indexPath.row]
        cell.momecontent.text = memo.content
        cell.memodate.text = self.getDateString(date: memo.date!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let memo: MemoEntity = self.memoList[indexPath.row]
       
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller: memodetail = storyboard.instantiateViewController(withIdentifier: "memodetail") as! memodetail
        controller.acceptmemo(memo)
        
        self.present(controller, animated: true, completion: nil)
    }
    
    func getContext() -> NSManagedObjectContext {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    func getMemoList() {
        let memoListFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "MemoEntity")
        let sort = NSSortDescriptor(key: #keyPath(MemoEntity.date), ascending: false)
        memoListFetch.sortDescriptors = [sort]
        
        do {
            self.memoList = try getContext().fetch(memoListFetch) as! [MemoEntity]
            self.tableview.reloadData()
        } catch {
            fatalError("Failed to fetch employees: \(error)")
        }
    }
    
    func getDateString(date: NSDate) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.string(from: date as Date)
    }
    
    func deleteMemo(_ memo: MemoEntity) {
        let context = getContext()
        context.delete(memo)
        
        do {
            try context.save()
        }catch let error as NSError {
            
        }
    }
}


