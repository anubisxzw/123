//
//  ViewController.swift
//  testDwr824
//
//  Created by xie hu on 2016/12/15.
//  Copyright © 2016年 xie hu. All rights reserved.
//

import UIKit
import CoreData
import Alamofire
import SwiftyJSON

class ViewController: UIViewController {

    @IBOutlet var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.delPerson()
        self.storePerson(name: "dongwangrui", tel: "18961789008")
        self.storePerson(name: "wangjiahuan", tel: "18262251772")
        self.updatePerson()
        self.getPerson()
        self.getWebData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getWebData(){
        Alamofire.request("https://api.500px.com/v1/photos").responseJSON { (DataResponse) in
            if let resValue = DataResponse.result.value{
                let json = JSON.init(rawValue: resValue)
                print("json:\(json)")
                
                let error = json?["error"].string
                let status = json?["status"].int
                
                print("error:\(error)")
                print("status:\(status)")
                
                let context = self.getContext()
                
                let request = NSFetchRequest<NSFetchRequestResult>(entityName: "ErrorInfo")
                
                do{
                    let rels = try context.fetch(request) as! [ErrorInfo]
                    for rel in rels{
                        context.delete(rel)
                    }
                    try context.save()
                    print("Error info all deleted")
                }catch{
                    print(error)
                }
                
                let entity = NSEntityDescription.entity(forEntityName: "ErrorInfo", in: context)
                let person = NSManagedObject(entity: entity!, insertInto: context)
                
                person.setValue(error, forKey: "error")
                person.setValue(status, forKey: "status")
                
                do {
                    try context.save()
                    print("error:\(error)  status:\(status)")
                    print("saved")
                }catch{
                    print(error)
                }
                
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ErrorInfo")
                
                do {
                    let searchResults = try context.fetch(fetchRequest)
                    print("numbers of \(searchResults.count)")
                    
                    for p in (searchResults as! [ErrorInfo]){
                        print("error:\(p.value(forKey: "error")!)  status:\(p.value(forKey: "status")!)")
                        print(p.objectID)
                    }
                } catch  {
                    print(error)
                }
            }
        }
    }
    
    func getContext () -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    func storePerson(name:String, tel:String){
        let context = getContext()
        let entity = NSEntityDescription.entity(forEntityName: "Person", in: context)
        let person = NSManagedObject(entity: entity!, insertInto: context)
        
        person.setValue(name, forKey: "name")
        person.setValue(tel, forKey: "tel")
        
        do {
            try context.save()
            print("name:\(name)  tel:\(tel)")
            print("saved")
        }catch{
            print(error)
        }
    }
    
    func getPerson(){
        let context = getContext()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Person")
        
        do {
            let searchResults = try context.fetch(fetchRequest)
            print("numbers of \(searchResults.count)")
            
            for p in (searchResults as! [Person]){
                print("name:\(p.value(forKey: "name")!)  tel:\(p.value(forKey: "tel")!)")
                print(p.objectID)
            }
        } catch  {
            print(error)
        }
    }
    
    func delPerson(){
        let context = getContext()
        let predicate = NSPredicate(format: "tel='18961789008'")
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Person")
        request.predicate = predicate
        
        do{
            let rels = try context.fetch(request) as! [Person]
            for rel in rels{
                context.delete(rel)
            }
            try context.save()
            print("18961789008 deleted")
        }catch{
            print(error)
        }
    }
    
    func updatePerson(){
        let context = getContext()
        let predicate = NSPredicate(format: "name='wangjiahuan'")
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Person")
        request.predicate = predicate
        
        do{
            let rels = try context.fetch(request) as! [Person]
            for rel in rels{
                rel.tel = "18961789008"
            }
            try context.save()
            print("wangjiahuan updated")
        }catch{
            print(error)
        }
    }
}

