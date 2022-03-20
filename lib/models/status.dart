class Status {
  int id ;
  String name ;
  String color;
  String? time;
  Status({required this.id,required this.name,required this.color, this.time});


 factory Status.fromMap(Map<String,dynamic> map){
    return Status(
      id: map['id'],
      name: map['name'],
      color: map['color'],
      time: map['created_at'] ?? null
    );
  }
}