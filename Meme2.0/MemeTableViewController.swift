//
//  MemeTableViewController.swift
//  Meme2.0
//
//  Created by Abdullah alammar on 25/04/2019.
//  Copyright © 2019 Abdullah alammar. All rights reserved.
//

import UIKit

class MemeTableViewController: UITableViewController {

    // MARK: Properties
    
    
    var allMemes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    
    @IBOutlet var refreshtable: UITableView!
    
   

    override func viewDidLoad() {
        
        super.viewDidLoad()
      

        self.tableView.reloadData()
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        tableView?.reloadData()
    }
    
    

    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        
        return self.allMemes.count
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cellIdentifier = "MemeTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MemeTableViewCell  else {
            fatalError("The dequeued cell is not an instance of MemeTableViewCell.")
        }
        
        
        
        
        let meme = self.allMemes[indexPath.row]
        
        
        // Set the name and image
        cell.topTextLabel?.text = meme.topText + "..." + meme.bottomText
        cell.imageView?.image =  meme.memedImage
        
        if let detailTextLabel = cell.detailTextLabel {
            detailTextLabel.text = "Scheme: \(meme.bottomText)"
        }
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        detailController.meme = self.allMemes[(indexPath as NSIndexPath).row]
        self.navigationController!.pushViewController(detailController, animated: true)
    }
    

}
