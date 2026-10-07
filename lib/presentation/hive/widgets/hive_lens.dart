import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import 'hex_layout.dart';

class HiveLens extends StatefulWidget {
  const HiveLens({required this.child, this.amount = 1, super.key});

  final Widget child;
  final double amount;

  @override
  State<HiveLens> createState() => _HiveLensState();
}

class _HiveLensState extends State<HiveLens> {
  ui.FragmentProgram? _program;

  @override
  void initState() {
    super.initState();
    ui.FragmentProgram.fromAsset('shaders/hive_lens.frag')
        .then((program) {
          if (mounted) {
            setState(() => _program = program);
          }
        })
        .catchError((Object _) {});
  }

  @override
  Widget build(BuildContext context) {
    return _HiveLensRender(
      program: _program,
      amount: widget.amount,
      devicePixelRatio: MediaQuery.devicePixelRatioOf(context),
      child: widget.child,
    );
  }
}

class _HiveLensRender extends SingleChildRenderObjectWidget {
  const _HiveLensRender({
    required this.program,
    required this.amount,
    required this.devicePixelRatio,
    required super.child,
  });

  final ui.FragmentProgram? program;
  final double amount;
  final double devicePixelRatio;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderHiveLens(
      program: program,
      amount: amount,
      devicePixelRatio: devicePixelRatio,
    );
  }

  @override
  void updateRenderObject(BuildContext context, RenderHiveLens renderObject) {
    renderObject
      ..program = program
      ..amount = amount
      ..devicePixelRatio = devicePixelRatio;
  }
}

class RenderHiveLens extends RenderProxyBox {
  RenderHiveLens({
    required ui.FragmentProgram? program,
    required double amount,
    required double devicePixelRatio,
  }) : _program = program,
       _amount = amount,
       _devicePixelRatio = devicePixelRatio;

  ui.FragmentProgram? _program;
  ui.FragmentProgram? get program => _program;
  set program(ui.FragmentProgram? value) {
    if (_program == value) {
      return;
    }
    _program = value;
    _shader?.dispose();
    _shader = null;
    markNeedsPaint();
  }

  double _amount;
  double get amount => _amount;
  set amount(double value) {
    if (_amount == value) {
      return;
    }
    _amount = value;
    markNeedsPaint();
  }

  double _devicePixelRatio;
  double get devicePixelRatio => _devicePixelRatio;
  set devicePixelRatio(double value) {
    if (_devicePixelRatio == value) {
      return;
    }
    _devicePixelRatio = value;
    markNeedsPaint();
  }

  ui.FragmentShader? _shader;
  ui.Image? _frame;

  @override
  void dispose() {
    _shader?.dispose();
    _frame?.dispose();
    super.dispose();
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    if (child == null) {
      return false;
    }
    final source = _program == null
        ? position
        : hiveLensSourcePoint(position, size, amount: amount);
    return result.addWithRawTransform(
      transform: Matrix4.translationValues(
        source.dx - position.dx,
        source.dy - position.dy,
        0,
      ),
      position: position,
      hitTest: (BoxHitTestResult result, Offset transformed) {
        return child!.hitTest(result, position: transformed);
      },
    );
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (child == null || size.isEmpty) {
      return;
    }
    if (_program == null) {
      context.paintChild(child!, offset);
      return;
    }

    final layer = OffsetLayer();
    final inner = PaintingContext(layer, Offset.zero & size);
    super.paint(inner, Offset.zero);
    // ignore: invalid_use_of_protected_member
    inner.stopRecordingIfNeeded();
    ui.Image image;
    try {
      image = layer.toImageSync(
        Offset.zero & size,
        pixelRatio: devicePixelRatio,
      );
    } catch (_) {
      layer.dispose();
      context.paintChild(child!, offset);
      return;
    }
    layer.dispose();
    _frame?.dispose();
    _frame = image;

    final shader = _shader ??= _program!.fragmentShader();
    shader.setFloat(0, size.width);
    shader.setFloat(1, size.height);
    shader.setFloat(2, amount);
    shader.setImageSampler(0, image);

    context.canvas
      ..save()
      ..translate(offset.dx, offset.dy)
      ..drawRect(Offset.zero & size, Paint()..shader = shader)
      ..restore();
  }
}
