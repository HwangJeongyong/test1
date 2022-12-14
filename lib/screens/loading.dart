import 'package:flutter/material.dart';
import 'package:test1/screens/search_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

const apikey = 'gHa0bEoKbFKw1MKec3XejkcF4ajZ7s19';
final serverName = [
  '서버',
  '카인',
  '디레지에',
  '시로코',
  '프레이',
  '카시야스',
  '힐더',
  '안톤',
  '바칼'
];
final serverId = [
  'all',
  'cain',
  'diregie',
  'sirico',
  'prey',
  'casillas',
  'hilder',
  'anton',
  'bakal'
];
var serverNumber = 0;
var inputData = TextEditingController();
var characterName;
var characterId;
var characterImage;
var jsonData;
List<String> jsonMap = [];
List<String> characterList = [];
List<String> serverList = [];
List<String> imageList = [];

class Loading extends StatelessWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(onPressed: ()async{
              SharedPreferences saveData0 = await SharedPreferences.getInstance();
              saveData0.clear();
            }, child: Text('리스트 보기')),
            SizedBox(
              height: 40,
            ),
            TextButton(onPressed: (){
              showDialog(
                  context: context,
                  builder: (context){
                    return Dialog(
                      alignment: Alignment.center,
                      insetPadding: EdgeInsets.fromLTRB(100, 290, 100, 290),
                        child: Column(
                          children: [
                            TextButton(onPressed: (){
                              Navigator.pop(context);
                              Navigator.push(context, MaterialPageRoute(builder: (context) => SearchScreen()));
                            }, child: Text('save0')),
                            TextButton(onPressed: (){}, child: Text('save1')),
                            TextButton(onPressed: (){}, child: Text('save2')),
                            TextButton(onPressed: (){}, child: Text('save3')),
                          ],
                        ),
                    );
                  },
              );
            }, child: Text('리스트 수정'))
          ],
        ),
      ),
    );


  }


}






