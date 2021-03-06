class BookModel {
  String title;
  String isbn;
  String weight;
  DateTime publishedDate;
  //PublishedDate publishedDate;
  String thumbnailUrl;
  String longDescription;
  String status;
  int price;
  //List<dynamic> authors;
  List<String> categories;

  BookModel(
      {this.title,
      this.isbn,
      this.weight,
      this.publishedDate,
      this.thumbnailUrl,
      this.longDescription,
      this.status,
      // this.authors,
      this.categories});

  BookModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    isbn = json['isbn'];
    weight = json['weight'];
    publishedDate = json['publishedDate'].toDate();
    // publishedDate = json['publishedDate'] != null
    //     ? new PublishedDate.fromJson(json['publishedDate'].toDate())
    //     : null;
    thumbnailUrl = json['thumbnailUrl'];
    longDescription = json['longDescription'];
    status = json['status'];
    //authors = json['authors'].cast<String>();
    categories = json['categories'].cast<String>();
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['isbn'] = this.isbn;
    data['price'] = this.price;
    data['weight'] = this.weight;
    data['publishedDate'] = this.publishedDate;
    // if (this.publishedDate != null) {
    //   data['publishedDate'] = this.publishedDate.toJson();
    // }
    data['thumbnailUrl'] = this.thumbnailUrl;
    data['longDescription'] = this.longDescription;
    data['status'] = this.status;
    //data['authors'] = this.authors;
    data['categories'] = this.categories;
    return data;
  }
}

class PublishedDate {
  dynamic date;

  PublishedDate({this.date});

  PublishedDate.fromJson(Map<dynamic, dynamic> json) {
    date = json['$date'];
  }

  Map<dynamic, dynamic> toJson() {
    final Map<dynamic, dynamic> data = new Map<dynamic, dynamic>();
    data['$date'] = this.date;
    //.toDate();
    return data;
  }
}
