//
//  ViewController.swift
//  PlanFrame
//
//  Created by Jkookoo on 11/05/2019.
//  Copyright © 2019 Jkookoo. All rights reserved.
//

import UIKit

class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, sendBackDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    var plans: [Plan] = []
    let cellIdentifier = "cell"
    func dataRemove(index: Int) {
        self.plans.remove(at: index)
    }
    
    func dataReceived(data: Plan) {
        self.plans.insert(data, at: 0)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.plans.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier, for: indexPath)
        let plan = self.plans[indexPath.row]
        cell.textLabel?.text = plan.title
        return cell
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        UserDefaults.standard.set(try? PropertyListEncoder().encode(self.plans), forKey: "plans")
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let data = UserDefaults.standard.value(forKey: "plans") as? Data {
            //try! 수정해보기
            self.plans = try! PropertyListDecoder().decode([Plan].self, from: data)
        }
//        guard let userDefault = UserDefaults.standard.array(forKey: "plans") as? [Plan] else {
//            return
//        }
//        self.plans = userDefault
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "planSegue" {
            guard let contentViewController: ContentViewController = segue.destination as? ContentViewController else {
                return
            }
            guard let cell: UITableViewCell = sender as? UITableViewCell  else {
                return
            }
            guard let indexPath = self.tableView.indexPath(for: cell) else {
                return
            }
            contentViewController.sendBackDelegate = self
            let plan = self.plans[indexPath.row]
            contentViewController.oldPlan = plan
            if let time = plan.recentCorrectTime {
                contentViewController.savedTime = time
                contentViewController.index = indexPath.row
            }
//            contentViewController.plan.title =
        }
        
        if segue.identifier == "newPlanSegue" {
            guard let contentViewController: ContentViewController = segue.destination as? ContentViewController else {
                return
            }
            contentViewController.sendBackDelegate = self
        }
    }
}

