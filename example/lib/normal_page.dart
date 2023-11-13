import 'package:flutter/material.dart';

class NormalPage extends StatefulWidget {
  const NormalPage({Key key}) : super(key: key);

  @override
  State<NormalPage> createState() => _NormalPageState();
}

class _NormalPageState extends State<NormalPage> with WidgetsBindingObserver {
  List<String> message = [];
  TextEditingController controller = TextEditingController();

  /// 软键盘高度(安卓oppo测试出来的高度)
  double keyboardHeight = 0;

  /// 底部高度
  double bottomContentHeight = 208;

  double get tempSafeHeight => MediaQuery.of(context).padding.bottom;

  @override
  void didChangeMetrics() {
    var viewInsets = MediaQuery.of(context).viewInsets;
    var padding = MediaQuery.of(context).padding;
    var viewPadding = MediaQuery.of(context).viewPadding;

    String result = '显示 '
        '\nviewInsets.top=${viewInsets.top} '
        '\nviewInsets.bottom=${viewInsets.bottom} '
        '\npadding.top=${padding.top} '
        '\npadding.bottom=${padding.bottom} '
        '\nviewPadding.top=${viewPadding.bottom} '
        '\nviewPadding.bottom=${viewPadding.bottom} ';

    print(result);
    setState(() {
      keyboardHeight = viewInsets.bottom;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    controller.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('normal 底部安全距离$tempSafeHeight'),
        centerTitle: true,
      ),
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          Expanded(
            child: messageView(),
          ),
          inputView(),
          bottomView(),
        ],
      ),
    );
  }

  /// 输入框
  Widget messageView() {
    if (message.isEmpty) {
      return Container(
        alignment: Alignment.center,
        color: Colors.grey.withOpacity(0.3),
        child: const Text('no message'),
      );
    }
    return ListView.builder(
      itemCount: message.length,
      itemBuilder: (context, index) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          color: index / 2 == 0
              ? Colors.grey.withOpacity(0.3)
              : Colors.green.withOpacity(0.3),
          constraints: const BoxConstraints(minHeight: 50),
          alignment: Alignment.centerLeft,
          child: Text(message[index]),
        );
      },
    );
  }

  /// 输入框
  Widget inputView() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      color: Colors.red.withOpacity(0.3),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: const InputDecoration(
                hintText: '请输入',
                border: InputBorder.none,
                isCollapsed: true,
              ),
              controller: controller,
              maxLines: 4,
              minLines: 1,
              showCursor: true,
            ),
          ),
          TextButton(
            onPressed: () {
              String value = controller.text;
              if (value.isNotEmpty) {
                setState(() {
                  message.add(value);
                });
                controller.clear();
              }
            },
            child: const Text('send'),
          ),
        ],
      ),
    );
  }

  /// 底部弹出-常用语视图
  Widget bottomView() {
    double tempHeight = keyboardHeight;

    return Container(
      padding: EdgeInsets.only(bottom: tempSafeHeight),
      height: tempSafeHeight + tempHeight + 1,
      child: Column(
        children: [
          const Divider(height: 1),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: List.generate(
                  30,
                  (index) => Text('$index' * 30),
                ),
              ),
            ),
          ),
        ],
      ),
    );
    // return AnimatedContainer(
    //   duration: const Duration(milliseconds: 20),
    //   height: tempSafeHeight + tempHeight + 1,
    //   alignment: Alignment.center,
    //   child: Padding(
    //     padding: EdgeInsets.only(bottom: tempSafeHeight),
    //     child: Column(
    //       children: [
    //         const Divider(height: 1),
    //         Expanded(
    //           child: SingleChildScrollView(
    //             child: Column(
    //               children: List.generate(
    //                 30,
    //                 (index) => Text('$index' * 30),
    //               ),
    //             ),
    //           ),
    //         ),
    //       ],
    //     ),
    //   ),
    // );
  }
}
