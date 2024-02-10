import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
void main() {
   runApp(
     const ProviderScope(
       child: ProductPage(),
     ),
   );
 }

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Riverpood',
      theme: ThemeData(
      
        colorScheme: ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 244, 186, 247)),
        useMaterial3: true,
      ),
    );
  }
}
class Product{
  Product({required this.name, required this.price});

  final String name;
  final double price;
}

final _products = [
  Product(name: "kim namjoon", price: 15),
  Product(name: "kim seokjim", price: 15),
  Product(name: "min yoongi", price: 15),

];
enum ProductSortType{
  name,
  price,
}
final productSortTypeProvider = StateProvider((ref) => 
ProductSortType.name);
final futureProductsProvider = FutureProvider<List<Product>>((ref) async {
  await Future.delayed(const Duration(seconds: 3));
  final sortType = ref.watch(productSortTypeProvider);
switch (sortType) {
    case ProductSortType.name:
       _products.sort((a, b) => a.name.compareTo(b.name));
       break;
    case ProductSortType.price:
       _products.sort((a, b) => a.price.compareTo(b.price));
}
  return _products;
});


class ProductPage extends ConsumerWidget {
  const ProductPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final productsProvider = ref.watch(futureProductsProvider);


productsProvider.when(
            data: (products)=> ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index){
                  return Padding(
                    padding: const EdgeInsets.only(left: 10,right: 10,top: 10),
                    child: Card(
                      color: Colors.blueAccent,
                      elevation: 3,
                      child: ListTile(
                        title: Text(products[index].name,style: const TextStyle(
                            color: Colors.white,  fontSize: 15)),
                        subtitle: Text("${products[index].price}",style: const TextStyle(
                            color: Colors.white,  fontSize: 15)),
                      ),
                    ),
                  );
                }),
            error: (err, stack) => Text("Error: $err",style: const TextStyle(
                color: Colors.white,  fontSize: 15)),
            loading: ()=> const Center(child: CircularProgressIndicator(color: Colors.white,)),
        );

    return Scaffold(
        appBar: AppBar(
          title: const Text("Future Provider Example"),
          actions: [
            DropdownButton<ProductSortType>(
              dropdownColor: Colors.brown,
              value: ref.watch(productSortTypeProvider),
                items: const [
                  DropdownMenuItem(
                    value: ProductSortType.name,
                    child: Icon(Icons.sort_by_alpha),
                ),
                  DropdownMenuItem(
                    value: ProductSortType.price,
                    child: Icon(Icons.sort),
                  ),
                ],
                onChanged: (value)=> ref.watch(productSortTypeProvider.notifier).state = value!
            ),
          ],
        ),
      backgroundColor: Colors.lightBlue,
      body: Container(
        child: productsProvider.when(
            data: (products)=> ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index){
                  return Padding(
                    padding: const EdgeInsets.only(left: 10,right: 10,top: 10),
                    child: Card(
                      color: Colors.blueAccent,
                      elevation: 3,
                      child: ListTile(
                        title: Text(products[index].name,style: const TextStyle(
                            color: Colors.white,  fontSize: 15)),
                        subtitle: Text("${products[index].price}",style: const TextStyle(
                            color: Colors.white,  fontSize: 15)),
                      ),
                    ),
                  );
                }),
            error: (err, stack) => Text("Error: $err",style: const TextStyle(
                color: Colors.white,  fontSize: 15)),
            loading: ()=> const Center(child: CircularProgressIndicator(color: Colors.white,)),
        ),
      )
    );
  }
}