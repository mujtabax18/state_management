import 'package:flutter/material.dart';
import 'dart:math' as math show Random;
import 'package:bloc/bloc.dart';

const name=['test1','test2','test3'];

extension RandomElement<T> on Iterable<T>{
  T getRandomElement()=>elementAt(math.Random().nextInt(length));
}

class NameCubit extends Cubit<String?>{
  NameCubit(): super(null);

  void pickRandomName()=>emit(name.getRandomElement());
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final NameCubit cubit;
  @override
  void initState() {
    cubit=NameCubit();
    super.initState();
  }

  @override
  void dispose() {
    cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('appbarTitle'),
        ),
        body: StreamBuilder<String?>(
        stream: cubit.stream,
    builder: (BuildContext context, AsyncSnapshot snapshot) {
        final button = TextButton(onPressed: ()=>cubit.pickRandomName(),
        child: Text('Get random name'));
            switch(snapshot.connectionState){
              case ConnectionState.none:
              return button;
              case ConnectionState.waiting:
              return button;
              case ConnectionState.active:
              return Column(children: [
                Text(snapshot.data??''),
                button,
                  ],);
              case ConnectionState.done:
              return const SizedBox();
            }

          }
          ),);
  }
}
