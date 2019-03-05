import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:cost_control/baseScreenState.dart';
import 'package:cost_control/redux/states/appState.dart';
import 'package:cost_control/redux/view_models/editViewModel.dart';
import 'package:cost_control/redux/actions/editActions.dart';
import 'package:cost_control/entities/month.dart';
import 'package:cost_control/entities/monthMovement.dart';

class EditScreen extends StatefulWidget {
  final EditScreenMode mode;
  final Month month;
  final int direction;
  final MonthMovement movement;

  EditScreen({this.mode, this.month, this.direction, this.movement});

  @override
  _EditScreenState createState() => _EditScreenState();
}

class _EditScreenState extends BaseScreenState<EditScreen> {
  TextEditingController _nameController;
  TextEditingController _sumController;

  void _init(Store<AppState> store) {
    if (widget.movement != null) {
      _nameController = new TextEditingController(text: widget.movement.name);
      _sumController = new TextEditingController(
          text: widget.movement.sum.round().toString());
    } else {
      _nameController = new TextEditingController();
      _sumController = new TextEditingController();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _sumController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, EditViewModel>(
      onInit: _init,
      converter: (store) {
        return EditViewModel(
          state: store.state.editState,
          onSave: () {
            switch (widget.mode) {
              case EditScreenMode.EDIT:
                widget.movement.name = _nameController.text;
                widget.movement.sum = double.parse(_sumController.text);
                store.dispatch(new EditMovement(
                  movement: widget.movement,
                  onComplete: back,
                  onError: showToast,
                ));
                break;
              case EditScreenMode.CREATE:
                store.dispatch(new CreateMovement(
                  month: widget.month,
                  direction: widget.direction,
                  name: _nameController.text,
                  sum: double.parse(_sumController.text),
                  onComplete: back,
                  onError: showToast,
                ));
                break;
            }
          },
          onDelete: () {
            store.dispatch(new DeleteMovement(
              movement: widget.movement,
              onComplete: back,
              onError: showToast,
            ));
          },
        );
      },
      builder: (BuildContext context, EditViewModel vm) {
        return _getView(context, vm);
      },
    );
  }

  Widget _getView(BuildContext context, EditViewModel vm) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
        titleSpacing: 0,
        title: Text(_getTitle(),
            style: TextStyle(
              fontFamily: "SFPro",
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            )),
        actions: _getActions(vm),
        elevation: 0,
      ),
      body: _getBody(vm),
      backgroundColor: Theme.of(context).primaryColor,
    );
  }

  Widget _getBody(EditViewModel vm) {
    return Container(
      decoration: BoxDecoration(
        color: Color.fromRGBO(91, 122, 229, 1),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      constraints: BoxConstraints.expand(),
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 16, right: 16, top: 20),
            child: TextFormField(
              controller: _nameController,
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
              controller: _sumController,
              inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
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
          _getSaveButton(vm),
        ],
      ),
    );
  }

  Widget _getSaveButton(EditViewModel vm) {
    return InkWell(
      child: Container(
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
      onTap: vm.onSave,
    );
  }

  String _getTitle() {
    switch (widget.mode) {
      case EditScreenMode.CREATE:
        return "Создание";
      case EditScreenMode.EDIT:
        return "Редактирование";
      default:
        return "";
    }
  }

  List<Widget> _getActions(EditViewModel vm) {
    if (widget.mode == EditScreenMode.CREATE) {
      return new List();
    }
    return <Widget>[
      IconButton(
        icon:
            Image.asset("assets/images/delete.png", width: 20.0, height: 20.0),
        onPressed: vm.onDelete,
      ),
    ];
  }
}

enum EditScreenMode { CREATE, EDIT }
