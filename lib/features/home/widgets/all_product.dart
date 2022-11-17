// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:amazon_clone_tutorial/common/widgets/loader.dart';
import 'package:amazon_clone_tutorial/features/home/services/home_services.dart';
import 'package:amazon_clone_tutorial/features/product_details/screen/product_details_screen.dart';
import 'package:flutter/material.dart';
import '../../../models/product.dart';

class AllProduct extends StatefulWidget {
  static const String routeName = "/category-deals";
  const AllProduct({
    Key? key,
  }) : super(key: key);

  @override
  State<AllProduct> createState() => _AllProductState();
}

class _AllProductState extends State<AllProduct> {
  List<Product>? productList;
  final HomeServices homeServices = HomeServices();
  @override
  void initState() {
    super.initState();
    fetchCategoryProducts();
  }

  void fetchCategoryProducts() async {
    productList = await homeServices.fetchAllProduct(context: context);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: productList == null
          ? const Loader()
          : SizedBox(
              height: productList!.length * 130,
              child: GridView.builder(
                physics: const ClampingScrollPhysics(),
                padding: const EdgeInsets.only(left: 15),
                itemCount: productList!.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                ),
                itemBuilder: (context, index) {
                  final product = productList![index];
                  return GestureDetector(
                    onTap: (() {
                      Navigator.pushNamed(
                          context, ProductDetailScreen.routeName,
                          arguments: product);
                    }),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black12,
                          width: 0.5,
                        ),
                      ),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 130,
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Image.network(
                                product.images[0],
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.topLeft,
                            padding: const EdgeInsets.only(
                              left: 0,
                              top: 5,
                              right: 15,
                            ),
                            child: Text(
                              product.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
