class DogInfo  {

  var name;
  var imageUrl;
  var description;

  DogInfo(this.name,this.imageUrl,this.description);

  DogInfo.fromMap(Map<String, dynamic>  map) :
        name = map['name'],
        imageUrl = map['imageUrl'],
        description = map['description'];
}