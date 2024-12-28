import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:microservice_product/model/model_product.dart';
import 'package:microservice_product/screen/detailProduct.dart';

class AllProduct extends StatefulWidget {
  const AllProduct({super.key});

  @override
  State<AllProduct> createState() => _AllProductState();
}

class _AllProductState extends State<AllProduct> {
  List<ProductDatum> productList = [];

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    try {
      final response = await http.get(Uri.parse('http://192.168.126.181:3000/products'));

      if (response.statusCode == 200) {
        Product product = productFromJson(response.body);
        setState(() {
          productList = product.data;
        });
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 46, 76, 78),
      appBar: AppBar(
        title: const Text("Daftar Produk"),
        backgroundColor: Color.fromARGB(255, 46, 76, 78),
      ),
      body: productList.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: productList.length,
              itemBuilder: (context, index) {
                var product = productList[index];

                return Card(
                  color: Color.fromARGB(255, 41, 67, 69),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  elevation: 8.0,
                  child: ListTile(
                    leading: const Icon(Icons.shopping_cart, color: Colors.white),
                    title: Text(
                      product.name,
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    subtitle: Text(
                      'Rp${product.price}',
                      style: const TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                    trailing: const Icon(Icons.keyboard_arrow_right, color: Colors.white, size: 30.0,),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailProduct(product: product),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
