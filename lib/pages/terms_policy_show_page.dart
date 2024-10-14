import 'package:flutter/material.dart';
import 'package:jab_training/component/custom_app_bar.dart';
import 'package:jab_training/const/color.dart';
import 'package:jab_training/component/buttons.dart';

class TermsPolicyShowPage extends StatefulWidget {
  @override
  _TermsPolicyShowPageState createState() => _TermsPolicyShowPageState();
}

class _TermsPolicyShowPageState extends State<TermsPolicyShowPage> {
  bool _showTerms = true;

  final String _termsText = "Terms of Service content goes here...";
  final String _policyText =
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin ut nisl feugiat, pellentesque nunc a, porttitor lectus. Mauris fringilla eu enim at dictum. Nam eu semper lacus. Donec congue eu erat nec pellentesque. Aenean ornare vitae metus non porttitor. Sed magna massa, tincidunt ac dapibus sed, venenatis a nibh. Pellentesque imperdiet eleifend sapien, et porttitor erat fringilla ut. Aliquam fringilla dui non varius facilisis. Maecenas sollicitudin eros mi, vel hendrerit tellus placerat ac. Curabitur risus arcu, ultrices nec consectetur auctor, malesuada quis mi. Etiam non enim porta, ultricies massa sit amet, malesuada sapien. Aliquam erat volutpat. Vestibulum egestas auctor commodo. Integer vel lorem ipsum.  Mauris volutpat dolor justo, ut efficitur sapien porta eu. Sed urna est, pretium vestibulum semper varius, malesuada et ligula. Etiam faucibus erat sit amet nisi euismod, eget aliquet ex cursus. Nulla ac massa eget lacus imperdiet rutrum. Sed placerat ligula at enim porta, nec ornare est dictum. Morbi congue massa rutrum, cursus lacus a, blandit libero. Praesent placerat id lacus vel pellentesque. Vivamus cursus dapibus dictum. Aliquam erat volutpat. Morbi diam turpis, tincidunt vitae leo in, commodo ultrices nulla. In ac varius enim, sit amet commodo ex.  Etiam massa augue, gravida ac eleifend eget, commodo rhoncus neque. Praesent quis lacus euismod, auctor nunc vel, dignissim justo. Suspendisse nisl tortor, ullamcorper vitae viverra id, dictum vel urna. Quisque lacinia luctus magna ac lobortis. Curabitur tristique viverra massa ut blandit. Vivamus cursus tincidunt blandit. Sed sem mauris, feugiat et ipsum quis, placerat laoreet massa. Ut vehicula iaculis nunc at ullamcorper. In rutrum vulputate sollicitudin. Maecenas iaculis accumsan vestibulum. Donec malesuada vulputate erat, id rhoncus diam faucibus ut. Sed ultrices scelerisque fermentum. Etiam lacinia, odio at scelerisque venenatis, erat velit efficitur sapien, sit amet pulvinar nibh erat ac orci.  Maecenas iaculis quam dignissim lectus vulputate suscipit. Etiam convallis mollis sem, et mollis leo porttitor eu. Ut auctor neque dui, sit amet luctus ante volutpat quis. Integer vel bibendum tortor. Donec tellus velit, rhoncus in erat a, suscipit auctor lectus. Suspendisse congue tempor libero vitae imperdiet. Donec et massa a justo vehicula ultrices. Interdum et malesuada fames ac ante ipsum primis in faucibus. Duis sodales egestas magna. Aliquam erat volutpat. Maecenas tincidunt in elit in imperdiet. Sed non magna vulputate, varius neque sit amet, mattis libero. Nulla sed ex ligula. Maecenas vitae tortor nec ex maximus sagittis. Sed sed fringilla nulla, non posuere tortor. Duis facilisis, metus nec dapibus lacinia, mauris lectus posuere lorem, vestibulum feugiat neque dui eget nisl.  Sed laoreet, neque vel consequat efficitur, nulla tellus venenatis ex, blandit molestie ex metus at dui. Pellentesque ut erat metus. Quisque consectetur, sapien sit amet aliquet accumsan, nisi justo volutpat augue, nec finibus purus magna rutrum arcu. In neque neque, volutpat sed lacinia nec, fermentum vel erat. Aenean elit nulla, auctor in erat ac, blandit pellentesque felis. Phasellus sit amet cursus tortor. Aliquam in volutpat est. Nulla eros arcu, finibus at felis eu, aliquet scelerisque felis.";

  void _onButtonSelected(int index) {
    setState(() {
      _showTerms = index == 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "서비스 약관", iconStat: true),
      body: Column(
        children: [
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SelectButtonGroup(
                buttonLabels: const ["이용약관", "개인정보 처리방침"],
                onSelected: _onButtonSelected,
              ),
            ],
          ),
          const SizedBox(height: 24),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                _showTerms ? _termsText : _policyText,
                style: const TextStyle(fontSize: 16.0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
