import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:raed/category/addproduct.dart';
import 'package:raed/category/prodactviwe.dart';

class categoryviwe extends StatefulWidget {
  final String title;
  final String categoryId;
  final List user;

  const categoryviwe(
      {Key? key,
      required this.title,
      required this.categoryId,
      required this.user})
      : super(key: key);

  @override
  State<categoryviwe> createState() => _categoryviweState();
}

class _categoryviweState extends State<categoryviwe> {
  @override
  getData() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('catogery')
        .doc(widget.categoryId)
        .collection(widget.categoryId)
        .get();
    //catogery.addAll(querySnapshot.docs);

    setState(() {});
  }

  Stream<QuerySnapshot>? category;

  @override
  void didChangeDependencies() async {
    await getData();
    category = await FirebaseFirestore.instance
        .collection('catogery')
        .doc(widget.categoryId)
        .collection(widget.categoryId)
        .snapshots();

    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('${widget.title}'),
          actions: [
            IconButton(
              icon: Icon(Icons.search_rounded),
              onPressed: () {
                //  showSearch(context: context, delegate: search());
              },
            ),
            IconButton(
              icon: Icon(Icons.shopping_cart_outlined),
              onPressed: () {},
            ),
          ],
        ),
        floatingActionButton: widget.user.isNotEmpty
            ? widget.user[0]['admin'] == 1
                ? ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              addproduct(categoryId: widget.categoryId)));
                    },
                    child: Text('Add product '),
                  )
                : null
            : null,
        body: StreamBuilder(
          stream: category,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting)
              return Center(child: CircularProgressIndicator());
            else if (snapshot.hasError)
              return Center(
                  child: Text(
                'اعد المحاولة لاحقاً',
                style: TextStyle(fontSize: 30),
              ));
            else if (snapshot.data == null || snapshot.data!.docs.isEmpty)
              return Center(child: CircularProgressIndicator());
            return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => prodacteviwe(
                                    prodactname: snapshot.data!.docs[index]
                                        ['name'],
                                    dis: snapshot.data!.docs[index]['des'],
                                    pries: snapshot.data!.docs[index]['prise'],
                                    image: snapshot.data!.docs[index]
                                        ['image'])));
                          },
                          child: Container(
                            padding: EdgeInsetsDirectional.all(8),
                            margin: EdgeInsetsDirectional.all(8),
                            decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 5,
                                    blurRadius: 7,
                                    offset: const Offset(
                                        0, 3), // changes position of shadow
                                  ),
                                ],
                                image: DecorationImage(
                                    image: NetworkImage(
                                        '${snapshot.data!.docs[index]['image'][0]}'))),
                          ),
                        ),
                      ),
                      Text(
                        '${snapshot.data!.docs[index].get('name')}',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text(snapshot.data!.docs[index]['des'].toString().length >
                              20
                          ? snapshot.data!.docs[index]['des']
                              .toString()
                              .substring(0, 20)
                              .replaceRange(
                                  20,
                                  snapshot.data!.docs[index]['des']
                                      .toString()
                                      .length,
                                  '...')
                          : snapshot.data!.docs[index]['des'].toString()),
                      Text(
                        '${snapshot.data!.docs[index].get('prise')} ₪',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w700),
                      )
                    ],
                  );
                },
                itemCount: snapshot.data!.docs.length);
          },
        ));
  }
}
