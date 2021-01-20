class RecipeModel {
  final String imageUrl;
  final String title;
  final String ingredients;
  final String description;
  final String time;
  final String people;
  final String recipeId;
  final List usersFav;
  bool liked;

  RecipeModel({
    this.imageUrl,
    this.title,
    this.ingredients,
    this.description,
    this.time,
    this.people,
    this.liked,
    this.recipeId,
    this.usersFav,
  });

  RecipeModel.fromJson(Map<String, dynamic> json)
      : imageUrl = json['imageUrl'],
        title = json['title'],
        ingredients = json['ingredients'],
        description = json['description'],
        time = json['time'],
        people = json['people'],
        recipeId = json['recipeId'],
        usersFav = json['usersFav'],
        liked = json['liked'];
}
