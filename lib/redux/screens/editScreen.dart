import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:cost_control/redux/states/appState.dart';
import 'package:cost_control/redux/view_models/editViewModel.dart';
import 'package:cost_control/redux/actions/editActions.dart';

class EditScreen extends StatelessWidget {
  final EditScreenMode mode;

  EditScreen({this.mode});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, EditViewModel>(
      converter: (store) {
        return EditViewModel(
            state: store.state.editState,
            onSave: () {
              switch (mode) {
                case EditScreenMode.EDIT:
                  store.dispatch(new EditMovement());
                  break;
                case EditScreenMode.CREATE:
                  store.dispatch(new CreateMovement());
                  break;
              }
            });
      },
      builder: (BuildContext context, EditViewModel vm) {
        return getView(context, vm);
      },
    );
  }

  Widget getView(BuildContext context, EditViewModel vm) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
        titleSpacing: 0,
        title: Text(getTitle(),
            style: TextStyle(
              fontFamily: "SFPro",
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            )),
        actions: getActions(),
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Color.fromRGBO(91, 122, 229, 1),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        constraints: BoxConstraints.expand(),
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 16, right: 16, top: 20),
              child: TextFormField(
                style: TextStyle(
                  fontFamily: "SFPro",
                  fontSize: 16,
                  fontWeight: FontWeight.w300,
                  color: Color.fromRGBO(238, 238, 238, 1),
                ),
                decoration: InputDecoration(
                  enabledBorder: new UnderlineInputBorder(
                    borderSide:
                        new BorderSide(color: Color.fromRGBO(178, 194, 250, 1)),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: TextFormField(
                style: TextStyle(
                  fontFamily: "SFPro",
                  fontSize: 16,
                  fontWeight: FontWeight.w300,
                  color: Color.fromRGBO(238, 238, 238, 1),
                ),
                decoration: InputDecoration(
                  enabledBorder: new UnderlineInputBorder(
                    borderSide:
                        new BorderSide(color: Color.fromRGBO(178, 194, 250, 1)),
                  ),
                ),
              ),
            ),
            Expanded(child: Container()),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 16),
              margin: EdgeInsets.only(left: 20, right: 20, bottom: 16),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(16)),
              ),
              child: Text(
                "Сохранить",
                style: TextStyle(
                  fontFamily: "SFPro",
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color.fromRGBO(91, 122, 229, 1),
                ),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Theme.of(context).primaryColor,
    );
  }

  String getTitle() {
    switch (mode) {
      case EditScreenMode.CREATE:
        return "Создание";
      case EditScreenMode.EDIT:
        return "Редактирование";
      default:
        return "";
    }
  }

  List<Widget> getActions() {
    if (mode == EditScreenMode.CREATE) {
      return new List();
    }
    return <Widget>[
      Padding(
        padding: EdgeInsets.only(right: 20),
        child:
            Image.asset("assets/images/delete.png", width: 20.0, height: 20.0),
      ),
    ];
  }
}

enum EditScreenMode { CREATE, EDIT }
