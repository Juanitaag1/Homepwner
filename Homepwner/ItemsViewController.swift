//
//  ItemsViewController.swift
//  Homepwner
//
//  Created by juanita aguilar on 4/27/19. 
//  Copyright © 2019 none. All rights reserved.
//testing comment for committing

import Foundation
import UIKit

//ch14 pg 255 have to access the vc's toggleedit button programmatically to let the UINAvBar have a edit button to do instead override the init(coder:) in this controller
class ItemsViewController: UITableViewController{
    
    var itemStore: ItemStore! //unwrap now set this property in the AppDelegate.swift
    
    
    //will let the user add a new item/ row to the table
    //YOU must make sure datasource and UITable aggree on the number of rows by adding
    // a new Item to the ItemStore BEFORE INserting a new row
   // @IBAction func addNewItem(_ sender: UIButton){//This is from previous ch now in ch14 want to use a UIBarButtonItem pg 254 so add line:  @IBAction func addNewItem(_ sender: UIBarButtonItem){    instead
        //Now open mainStoryb and object library to drag a BarButton to right side ItemsVc's navigation bar. Select this bar button and open attributes inspector chand SystmeItem to add
         @IBAction func addNewItem(_ sender: UIBarButtonItem){
        //DELETE THis Section and add code
      /**  //Make a new index path for the 0th section last row
        let lastRow = tableView.numberOfRows(inSection: 0)
        let indexPath = IndexPath(row: lastRow, section: 0)
        
        //Insert this new row into the table
        //YOU MUST MAKE SURE the DataSource Knows to insert a row -
        //YOU must make sure datasource and UITable aggree on the number of rows by adding
        // a new Item to the ItemStore BEFORE INserting a new row
    
        tableView.insertRows(at: [indexPath], with: .automatic)*/
        
        //Create a new item and add it to the store
        let newItem = itemStore.createItem()
        
        //Figure out where that last item is in the array
        if let index = itemStore.allItems.firstIndex(of: newItem){
            let indexPath = IndexPath(row: index, section: 0)
            
            //insert this new row into the table
            tableView.insertRows(at: [indexPath], with: .automatic)
        }
        
            //now go to the ITEMSTORE and and remove code for
        
    }
    
    //will let the user edit the rows/ delete
    //Now go to Storyboard and drag a View above the prototype cell _ Can be any view P196 ch11
    //here is old code to set edit we used navebar in ch14 to do instead Now also remove the toggledit in @Ibction fumc toggledit
   @IBAction func toggleEditingMode(_ sender: UIButton){
        
        //If you are currently in edition mode
        if isEditing{
            //change text of button to inform user of state
            sender.setTitle("Edit", for: .normal)
           
            //turn off Editing mode
            setEditing(false, animated: true)
        
        }else{
            //change text of button to inform user of state
            sender.setTitle("Done", for: .normal)
           
            //Enter editing mode
            setEditing(true, animated: true)
        }
        
    }
    
    //Override the didViewLoad to set the content inset which is the padding for all 4 sides of the scrollView wich the UITableView is a subclass of. will make the cells not underlap the status bar
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Remove code to only have the edit button on nav bar ch14 pg 255
        /**get the height of the status bar
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        
        let insets = UIEdgeInsets(top: statusBarHeight, left: 0, bottom: 0, right: 0)
        
        tableView.contentInset = insets
       tableView.scrollIndicatorInsets = insets */ //here is old code to set edit we used navebar in ch14 to do instead Now also remove the toggledit in @Ibction fumc toggledit
        //tableView.scr/Users/juanitaaguilar/Documents/iOSProgrammingText/Homepwner/Homepwner/ItemsViewController.swiftollIndicatorInsets = insets
        //Because using custom class ItemCell have to tell what the height is of the cell
        
       // tableView.rowHeight = 65
        
        //Dynamic cell height pg 216
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 65
    }
    
    //required func of the UITableViewDataSource Protocol this returns an int for the number of rows in the table a row for each item
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int)-> Int{
        return itemStore.allItems.count
    }
    
    //second required fx the UITableViewDataSource Protocol This is the nth row displays the nth entry in the allItems array. Asks the datasource for a cell to insert in a particular location of the table view.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Create an istance of UITableViewCell, with default appearance
        //dont use if you have the resue code
       // let cell = UITableViewCell(style: .value1, reuseIdentifier: "UITableViewCell")
        
        //Get a row or recycled cell
        //Will check the pool or or quee of cells to see if a cell with the correct reuse identifier already exists. If not a new cell will be created and returned
        //The identifier UITableViewCell was created in the storyBoard by selecting the cell in the ui and the attributes to indtifier and selecting the style to right Detail
       // let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        
        //if using custom ItemCell do this instead of line above to deque a cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemCell
        
        //set the text on the cell with the description of this item
        //that is at the nth index of items, where n = row
        //this cell will appera in on the table view
        let item = itemStore.allItems[indexPath.row]
        
       /** cell.textLabel?.text = item.name
        cell.detailTextLabel?.text = "$\(item.valueInDollars)"*/
        
        //configure the custom cell with the Item
        cell.nameLabel.text = item.name
        cell.serialNumberLabel.text = item.serialNumber
        cell.valueLabel.text = "$ \(item.valueInDollars)"
        
        return cell
    }
    
    //DELETes a row To do a delete 1. ItemStore has to have a delete fx and 2. the VC has to call the
    //TableView.delete
    //The Swipe to delete will work as well with this
    //Will also Diplay an  alert for delete with a actionSheet because it is used to display a
    //list of actions for the user to choose from - pg206
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath:IndexPath){
        
        //if the table view is askeing to commit a delete connamd
        if editingStyle == .delete {
            let item = itemStore.allItems[indexPath.row]
            
            
            ///Display a alert for delete
            let title = "Delete \(item.name)?"
            let message = "Are you sure you want to delete this item?"
            
            let ac = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
            
            let cancelAciton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            ac.addAction(cancelAciton)
            
            let deleteAcion = UIAlertAction(title: "Delete", style: .destructive, handler: {(action) -> Void in
            //remove the item from the store
            self.itemStore.removeItem(item)
            
            //Also remove that row from the table view with an animation
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        })
            
            ac.addAction(deleteAcion)
            //present the the alert controller
            present(ac, animated: true, completion: nil)
       }
    }
    
    //To move the row from one place to another
    //.have to also implement the moveItem fx in the itemStore
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath){
        
        //UPDATE The MODEL
        itemStore.moveItem(from: sourceIndexPath.row, to: destinationIndexPath.row)
    }
    
    //Chapter 13 pg237 passing Data around
    //the segue has to have an identifier
    //segues have 3 properties 1. source/sender viewController 2. Destination Vcontroller 3. seg Identifier
    //the sender -
    //After this go to main storyBoard & select ItemsVC and start ch14
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //if triggered the segue is the showItem segue
        switch segue.identifier {
        case "showItem"?:
            //figure out which row was just tapped
            if let row = tableView.indexPathForSelectedRow?.row {
                //Get the item associated with this row and pass it along
                let item = itemStore.allItems[row]
                let detailViewController = segue.destination as! DetailViewController
        
                detailViewController.item = item
            }
        default:
            preconditionFailure("Unexpected segue identifier.")
        }
        
    }
    
    //ch14 p246 overrideing the viewWillAppear that the UINAvigationController calls on the ItemsVC
    //call tableView.reloadData() to reload with the data passed back from the details view controller in its
    //viewWillDisappear fx 
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    //ch14 pg 255 have to access the vc's toggleedit button programmatically to let the UINAvBar have a edit button to do instead override the init(coder:) in this controller
    //Now can go to storyb and select header view ton the table view and press Delete. now remove conde in vididload
    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
        
        navigationItem.leftBarButtonItem = editButtonItem
    }
}


