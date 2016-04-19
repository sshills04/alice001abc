//
//  HomeViewController.swift
//  Food2Fork
//
//  Created by Victor Benning on 4/17/16.
//  Copyright © 2016 Benning. All rights reserved.
//

import UIKit
import MBProgressHUD

class HomeViewController : UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    var recipesController:RecipeController!
    var recipeSelected:Recipe!
    var recipes:Array<Recipe>!
    //image cache
    var imgBackgroundCache = [String:UIImage]()
    
    @IBOutlet var recipeTableView: UITableView!
    
    override func viewDidLoad() {
        self.recipesController = RecipeController()
        self.recipes = Array<Recipe>()
        
        do{
            
            
            let loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            loadingNotification.mode = MBProgressHUDMode.Indeterminate
            loadingNotification.labelText = "Searching recipes..."
            
            // get all recipes from API
            try self.recipesController.getAllRecipes(){ data in
                if(data.count > 0){
                    self.recipes = data
                    dispatch_async(dispatch_get_main_queue(), {
                        self.recipeTableView.reloadData()
                        MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                    })
                }
            }
        }catch{
            print("Error getting all recipes")
        }
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.recipes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! RecipesCell
        
        let rec =  self.recipes[indexPath.row]
        cell.recipeTitle.text = rec.title
        cell.publisher.text = rec.publisher.name
        
        // check if the img is already on the cache
        if let img = self.imgBackgroundCache[rec.recipeId!] {
            
            cell.bgImg.image = img
            
        }else{
            let bgImg = NSURL(string: rec.image)
            let request = NSURLRequest(URL: bgImg!)
            // download the image
            // should've putted on the api class
            let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
                (data, response, error) -> Void in
                if(error != nil){
                    
                } else {
                    let image = UIImage(data: data!)
                    self.imgBackgroundCache[rec.recipeId!] = image
                    
                    dispatch_async(dispatch_get_main_queue(),
                        {
                            // load imagem on screen
                            cell.bgImg.image = image
                    })
                }
            }
            
            task.resume()
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //store selected and send to recipe details
        self.recipeSelected = self.recipes[indexPath.row]
        performSegueWithIdentifier("recipeDetails", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if self.recipeSelected != nil{
            if segue.identifier == "recipeDetails" {
                let nextScene =  segue.destinationViewController as! RecipeDetailsViewController
                nextScene.recipe = self.recipeSelected
                if let img = self.imgBackgroundCache[self.recipeSelected.recipeId!]{
                    nextScene.recipeImg = img
                }
            }
        }
    }
}
