//
//  Recipe.swift
//  Food2Fork
//
//  Created by Victor Benning on 4/17/16.
//  Copyright © 2016 Benning. All rights reserved.
//

import Foundation

class Recipe: NSObject {

    var recipeId: String!
    var publisher:Publisher!
    var title:String!
    var image:String!
    var source:String!
    var rank:Double!
    var ingredients:Array<String>!
    
    
    override init() {
        self.recipeId = String()
        self.publisher = Publisher()
        self.title = String()
        self.image = String()
        self.source = String()
        self.rank = Double()
        self.ingredients = Array<String>()
        
        super.init()
    }
    
    func buildRecipe(data:Array<AnyObject>) throws -> Array<Recipe>{
        
        var arr = Array<Recipe>()
        
        for item in data{
            
            let recipe = Recipe()
            
            if let id = (item["recipe_id"] as? String){
                recipe.recipeId = id
            }else{
                throw CustomError(msg: "Error serializing recipe_id")
            }
            
            if let title = (item["title"] as? String){
                recipe.title = title
            }else{
                throw CustomError(msg: "Error serializing title")
            }
            
            if let img = (item["image_url"] as? String){
                recipe.image = img
            }else{
                throw CustomError(msg: "Error serializing img")
            }
            
            if let source = (item["source_url"] as? String){
                recipe.source = source
            }else{
                throw CustomError(msg: "Error serializing source")
            }
            
            if let rank = (item["social_rank"] as? Double){
                recipe.rank = rank
            }else{
                throw CustomError(msg: "Error serializing rank")
            }
            
            let pub = try Publisher().buildPublisher(item)
            recipe.publisher = pub
            
            
            arr.append(recipe)
        }
        return arr
    }
    
    
    func buildIngredients(data:AnyObject) throws -> Array<String>{
        
        var ingredients = Array<String>()
        let json = data["recipe"] as! NSDictionary
        let arr = json["ingredients"] as! Array<AnyObject>
        
        for item in arr{
            ingredients.append(item as! String)
        }
        
        return ingredients
        
    }
    
}
