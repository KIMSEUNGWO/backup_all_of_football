

class CouponCalculator {

  static int discount(int price, double per) {
    return (price * per).ceil();
  }

  static int total(int price, double per) {
    return price - discount(price, per);
  }
}