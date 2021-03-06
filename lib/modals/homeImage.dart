class HomeImage {
  String item;
  String quantity;
  String thumbnailUrl;
  String description;
  HomeImage({
    this.item,
    this.quantity,
    this.thumbnailUrl,
    this.description,
  });

  HomeImage.fromJson(Map<String, dynamic> json) {
    item = json['item'];
    quantity = json['quantity'];
    // weight = json['weight'];
    // publishedDate = json['publishedDate'].toDate();
    // publishedDate = json['publishedDate'] != null
    //     ? new PublishedDate.fromJson(json['publishedDate'].toDate())
    //     : null;
    thumbnailUrl = json['thumbnailUrl'];
    description = json['description'];
    //status = json['status'];
    //authors = json['authors'].cast<String>();
    //categories = json['categories'].cast<String>();
    //price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['item'] = this.item;
    data['quantity'] = this.quantity;
    // data['price'] = this.price;
    // data['weight'] = this.weight;
    // data['publishedDate'] = this.publishedDate;
    // if (this.publishedDate != null) {
    //   data['publishedDate'] = this.publishedDate.toJson();
    // }
    data['thumbnailUrl'] = this.thumbnailUrl;
    data['description'] = this.description;
    //data['status'] = this.status;
    //data['authors'] = this.authors;
    //data['categories'] = this.categories;
    return data;
  }
}

// class PublishedDate {
//   dynamic date;

//   PublishedDate({this.date});

//   PublishedDate.fromJson(Map<dynamic, dynamic> json) {
//     date = json['$date'];
//   }

//   Map<dynamic, dynamic> toJson() {
//     final Map<dynamic, dynamic> data = new Map<dynamic, dynamic>();
//     data['$date'] = this.date;
//     //.toDate();
//     return data;
//   }
// }
