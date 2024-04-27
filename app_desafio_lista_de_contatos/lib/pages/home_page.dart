import 'package:flutter/material.dart';
import 'package:lista_de_contatos/pages/topbar/top_bar.dart';
import 'package:lista_de_contatos/pages/widgets/custom_drawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return  SafeArea(
      child: Scaffold(
        drawer: const CustonDrawer(),
        drawerEnableOpenDragGesture: true,
        drawerScrimColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.orange,
          centerTitle: true,
          elevation: 0,
          leadingWidth: 20,
          title: const Text(
            "Lista de Contatos",
            style: TextStyle(
              color: Colors.white, 
              fontSize: 28,
              fontWeight: FontWeight.w500
              ),
          ),
          actions: const<Widget> [ 
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                  onPressed: null, 
                  icon: Icon(
                    Icons.search,
                    size: 28,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
        body:  const Column(
          children: <Widget>[
            TopBar(),
          ]
        ),
      )
    );
  }
}

