class Coupon {
  String title;
  String discount;
  String thumbnailUrl;
  String days_remaining;
  String couponcode;
  Coupon({
    this.title,
    this.couponcode,
    this.discount,
    this.thumbnailUrl,
    this.days_remaining,
  });

  Coupon.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    couponcode = json['couponcode'];
    discount = json['discount'];
    thumbnailUrl = json['thumbnailUrl'];
    days_remaining = json['days_remaining'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['couponcode'] = this.couponcode;
    data['discount'] = this.discount;
    data['thumbnailUrl'] = this.thumbnailUrl;
    data['days_remaining'] = this.days_remaining;
    return data;
  }
}
