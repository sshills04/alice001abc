//
//  RecipeDetails.swift
//  Food2Fork
//
//  Created by Victor Benning on 4/18/16.
//  Copyright © 2016 Benning. All rights reserved.
//

import UIKit
import MBProgressHUD

class RecipeDetailsViewController: UIViewController {
    
    
    var recipe:Recipe!
    var recipeImg:UIImage!
    var recipeController:RecipeController!
    
    @IBOutlet var imgRecipe: UIImageView!
    @IBOutlet var lblRankSocial: UILabel!
    @IBOutlet var lblRecipeTitle: UILabel!
    @IBOutlet var txtIngredients: UITextView!
    
    override func viewDidLoad() {
        
        if(self.recipe != nil){
            self.navigationItem.title = self.recipe.publisher.name
            self.lblRankSocial.text = String(self.recipe.rank)
            self.lblRecipeTitle.text = self.recipe.title
            
            if self.recipeImg != nil{
                self.imgRecipe.image = self.recipeImg
            }else{
                // if image was not sent from previous screen, download it again
                let bgImg = NSURL(string: self.recipe.image)
                let request = NSURLRequest(URL: bgImg!)
                // should've putted in api controller
                let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
                    (data, response, error) -> Void in
                    if(error != nil){
                        print("error loading image")
                    } else {
                        let image = UIImage(data: data!)
                        
                        dispatch_async(dispatch_get_main_queue(),
                            {
                                self.recipeImg = image
                        })
                    }
                }
                
                task.resume()
            }
            
            do{
                // get ingredients from API
                let loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                loadingNotification.mode = MBProgressHUDMode.Indeterminate
                loadingNotification.labelText = "Searching ingredients..."
                self.recipeController = RecipeController()
                try self.recipeController.getIngredientsFromRecipe(self.recipe.recipeId){ data in
                    if(data.count > 0){
                        self.recipe.ingredients = data
                        
                        var txt = ""
                        for item in self.recipe.ingredients{
                            txt += item
                            txt += " \n"
                        }
                        
                        dispatch_async(dispatch_get_main_queue(), {
                            self.txtIngredients.text = txt
                            MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                        })
                    }
                }
            }catch{
               print("Error getting ingredients")
            }
        }
        else{
            print("No recipe was selected")
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        //scroll textview to top
        self.txtIngredients.setContentOffset(CGPointZero, animated: false)
    }
    
    @IBAction func btnSourcePressed(sender: UIButton) {
        // open the url in safari
        let url = NSURL(string: self.recipe.source)
        UIApplication.sharedApplication().openURL(url!)
    }
}
