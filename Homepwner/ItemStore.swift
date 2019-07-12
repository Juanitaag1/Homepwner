//If an object wants to see all of the items it will ask the ItemStore. This class will perform the operations on the [Item]. ex: reorder(), remove(), save(), loadItemsFromDisk(). 
//  ItemStore.swift
//  Homepwner
//
//  Created by juanita aguilar on 4/27/19.
//  Copyright © 2019 none. All rights reserved.
//

import Foundation
import UIKit

class ItemStore{

    var allItems = [Item]()
    
    //@discardableResult means that a caller of this func is free to ignore the result of callling this func also look ast p185 for ex
    @discardableResult func createItem()-> Item {
        
        let newItem = Item(random: true)
        allItems.append(newItem)
        return newItem //now go to ItemsViewController to give it an instance of ItemStore
        
    }
        // remove code for this because you want to add a fresh new row with 1 item not a table at start up  so will call  the createItem designated constructor to creat a new item
    //and insert a new row in the table pg201
   /** init(){
        for _ in 0..<5{
            createItem()
        }
    }*/
    
    //To DELETE a row/ you must 1.Remove row from UItableview a;nd 2. remove the associate item
    //DETELE the associated item here p 202
    func removeItem(_ item: Item){
        
        if let index = allItems.firstIndex(of: item){
            allItems.remove(at: index)
        }
    }
    //NOw go to the ItemsVC and implement the ta leView)(commit for row fx)
    //The ItemStore is where the data is kept, but the ItemsVC is the UiTableview's data source
    
    
    //Now For the user to be able to move the rows around, need to have a moveItem from one spot in the Items Array to anoter
    func moveItem(from fromIndex: Int, to toIndex: Int){
        
        if fromIndex == toIndex{
            return
        }
        
        //get reference to object being moved so you can reinsert it
        let movedItem = allItems[fromIndex]
        
        //remove it from the array
        allItems.remove(at: fromIndex)
        
        //insert item in array at another location
        allItems.insert(movedItem, at: toIndex)
    }
}
//Now go to the ItemsVC and implement the tableView(moveRoat to 
