class BookModel2 {
  String item;
  //String isbn;
  String quantity;
  //DateTime publishedDate;
  //PublishedDate publishedDate;
  String thumbnailUrl;
  String description;
  // String status;
  // int price;
  //List<dynamic> authors;
  //List<String> categories;

  BookModel2({
    this.item,
    this.quantity,
    // this.isbn,
    // this.weight,
    // this.publishedDate,
    this.thumbnailUrl,
    this.description,
    //this.status,
    // this.authors,
    //this.categories
  });

  BookModel2.fromJson(Map<String, dynamic> json) {
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
