class LocalCatalogService {
  static final List<String> ideasFiles = [
    "Black & White Dress Women.png", "Black Kurti Women.png", "Black CasualShirt Men.png",
    "Black WaisCoat Men.png", "Blue kurti Women.png", "Blue Long Suite Women.png",
    "Blue WaisCoat Men.png", "Cream CasualShirt Men.png", "Cream Kurta Men.png",
    "Dark Kurta Men.png", "Green Suite Women.png", "Light Green CasualShirt Men.png",
    "Mehroon Shalwar Kameez Men.png", "Off White Kurta Men.png", "Pink Suite Women.png",
    "Purple Suite Women.png", "Purple White Suite Women.png", "Red Dress Women.png",
    "Red Long Suite Women.png", "Silver Pine Shalwar Kameez Men.png", "Skin WaisCoat Men.png",
    "White Shalwar Kameez Men.png", "Yellow Dress Women.png", "Yellow Shirt Women.png",
  ];

  static final List<String> breakoutFiles = [
    "Black Shirt Men.png", "Black Shirt Women.png", "Black SweatShirt Women.png",
    "Black Tee Men.png", "Brown SweatShirt Men.png", "Brown Tees Women.png",
    "Green Top Women.png", "Grey Polos Men.png", "Grey Shirt Men.png",
    "Grey Tees Women.png", "Grey SweatShirt Men.png", "Mehroon Top Women.png",
    "Navy Sweatshirt Women.png", "Red SweatShirt Men.png", "Skin Shirt Women.png",
    "Skin Tees Women.png", "Sky Blue Shirt Men.png", "White Brown Lines Tees Men.png",
    "White Cream Polos Men.png", "White Polos Men.png", "White Shirt Women.png",
    "White SweatShirt Women.png", "White Tees Men.png", "Yellow Top Women.png",
  ];

  static final List<String> outfittersFiles = [
    "Black Brown Active Wear Women.png", "Black Jump Suit Women.png", "Black Shirt Women.png",
    "Black T-Shirt Men.png", "Blue Active Wear Men.png", "Blue Black Jump Suit Women.png",
    "Blue Shirt Women.png", "Brown Red Active Wear Women.png", "Dark Blue Brown Active Wear Women.png",
    "Green Active Wear Men.png", "Green Shirt Men.png", "Mehroon Polo Shirt Men.png",
    "Pink T-Shirt Men.png", "Skin T-Shirt Women.png", "White Active Wear Tank Top Men.png",
    "White Flower Shirt Men.png", "White Jump Suit Women.png", "White Polo Shirt Men.png",
    "White Purple T-Shirts Women.png", "White Shirt Men.png", "White Shirt Women.png",
    "White T-Shirt Men.png", "White T-Shirts Women.png", "Yellow Polo Shirt Men.png",
  ];

  static final List<String> chaseValueFiles = [
    "black co-ords women.png", "black red tracksuit women.png", "blue kurti women.png",
    "blue red t-shirt women.png", "blue t-shirt women.png", "brown t-shirt women.png",
    "chasevalue men kameez shalwar brown.png", "chasevalue men kameez shalwar grey.png",
    "chasevalue men kameez shalwar white.png", "chasevalue men kurta black.png",
    "chasevalue men kurta brown.png", "chasevalue men kurta grey.png",
    "chasevalue men polo shirt black.png", "chasevalue men polo shirt blue.png",
    "chasevalue men polo shirt white.png", "chasevalue men waist coat black.png",
    "chasevalue men waist coat brown.png", "green tracksuit women.png",
    "grey co-ords women.png", "grey kurti women.png", "mehroon kurti women.png",
    "orange co-ords women.png", "purple t-shirt women.png", "white strip shirt men.png",
  ];

  static List<Map<String, String>> getAllCatalogItems() {
    List<Map<String, String>> allItems = [];
    allItems.addAll(_formatBrandItems("Ideas", ideasFiles));
    allItems.addAll(_formatBrandItems("Breakout", breakoutFiles));
    allItems.addAll(_formatBrandItems("Outfitters", outfittersFiles));
    allItems.addAll(_formatBrandItems("ChaseValue", chaseValueFiles));
    return allItems;
  }

  static List<Map<String, String>> getBrandCatalogItems(String brandName) {
    if (brandName == "Ideas") return _formatBrandItems("Ideas", ideasFiles);
    if (brandName == "Breakout") return _formatBrandItems("Breakout", breakoutFiles);
    if (brandName == "Outfitters") return _formatBrandItems("Outfitters", outfittersFiles);
    if (brandName == "ChaseValue") return _formatBrandItems("ChaseValue", chaseValueFiles);
    return [];
  }

  static List<Map<String, String>> _formatBrandItems(String brand, List<String> files) {
    return files.map((file) {
      String title = file.replaceAll(RegExp(r'\.(png|jpg|jpeg)', caseSensitive: false), '');
      return {
        "title": title,
        "image": "assets/Brands/$brand/$file",
        "brand": brand,
      };
    }).toList();
  }
}
