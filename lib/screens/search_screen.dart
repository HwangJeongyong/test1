import 'package:flutter/material.dart';
import 'dart:convert';
import 'loading.dart';
import 'package:test1/data/search_id.dart';
import 'package:shared_preferences/shared_preferences.dart';


class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);



  @override
  State<SearchScreen> createState() => _SearchScreenState();
}


class _SearchScreenState extends State<SearchScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadSaveData();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Test'),
        actions: [
          TextButton(onPressed: (){
            saveSaveData();
          }, child: Text('저장',
            style: TextStyle(color: Colors.white),))
        ],
      ),
      body: Column(
        children: [
          Row(
            children: [
              TextButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Dialog(
                          child: Column(
                            children: [
                              Text('서버선택'),
                              ...serverName.map(
                                    (e) => TextButton(
                                  onPressed: () {
                                    setState(() {
                                      serverNumber = serverName.indexOf(e);
                                    });
                                    Navigator.pop(context);
                                  },
                                  child: Text(e),
                                ),
                              ),
                            ],
                          ),
                        );
                      });
                },
                child: Text(serverName[serverNumber]),
              ),
              Expanded(
                child: TextField(
                    autofocus: false,
                    textAlign: TextAlign.end,
                    controller: inputData,
                    decoration: InputDecoration(hintText: '캐릭터 이름')),
              ),
              IconButton(
                onPressed: () async {
                  print(imageList);
                  print(characterList);
                  print(serverList);
                  print(jsonMap);
                  characterName = inputData.text;
                  if (characterName == null || serverNumber == 0) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          '서버와 캐릭터이름을 확인해주세요',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white),
                        ),
                        backgroundColor: Colors.red,
                        duration: Duration(milliseconds: 2000),
                      ),
                    );
                  } else {
                    String encodedName = Uri.encodeComponent(characterName);
                    var _jsonData0 = await getApi(
                        'https://api.neople.co.kr/df/servers/${serverId[serverNumber]}/characters?characterName=$encodedName&apikey=$apikey'
                    );
                    setState(() {
                      characterId = _jsonData0['rows'][0]['characterId'];
                    });
                    jsonData = await getApi(
                        'https://api.neople.co.kr/df/servers/${serverId[serverNumber]}/characters/$characterId?apikey=gHa0bEoKbFKw1MKec3XejkcF4ajZ7s19'
                    );
                    characterImage = 'https://img-api.neople.co.kr/df/servers/${serverId[serverNumber]}/characters/$characterId?zoom=1';
                    showDialog(
                        useRootNavigator: false,
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext dialogcontext) {
                          return AlertDialog(
                            title: Text('캐릭터를 추가하시겠습니까?'),
                            content: Image.network(characterImage),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    int i = 0;
                                    if (characterList.length == 0) {
                                      addCharacter();
                                    } else {
                                      for (i; i < characterList.length; i++) {
                                        if (characterList[i] == characterId) {
                                          ScaffoldMessenger.of(dialogcontext)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                '이미 추가된 캐릭터입니다',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              backgroundColor: Colors.red,
                                              duration:
                                              Duration(milliseconds: 2000),
                                            ),
                                          );
                                          Navigator.pop(context);
                                          break;
                                        }
                                      }
                                    }
                                    if (i == characterList.length) {
                                      addCharacter();
                                    }

                                  },
                                  child: Text('예')),
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text('아니오'))
                            ],
                          );
                        });
                  }
                },
                icon: Icon(Icons.search),
              ),
            ],
          ),
          ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: characterList.length,
              itemBuilder: (context, i){
                return Container(
                  margin: EdgeInsets.only(left: 30),
                  child: Row(
                    children: [
                      Text('${i+1}',),
                      Container(child: Image.network(imageList[i]),
                        height: 100,),
                      Container(
                        margin: EdgeInsets.only(top: 20),
                        width: 120,
                        child: Column(
                          children: [
                            Text(jsonDecode(jsonMap[i])['jobGrowName']),
                            Text(jsonDecode(jsonMap[i])['characterName'])
                          ],
                        ),
                      ),
                      Container(
                        width: 20,
                        child: (i == 0 ? null
                            : IconButton(onPressed: (){changeUp(i);}, icon: Icon(Icons.arrow_circle_up_outlined))),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Container(
                        width: 20,
                        child: (i == characterList.length-1 ? null
                            : IconButton(onPressed: (){changeDown(i);}, icon: Icon(Icons.arrow_circle_down_outlined))),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      TextButton(onPressed: (){
                        setState(() {
                          characterList.removeAt(i);
                          serverList.removeAt(i);
                          imageList.removeAt(i);
                          jsonMap.removeAt(i);
                        });
                      }, child: Text('지우기'))

                    ],
                  ),
                );
              }
          )
        ],
      ),
    );;
  }
  void addCharacter() {
    setState(() {
      characterList.add(characterId);
      serverList.add(serverId[serverNumber]);
      imageList.add(characterImage);
      jsonMap.add(jsonEncode(jsonData));
      print(characterList);
      print(serverList);
      print(jsonMap);
    });
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '캐릭터 추가 완료',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        duration: Duration(milliseconds: 2000),
      ),
    );
  }

  void changeUp(int i){
    String _character;
    String _server;
    String _image;
    String _json;
    _character = characterList[i-1];
    _server = serverList[i-1];
    _image = imageList[i-1];
    _json = jsonMap[i-1];
    setState(() {
      characterList[i-1] = characterList[i];
      serverList[i-1] = serverList[i];
      imageList[i-1] = imageList[i];
      jsonMap[i-1] = jsonMap[i];
      characterList[i] = _character;
      serverList[i] = _server;
      imageList[i] = _image;
      jsonMap[i] = _json;
    });
  }

  void changeDown(int i){
    String _character;
    String _server;
    String _image;
    String _json;
    _character = characterList[i+1];
    _server = serverList[i+1];
    _image = imageList[i+1];
    _json = jsonMap[i+1];
    setState(() {
      characterList[i+1] = characterList[i];
      serverList[i+1] = serverList[i];
      imageList[i+1] = imageList[i];
      jsonMap[i+1] = jsonMap[i];
      characterList[i] = _character;
      serverList[i] = _server;
      imageList[i] = _image;
      jsonMap[i] = _json;
    });
  }

  loadSaveData() async{
    SharedPreferences saveData0 = await SharedPreferences.getInstance();
    setState(() {
      characterList = (saveData0.getStringList('characterList') ?? []);
      serverList = (saveData0.getStringList('serverList') ?? []);
      jsonMap = (saveData0.getStringList('jsonMap') ?? []);
      imageList = (saveData0.getStringList('imageList') ?? []);
    });
  }

  void saveSaveData() async {
    SharedPreferences saveData0 = await SharedPreferences.getInstance();
    setState(() {
      saveData0.setStringList('characterList',characterList);
      saveData0.setStringList('serverList',serverList);
      saveData0.setStringList('jsonMap',jsonMap);
      saveData0.setStringList('imageList', imageList);
    });
  }
}
