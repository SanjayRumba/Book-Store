class BooksData {
  String? id; // Add 'id' field to store the document ID in Firestore
  String? bookName;
  String? author;
  String? category;
  double? oldPrice;
  double? newPrice;
  String? imageUrl;

  BooksData({
    this.id,
    this.author,
    this.bookName,
    this.category,
    this.imageUrl,
    this.newPrice,
    this.oldPrice,
  });

  BooksData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    author = json['author'];
    bookName = json['bookname'];
    category = json['category'];
    newPrice = json['newPrice']?.toDouble();
    oldPrice = json['oldPrice']?.toDouble();
    imageUrl = json['imageUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['oldPrice'] = this.oldPrice;
    data['newPrice'] = this.newPrice;
    data['category'] = this.category;
    data['bookName'] = this.bookName;
    data['imageUrl'] = this.imageUrl;
    data['author'] = this.author;

    return data;
  }
}
