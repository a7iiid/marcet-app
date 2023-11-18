import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';

class prodacteviwe extends StatefulWidget {
  final String prodactname;
  final String dis;
  final String pries;
  final List image;

  const prodacteviwe(
      {Key? key,
      required this.prodactname,
      required this.dis,
      required this.pries,
      required this.image})
      : super(key: key);

  @override
  State<prodacteviwe> createState() => _prodacteviweState();
}

class _prodacteviweState extends State<prodacteviwe> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
          margin: const EdgeInsetsDirectional.all(9),
          width: double.infinity,
          height: 60,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(70),),
          clipBehavior: Clip.antiAlias,
          child: ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateColor.resolveWith(
                      (states) => Colors.indigo)),
              onPressed: () {
               setState(() {
                 showModalBottomSheet(context: context, builder: (context) {
                   return ListView(
                     children: [

                     ],
                   );

                 },);

                 },);

              },
              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('order ', style: TextStyle(fontSize: 25)),
                  Icon(Icons.shopping_cart_outlined)
                ],
              ))),
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: Text(widget.prodactname),
      ),
      body: ListView(
        children: [
          FlutterCarousel.builder(
            itemBuilder: (context, index, realIndex) {
              return Card(
                color: Colors.blue,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage('${widget.image[index]}'),
                        fit: BoxFit.cover),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset:
                            const Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                ),
              );
            },
            itemCount: widget.image.length,
            options: CarouselOptions(
              aspectRatio: 16 / 9,
              viewportFraction: 0.8,
              enableInfiniteScroll: true,
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 3),
              autoPlayAnimationDuration: const Duration(milliseconds: 800),
              autoPlayCurve: Curves.easeOutCubic,
              enlargeCenterPage: false,
              scrollDirection: Axis.horizontal,
              disableCenter: true,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              widget.prodactname,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              widget.dis,
              style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 25,
                  color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}
