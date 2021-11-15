class Status {
  int id ;
  String name ;
  String color;
  Status({required this.id,required this.name,required this.color});


 factory Status.fromMap(Map<String,dynamic> map){
    return Status(
      id: map['id'],
      name: map['name'],
      color: map['color']
    );
  }
}