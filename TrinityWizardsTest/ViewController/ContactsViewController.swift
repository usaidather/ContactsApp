//
//  ViewController.swift
//  TrinityWizardsTest
//
//  Created by Usaid Ather on 20/08/2022.
//

import UIKit

class ContactsViewController: UIViewController, SaveContactDelegate {
    
    @IBOutlet weak var contactsTableView: UITableView!
    
    let refreshControl = UIRefreshControl()
    var contactList : [Contact] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //initializing functions
        registerTableViewCells()
        addRefreshControll()
        fetchData()
    }
    
    //MARK: - Register Table View Cell
    
    private func registerTableViewCells() {
        let contactsCell = UINib(nibName: "ContactsTableViewCell",
                                 bundle: nil)
        contactsTableView.register(contactsCell,
                                   forCellReuseIdentifier: "ContactsTableViewCell")
    }
    
    //MARK: - Custom Helping methods
    
    // fetch local contact from reloading data.
    private func fetchData(){
        let jsonData = readLocalJSONFile(forName: "data")
        if let data = jsonData {
            if let contactsList = parse(jsonData: data) {
                self.contactList = contactsList
            }
        }
        self.contactsTableView.reloadData()
        refreshControl.endRefreshing()
        
    }
    
    // reading json file from local
    func readLocalJSONFile(forName name: String) -> Data? {
        do {
            if let filePath = Bundle.main.path(forResource: name, ofType: "json") {
                let fileUrl = URL(fileURLWithPath: filePath)
                let data = try Data(contentsOf: fileUrl)
                return data
            }
        } catch {
            print("error: \(error)")
        }
        return nil
    }
    
    //    parsing json data from local file...
    func parse(jsonData: Data) -> [Contact]? {
        do {
            let decodedData = try JSONDecoder().decode([Contact].self, from: jsonData)
            return decodedData
        } catch {
            print("error: \(error)")
        }
        return nil
    }
    
    // adding refresh controll...
    private func addRefreshControll(){
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        self.contactsTableView.addSubview(refreshControl) // not required when using UITableViewController
        
    }
    
    
    
    //MARK: - Custom Delegates
    
    // delegate function to save updated or new created contact
    func updatedData(contact: Contact?, index: Int?) {
        if let contact = contact, let index = index {
            self.contactList[index] = contact
        }else {
            if let contact = contact {
                self.contactList.append(contact)
            }
        }
        self.contactsTableView.reloadData()
    }
    
    //MARK: - Pull To refresh Action
    
    // Code to refresh table view
    @objc func refresh(_ sender: AnyObject) {
        fetchData()
    }
    
    
    //MARK: - IBActions
    @IBAction func addContactAction(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let contactDetailViewController = storyBoard.instantiateViewController(withIdentifier: "ContactDetailViewController") as! ContactDetailViewController
        contactDetailViewController.delegate = self
        self.navigationController?.pushViewController(contactDetailViewController, animated:true)
    }
    
}
//MARK: - UITABLEVIEW Datasource and Delegate
extension ContactsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.self.contactList.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ContactsTableViewCell") as? ContactsTableViewCell {
            cell.contactName.text = self.contactList[indexPath.row].firstName + " " + self.contactList[indexPath.row].lastName
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let contactDetailViewController = storyBoard.instantiateViewController(withIdentifier: "ContactDetailViewController") as! ContactDetailViewController
        contactDetailViewController.contact = self.contactList[indexPath.row]
        contactDetailViewController.index = indexPath.row
        contactDetailViewController.delegate = self
        self.navigationController?.pushViewController(contactDetailViewController, animated:true)
    }
}


