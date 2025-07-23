import 'package:getx_demo_app/constants/product_model_field_ids.dart';
import 'package:hive/hive.dart';

import '../constants/hive_type_ids.dart';
import '../model/product_model.dart';

part 'product_model_hive.g.dart';

@HiveType(typeId: HiveTypeIds.productModelHive)
class ProductModelHive extends HiveObject {
  @HiveField(ProductModelFieldIds.id)
  int id;

  @HiveField(ProductModelFieldIds.title)
  String title;

  @HiveField(ProductModelFieldIds.price)
  double price;

  @HiveField(ProductModelFieldIds.description)
  String description;

  @HiveField(ProductModelFieldIds.category)
  String category;

  @HiveField(ProductModelFieldIds.image)
  String image;

  @HiveField(ProductModelFieldIds.userEmail)
  String userEmail;

  ProductModelHive({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
    required this.userEmail,
  });

  factory ProductModelHive.fromProductModel(
    ProductModel model,
    String userEmail,
  ) {
    return ProductModelHive(
      id: model.id,
      title: model.title,
      price: model.price,
      description: model.description,
      category: model.category,
      image: model.image,
      userEmail: userEmail,
    );
  }

  ProductModel toProductModel() {
    return ProductModel(
      id: id,
      title: title,
      price: price,
      description: description,
      category: category,
      image: image,
    );
  }
}
