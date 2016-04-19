//
//  RecipeController.swift
//  Food2Fork
//
//  Created by Victor Benning on 4/17/16.
//  Copyright © 2016 Benning. All rights reserved.
//

import Foundation

class RecipeController:NSObject {
    
    
    var api:APIController!
    var recipeModel:Recipe!
    override init() {
        api = APIController()
        recipeModel = Recipe()
    }
    
    func getAllRecipes(completion: (Array<Recipe>) -> Void) throws -> Void{
        
        do{
            try api.HTTPGetJSON("http://food2fork.com/api/search?key=37176991437f37ccf1cc0d18a51739c7"){ data in
                if let recipesJson = data["recipes"] as? Array<AnyObject>{
                    if(recipesJson.count > 0){
                        let recipes = try self.recipeModel.buildRecipe(recipesJson)
                        completion(recipes)
                    }else{
                        completion(Array<Recipe>())
                    }
                }
            }
        }catch let error{
            throw error
        }
    }
    
    func getIngredientsFromRecipe(recipeId:String,completion: (Array<String>)->Void) throws -> Void{
        do{
            try api.HTTPGetJSON("http://food2fork.com/api/get?key=37176991437f37ccf1cc0d18a51739c7&rId=" + recipeId){
                data in
                
                let recipes = try self.recipeModel.buildIngredients(data)
                completion(recipes)
            }
            
        }catch let error{
            throw error
        }
    }
}