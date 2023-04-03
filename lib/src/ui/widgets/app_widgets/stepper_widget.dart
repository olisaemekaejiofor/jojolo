import 'package:flutter/material.dart';
import 'package:jojolo_mobile/src/utils/colors.dart';

import '../../../utils/text_style.dart';

enum Nature { zero, one, two }

class StepProgressView extends StatelessWidget {
  final double _width;
  final Nature nature;
  final List<String> _titles;
  final int _curStep;
  final Color lineActive;
  final Color _activeColor;
  final Color _inactiveColor = const Color(0xffE6EEF3);
  final Color _lineInactiveColor = const Color(0xffFFD3B6);
  final double lineWidth = 5.0;
  final bool? vaccine;

  const StepProgressView({
    Key? key,
    required int curStep,
    required List<String> titles,
    required double width,
    required Color color,
    required this.nature,
    required this.lineActive,
    this.vaccine,
  })  : _titles = titles,
        _curStep = curStep,
        _width = width,
        _activeColor = color,
        assert(width > 0),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _width,
      child: Column(
        children: <Widget>[
          Padding(
            padding: (vaccine == true)
                ? const EdgeInsets.only(left: 12)
                : const EdgeInsets.symmetric(horizontal: 18.0),
            child: Row(
              children: _iconViews(),
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: _titleViews(),
          ),
        ],
      ),
    );
  }

  List<Widget> _iconViews() {
    var list = <Widget>[];
    _titles.asMap().forEach((i, icon) {
      Color circleColor;
      String text = '';
      switch (nature) {
        case Nature.zero:
          if (i >= 0) {
            text = '${i + 1}';
          }
          (i == 0) ? circleColor = _activeColor : circleColor = _inactiveColor;
          break;
        case Nature.one:
          if (i >= 1) {
            text = '${i + 1}';
          }
          (i == 1)
              ? circleColor = _activeColor
              : (i < 1)
                  ? circleColor = greenColor
                  : circleColor = _inactiveColor;
          break;
        case Nature.two:
          if (i >= 2) {
            text = '${i + 1}';
          }
          (i == 2) ? circleColor = _activeColor : circleColor = greenColor;
          break;
      }
      var lineColor = _curStep > i + 1
          ? (_curStep > i + 2)
              ? lineActive
              : _lineInactiveColor
          : _inactiveColor;

      list.add(
        Container(
          padding: const EdgeInsets.all(3),
          decoration: const BoxDecoration(
            color: fixedBottomColor,
            borderRadius: BorderRadius.all(Radius.circular(22.0)),
          ),
          child: Container(
            width: 30.0,
            height: 30.0,
            padding: const EdgeInsets.all(0),
            decoration: BoxDecoration(
              color: circleColor,
              borderRadius: const BorderRadius.all(Radius.circular(22.0)),
            ),
            child: Center(
              child: (text == '')
                  ? const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 15,
                    )
                  : Text(
                      text,
                      style: const TextStyle(color: Colors.white),
                    ),
            ),
          ),
        ),
      );

      //line between icons
      if (i != _titles.length - 1) {
        list.add(Expanded(
            child: Container(
          height: lineWidth,
          color: lineColor,
        )));
      }
    });

    return list;
  }

  List<Widget> _titleViews() {
    var list = <Widget>[];
    _titles.asMap().forEach((i, text) {
      list.add(
        Text(
          text,
          style: style(
            FontWeight.w500,
            14,
            textColorBlack,
          ),
          textAlign: TextAlign.center,
        ),
      );
    });
    return list;
  }
}
