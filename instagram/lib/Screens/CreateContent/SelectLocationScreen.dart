import 'package:flutter/material.dart';
import 'package:instagram/Models/PredictionModel.dart';
import 'package:instagram/Providers/AppData.dart';
import 'package:instagram/Services/RequestHelper.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';

import '../../BrandColors.dart';
import '../../globalVariables.dart';

class SearchLocationPage extends StatefulWidget {
  const SearchLocationPage({Key? key});

  @override
  _SearchLocationPageState createState() => _SearchLocationPageState();
}

class _SearchLocationPageState extends State<SearchLocationPage> {
  var _dropController = TextEditingController();

  var focusDestination = FocusNode();

  bool focused = false;

  Future searchPlace(String name) async {
    if (name.length >= 1) {
      String url =
          "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$name&key=$APIKEY&sessiontoken=123254251&components=country:in";
      var response = await RequestHelper.getResponse(url);
      if (response == 'failed') {
        return;
      }

      if (response['status'] == 'OK') {
        var predictionJson = response['predictions'];
        var thisList =
            (predictionJson as List).map((e) => Predicton.fromJson(e)).toList();
        setState(
          () {
            destinationPredictionList = thisList;
          },
        );
      }
    }
  }

  List<Predicton> destinationPredictionList = [];

  void setFocus() {
    if (!focused) {
      FocusScope.of(context).requestFocus(focusDestination);
      focused = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    setFocus();
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 170,
              child: Padding(
                padding: const EdgeInsets.only(left: 24.0, top: 48, right: 2),
                child: Column(
                  children: [
                    SizedBox(
                      height: 5,
                    ),
                    Stack(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(
                            LineIcons.arrowLeft,
                            color: Colors.black,
                          ),
                        ),
                        Center(
                          child: Text(
                            'Select Location',
                            style: TextStyle(
                                fontSize: 20, fontFamily: 'Brand-Bold'),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 18,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                                color: BrandColors.colorLightGrayFair,
                                borderRadius: BorderRadius.circular(4)),
                            child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: TextField(
                                onChanged: searchPlace,
                                controller: _dropController,
                                focusNode: focusDestination,
                                decoration: InputDecoration(
                                  hintText: 'Where to',
                                  fillColor: BrandColors.colorLightGrayFair,
                                  filled: true,
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding: EdgeInsets.only(
                                    left: 10,
                                    top: 8,
                                    bottom: 8,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        )
                      ],
                    ),
                  ],
                ),
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 5.0,
                    spreadRadius: 0.5,
                    offset: Offset(0.7, 0.7),
                  )
                ],
              ),
            ),
            destinationPredictionList.length > 0
                ? Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 16),
                    child: ListView.separated(
                        padding: EdgeInsets.all(0),
                        itemBuilder: (context, index) {
                          return ListTile(
                            onTap: () {
                              FocusScopeNode currentFocus =
                                  FocusScope.of(context);
                              if (!currentFocus.hasPrimaryFocus) {
                                currentFocus.unfocus();
                              }
                              print("Changed User Selected Location");
                              Provider.of<AppData>(context, listen: false)
                                  .changeUserSelectedCurrentLocation(
                                      destinationPredictionList[index]
                                          .mainText
                                          .toString(),
                                      destinationPredictionList[index]
                                          .secondaryText
                                          .toString());
                              Navigator.pop(context);
                            },
                            contentPadding: EdgeInsets.zero,
                            leading: Icon(LineIcons.locationArrow),
                            title: Text(
                              destinationPredictionList[index]
                                  .mainText
                                  .toString(),
                            ),
                            subtitle: Text(destinationPredictionList[index]
                                .secondaryText
                                .toString()),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return Divider(
                            color: BrandColors.colorDimText,
                          );
                        },
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        itemCount: destinationPredictionList.length),
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}
