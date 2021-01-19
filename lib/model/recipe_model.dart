class RecipeModel {
  final String imageUrl;
  final String title;
  final String ingredients;
  final String description;
  final String time;
  final String people;
  final String recipeId;

  bool liked = false;

  RecipeModel(
      {this.imageUrl,
      this.title,
      this.ingredients,
      this.description,
      this.time,
      this.people,
      this.liked,
      this.recipeId});

  RecipeModel.fromJson(Map<String, dynamic> json)
      : imageUrl = json['imageUrl'],
        title = json['title'],
        ingredients = json['ingredients'],
        description = json['description'],
        time = json['time'],
        people = json['people'],
        recipeId = json['recipeId'];
}
