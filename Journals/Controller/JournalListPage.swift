//
//  UITableTableViewController.swift
//  Journals
//
//  Created by Chen Yi-Wei on 2019/5/13.
//  Copyright © 2019 Chen Yi-Wei. All rights reserved.
//

import UIKit
import CoreData

class JournalListPage: UITableViewController {

    let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext

    var journals: [Journal] = []

    lazy var addButton: UIBarButtonItem = {

        let button = UIButton(type: .custom)
        button.addTarget(self, action: #selector(addNewJournal), for: .touchUpInside)
        button.setImage(UIImage(named: "icon_plus"), for: .normal)
        button.tintColor = UIColor(r: 237, g: 96, b: 81, a: 1)

        let barButton = UIBarButtonItem(customView: button)

        return barButton

    }()

    private let titleItem: UIBarButtonItem = {

        let label = UILabel()
        label.text = "My Journals"
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.textColor = UIColor(r: 67, g: 87, b: 97, a: 1)

        let barButton = UIBarButtonItem(customView: label)

        return barButton
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.setRightBarButton(addButton, animated: true)
        navigationItem.setLeftBarButton(titleItem, animated: true)

        tableView.register(JournalCell.self, forCellReuseIdentifier: "JournalCell")

        tableView.separatorStyle = .none

        loadJournals()

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        loadJournals()
    }

    @objc func addNewJournal() {

        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)

        if let newVC = storyboard.instantiateViewController(withIdentifier: "NewJournalPage") as? NewJournalPage {

            present(newVC, animated: true, completion: nil)

        }
    }

    func loadJournals() {

        let request: NSFetchRequest<Journal> = Journal.fetchRequest()

        let sort = NSSortDescriptor(key: "date", ascending: false)

        request.sortDescriptors = [sort]

        do {

            journals = try context!.fetch(request)

            tableView.reloadData()

        } catch {

            print(error)

        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return journals.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "JournalCell", for: indexPath) as? JournalCell else { fatalError("Please check cell's id") }

        cell.journal = journals[indexPath.row]

        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return 212
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {


        guard self.journals.count > 0 else {
            return false
        }

        return true
    }

    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {

        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { [weak self] _, indexPath in

            guard let self = self else { return }

            self.context?.delete(self.journals[indexPath.row])

            self.journals.remove(at: indexPath.row)

            do {

                try self.context?.save()

            } catch {

                print(error)

            }

            tableView.deleteRows(at: [indexPath], with: .fade)

        }

        return [delete]

    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)

        if let newVC = storyboard.instantiateViewController(withIdentifier: "NewJournalPage") as? NewJournalPage {

            guard let cell = tableView.cellForRow(at: indexPath) as? JournalCell else { return }

            newVC.index = indexPath.row

            newVC.journal = cell.journal

            present(newVC, animated: true, completion: nil)

        }
    }



    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }


    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
