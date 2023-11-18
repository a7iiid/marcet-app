import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:raed/category/prodactviwe.dart';
import 'package:raed/drawer/drawer.dart';
import 'package:raed/viwe/settings.dart';
import 'package:raed/category/categoryviwe.dart';

//import 'package:scroll_loop_auto_scroll/scroll_loop_auto_scroll.dart';
//import 'package:carousel_slider/carousel_slider.dart';

class home extends StatefulWidget {
  const home({Key? key}) : super(key: key);

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  final Stream<QuerySnapshot> category =
  FirebaseFirestore.instance.collection('catogery').snapshots();
  final Stream<QuerySnapshot> data =
  FirebaseFirestore.instance.collection('users').snapshots();
  final Stream<QuerySnapshot> offers =
  FirebaseFirestore.instance.collection('offers').snapshots();
  List user = [];
  final Stream<QuerySnapshot> pubiulr =
  FirebaseFirestore.instance.collection('pubiulr').snapshots();

  @override
  chickadmin() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('email',
        isEqualTo: FirebaseAuth.instance.currentUser!.email as String)
        .get();
    user.addAll(querySnapshot.docs);
    setState(() {});
  }

  void didChangeDependencies() async {
    if (FirebaseAuth.instance.currentUser != null) {
      await chickadmin();
    }
// TODO: implement didChangeDependencies

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: (AppBar(
        title: Text('Al-Raed'),
        centerTitle: true,
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
      )),
      floatingActionButton: user.isNotEmpty
          ? user[0]['admin'] == 1
          ? ElevatedButton(
        onPressed: () {
          Navigator.pushNamed(context, '/addcetgory');
        },
        child: Text('Add Category '),
      )
          : null
          : null,
      drawer: Mydrawer(),
      body: ListView(
        children: [
          Column(
            children: [
              StreamBuilder(
                  stream: offers,
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting)
                      return CircularProgressIndicator();

                    return FlutterCarousel.builder(
                      itemBuilder: (context, index, realIndex) {
                        return Card(
                          color: Colors.blue,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: NetworkImage(
                                      '${snapshot.data!.docs[index]['imege']}'),
                                  fit: BoxFit.cover),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 5,
                                  blurRadius: 7,
                                  offset: const Offset(
                                      0, 3), // changes position of shadow
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      itemCount: snapshot.data!.docs.length == 0
                          ? 3
                          : snapshot.data!.docs.length,
                      options: CarouselOptions(
                        aspectRatio: 16 / 9,
                        viewportFraction: 0.8,
                        enableInfiniteScroll: true,
                        autoPlay: true,
                        autoPlayInterval: const Duration(seconds: 3),
                        autoPlayAnimationDuration:
                        const Duration(milliseconds: 800),
                        autoPlayCurve: Curves.easeOutCubic,
                        enlargeCenterPage: false,
                        scrollDirection: Axis.horizontal,
                        disableCenter: true,
                        showIndicator: true,
                        slideIndicator: CircularSlideIndicator(),
                      ),
                    );
                  }),
              Container(
                  width: double.infinity,
                  height: 120,
                  margin: EdgeInsets.all(10),
                  child: StreamBuilder(
                    stream: category,
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) return Text('is Error');
                      if (snapshot.connectionState == ConnectionState.waiting)
                        return CircularProgressIndicator();
                      return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return Row(
                            children: [
                              SizedBox(
                                width: 30,
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            categoryviwe(
                                              user: user,
                                              title: snapshot.data!.docs[index]
                                              ['name'],
                                              categoryId:
                                              snapshot.data!.docs[index].id,
                                            )),
                                  );
                                },
                                child: Column(
                                  children: [
                                    CircleAvatar(
                                      radius: snapshot.data!.docs.length > 2
                                          ? 35
                                          : 40,
                                      backgroundImage: NetworkImage(
                                          '${snapshot.data!
                                              .docs[index]['imege']}'),
                                    ),
                                    Text(
                                        '${snapshot.data!.docs[index]['name']}',
                                        style: TextStyle(
                                            color: Colors.blueGrey[900]))
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  )),
            ],
          ),
          StreamBuilder(
              stream: pubiulr,
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting)
                  return CircularProgressIndicator();

                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2),
                  itemBuilder: (context, index) {
                    return InkWell(
                      child: Card(
                        color: Colors.blue,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: NetworkImage(
                                    '${snapshot.data!
                                        .docs[index]['image'][0]}'),
                                fit: BoxFit.cover),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: const Offset(
                                    0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          alignment: Alignment.bottomLeft,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  '${snapshot.data!.docs[index]['name']}',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87),
                                ),
                                Text(
                                  snapshot.data!.docs[index]['des']
                                      .toString().length>15?
                                  snapshot.data!.docs[index]['des']
                                      .toString()
                                      .substring(0, 15)
                                      .replaceRange(10, 15, '...'):snapshot.data!.docs[index]['des']
                                      .toString(),
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w400,
                                  ),
                                )
                              ]),
                        ),
                      ),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (
                            context) =>
                            prodacteviwe(
                                dis: snapshot.data!.docs[index]['des'],
                                image: snapshot.data!.docs[index]['image'],
                                pries
                                    : snapshot.data!.docs[index]['prise'],
                                prodactname
                                :snapshot.data!.docs[index]['name']),));
                      },
                    );
                  },
                  itemCount: snapshot.data!.docs.length,
                  shrinkWrap: true,
                );
              }),
        ],
      ),
    );
  }
}
// class search extends SearchDelegate{
//   @override
//   List<Widget>? buildActions(BuildContext context) {
//     return [
//       IconButton(
//           onPressed: () {
//             close(context, null);
//           },
//           icon: Icon(Icons.cancel_outlined))
//     ];
//   }
//
//   @override
//   Widget? buildLeading(BuildContext context) {
//     return IconButton(
//         onPressed: () {
//           close(context, null);
//         },
//         icon: Icon(Icons.arrow_back));
//   }
//
//   @override
//   Widget buildResults(BuildContext context) {
//     return Text('data');
//   }
//
//   @override
//   Widget buildSuggestions(BuildContext context) {
//     List felter = notes
//         .map((e) => e)
//         .where((element) =>
//         element['title'].toString().toLowerCase().startsWith(query.toLowerCase()))
//         .toList();
//
//     return query.isEmpty ?
//     ListView.builder(
//         physics: NeverScrollableScrollPhysics(),
//         itemCount:  notes.length ,
//         shrinkWrap: true,
//         itemBuilder: (context, i) {
//           return Dismissible(
//             background: Container(
//               color: Colors.red,
//               child: Row(
//                 children: [
//                   Icon(
//                     Icons.delete_outline_outlined,
//                     color: Colors.white,
//                   )
//                 ],
//               ),
//             ),
//             key:  Key(notes[i]['id'].toString()),
//             onDismissed: (direction) async {
//               await mydb
//                   .deleteData('DELETE FROM notes WHERE ID=${notes[i]['id']}');
//
//             },
//             child: Container(
//                 margin: EdgeInsets.all(5),
//                 decoration: BoxDecoration(
//                   //query=='' ?
//                     borderRadius: (BorderRadius.circular(20)),
//                     color: notes[i]['color'] == 1
//                         ? Colors.deepPurpleAccent
//                         : notes[i]['color'] == 2
//                         ? Colors.blue
//                         : notes[i]['color'] == 3
//                         ? Colors.amber
//                         : Colors.green
//
//
//
//                 ),
//                 child:  ListTile(
//                   title: Text('${notes[i]['title']}'),
//                   subtitle: ('${notes[i]['note']}'.length > 20)
//                       ? Text('${notes[i]['note']}'.replaceAll(
//                       notes[i]['note'].toString().substring(2), '....'))
//                       : Text('${notes[i]['note']}'),
//                 )
//             ),
//           );
//         }):
//     ListView.builder(
//         physics: NeverScrollableScrollPhysics(),
//         itemCount:  felter.length ,
//         shrinkWrap: true,
//         itemBuilder: (BuildContext context, i) {
//           return Dismissible(
//             background: Container(
//               color: Colors.red,
//               child: Row(
//                 children: [
//                   Icon(
//                     Icons.delete_outline_outlined,
//                     color: Colors.white,
//                   )
//                 ],
//               ),
//             ),
//             key: Key(notes[i]['id'].toString()),
//             onDismissed: (direction) async {
//               await mydb
//                   .deleteData('DELETE FROM notes WHERE ID=${notes[i]['id']}');
//             },
//             child: Container(
//                 margin: EdgeInsets.all(5),
//                 decoration: BoxDecoration(
//                   //query=='' ?
//                     borderRadius: (BorderRadius.circular(20)),
//                     color: notes[i]['color'] == 1
//                         ? Colors.deepPurpleAccent
//                         : notes[i]['color'] == 2
//                         ? Colors.blue
//                         : notes[i]['color'] == 3
//                         ? Colors.amber
//                         : Colors.green
//
//
//
//                 ),
//                 child:  ListTile(
//                   title: Text('${felter[i as int]['title']}'),
//                   subtitle: ('${felter[i as int]['note']}'.length > 20)
//                       ? Text('${felter[i as int]['note']}'.replaceAll(
//                       felter[i as int]['note'].toString().substring(2), '....'))
//                       : Text('${felter[i as int]['note']}'),
//                 )
//             ),
//           );
//         }
//     );
//   }
// }
