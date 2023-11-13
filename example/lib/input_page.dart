import 'package:flutter/material.dart';
import 'package:keyboard_utils_example/keyborad_bloc.dart';
import 'package:keyboard_utils_fork/keyboard_utils.dart';
import 'package:keyboard_utils_fork/keyboard_listener.dart'
    as keyboard_listener;

class InputPage extends StatefulWidget {
  const InputPage({Key key}) : super(key: key);

  @override
  State<InputPage> createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {
  KeyboardBloc _bloc = KeyboardBloc();

  KeyboardUtils _keyboardUtils = KeyboardUtils();

  // 软键盘高度
  double tempKeyBoardHeight = 0;

  double tempKeyBoardToRatio = 0;

  double tempKeyBoardToTop = 0;

  double tempKeyboardToBottom = 0;

  double lastResult = 0;

  int tempId;

  double get tempSafeBottomHeight => MediaQuery.of(context).padding.bottom;

  double get tempSafeTopHeight => MediaQuery.of(context).padding.top;

  double get devicePixelRatio => MediaQuery.of(context).devicePixelRatio;

  @override
  void initState() {
    super.initState();
    tempId = _keyboardUtils.add(
      listener: keyboard_listener.KeyboardListener(
        willHideKeyboard: () {
          tempKeyBoardHeight = 0;
          print('软键盘 关闭');
          setState(() {});
        },
        willShowKeyboard: (result) {
          tempKeyBoardHeight = result;

          print(
              '软键盘高度 打开 willShowKeyboard  tempKeyBoardHeight=$tempKeyBoardHeight');
          setState(() {});
        },
      ),
    );
    _bloc.start();
  }

  @override
  void dispose() {
    _bloc.dispose();
    _keyboardUtils.unsubscribeListener(subscribingId: tempId);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Keyboard Utils Sample'),
      ),
      resizeToAvoidBottomInset: false,
      body: buildSampleUsingKeyboardAwareWidget(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
      ),
    );
  }

  /// 使用 KeyboardAware
  Widget buildSampleUsingKeyboardAwareWidget() {
    final viewInsetsBottom = MediaQuery.of(context).viewInsets.bottom;
    final viewPaddingBottom = MediaQuery.of(context).viewPadding.bottom;

    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).padding.bottom,
      ),
      child: Center(
        child: Column(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(bottom: 30),
              child: Text(
                '当前顶部安全距离：$tempSafeTopHeight'
                '\n当前底部安全距离：$tempSafeBottomHeight'
                '\n当前底部距离：$viewPaddingBottom'
                '\n软键盘是否开启: ${_keyboardUtils.isKeyboardOpen}'
                '\n软键盘高度: $viewInsetsBottom'
                '\n屏幕密度: $devicePixelRatio'
                '\n动态软键盘高度: $tempKeyBoardHeight',
              ),
            ),
            Spacer(),
            Container(
              height: 50,
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                // keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: '请输入',
                ),
              ),
            ),
            Container(
              height: tempKeyBoardHeight,
            ),
          ],
        ),
      ),
    );
  }

  /// 使用原生监听
  Widget buildSampleUsingRawListener() {
    return Center(
      child: Column(
        children: <Widget>[
          TextField(),
          TextField(
            keyboardType: TextInputType.number,
          ),
          TextField(),
          SizedBox(
            height: 30,
          ),
          StreamBuilder<double>(
            stream: _bloc.stream,
            builder: (BuildContext context, AsyncSnapshot<double> snapshot) {
              return Text(
                  'is keyboard open: ${_bloc.keyboardUtils.isKeyboardOpen}\n'
                  'Height: ${_bloc.keyboardUtils.keyboardHeight}');
            },
          ),
        ],
      ),
    );
  }
}
