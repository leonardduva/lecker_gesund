import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lecker_gesund/models/recipe_model.dart';
import 'package:lecker_gesund/models/user_model.dart';
import 'package:flutter/material.dart';

class DatabaseService {
  final CollectionReference _usersRef =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference _recipesRef =
      FirebaseFirestore.instance.collection('recipes');
  final CollectionReference _favRecipesRef =
      FirebaseFirestore.instance.collection('favoriteRecipes');
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserModel> get userModel async {
    DocumentSnapshot snapshot =
        await _usersRef.doc(_auth.currentUser.uid).get();

    return UserModel.fromJson(snapshot.data());
  }

  Stream<List<RecipeModel>> get recipes {
    return _recipesRef.snapshots().map((event) => event.docs
        .map((DocumentSnapshot documentSnapshot) =>
            RecipeModel.fromJson(documentSnapshot.data()))
        .toList());
  }

  Stream<List> get favRecipes {
    return _favRecipesRef
        .doc(_auth?.currentUser?.uid ?? 'oXn9IqjIFPZduTigSH9KIhUUfGS2')
        .collection('recipesList')
        .snapshots()
        .map((event) => event.docs
            .map((DocumentSnapshot documentSnapshot) =>
                RecipeModel.fromJson(documentSnapshot.data()))
            .toList());
  }

  //Create recipe Firebase function
  // TODO:make an object to JSON conversion function
  Future<void> addRecipe({
    String imageUrl,
    String title,
    String ingredients,
    String description,
    String time,
    String people,
    String recipeId,
    ValueChanged<String> onError,
    VoidCallback onSuccess,
  }) async {
    try {
      await _recipesRef
          .doc(recipeId)
          .set({
            "imageUrl": imageUrl,
            "title": title,
            "ingredients": ingredients,
            "description": description,
            "time": time,
            "people": people,
            "recipeId": recipeId,
            "ownerId": _auth.currentUser.uid,
            "liked": false,
          })
          .then((value) => print("Recipe Added to Database"))
          .catchError((error) => print("Failed to add recipe: $error"));

      onSuccess();
    } on FirebaseException catch (e) {
      onError(e.toString());
    } catch (e) {
      print(e);
      onError(e.toString());
    }
  }

  //Create Fav Recipe Firebase function
  // TODO:make an object to JSON conversion function
  Future<void> addFavoriteRecipe({
    RecipeModel recipeModel,
    ValueChanged<String> onError,
    VoidCallback onSuccess,
  }) async {
    try {
      await _favRecipesRef
          .doc(_auth.currentUser.uid)
          .collection('recipesList')
          .doc(recipeModel.recipeId)
          .set({
            "imageUrl": recipeModel.imageUrl,
            "title": recipeModel.title,
            "ingredients": recipeModel.ingredients,
            "description": recipeModel.description,
            "time": recipeModel.time,
            "people": recipeModel.people,
            "recipeId": recipeModel.recipeId,
            "ownerId": _auth.currentUser.uid,
          })
          .then((value) => print("Recipe Added to Favorites"))
          .catchError((error) => print("Failed to add recipe: $error"));

      onSuccess();
    } on FirebaseException catch (e) {
      onError(e.toString());
    } catch (e) {
      print(e);
      onError(e.toString());
    }
  }

  Future<bool> checkIfFavList(recipeId) async {
    DocumentSnapshot snapshot = await _favRecipesRef
        .doc(_auth.currentUser.uid)
        .collection('recipesList')
        .doc(recipeId)
        .get();
    bool result = snapshot.data() != null && snapshot.data().isNotEmpty;

    print(' checkifFav= $result');
    return result;
  }

  //delete Fav Recipe Firebase function
  Future<void> delFavoriteRecipe({
    String recipeId,
    ValueChanged<String> onError,
    VoidCallback onSuccess,
  }) async {
    try {
      await _favRecipesRef
          .doc(_auth.currentUser.uid)
          .collection('recipesList')
          .doc(recipeId)
          .delete()
          .then((value) => print("Recipe deleted from Favorite Database"))
          .catchError((error) => print("Failed to delete recipe: $error"));

      onSuccess();
    } on FirebaseException catch (e) {
      onError(e.toString());
    } catch (e) {
      print(e);
    }
  }
}
