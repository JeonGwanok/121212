enum Flavor {
  PROD,
  DEV,
}

class F {
  static Flavor? appFlavor;

  static String get title {
    switch (appFlavor) {
      case Flavor.PROD:
        return '오아시스';
      case Flavor.DEV:
      default:
        return '오아시스_dev';
    }
  }

  static String get apiUrl {
    switch (appFlavor) {
      case Flavor.PROD:
      case Flavor.DEV:
      default:
        return 'http://139.150.75.56';
    }
  }
}
