import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;

class Classifier {
  Interpreter _interpreter;
  List<String> _labelList;

  Classifier() {
    _loadModel();
    // _loadLabel();
  }

  void _loadModel() async {
    _interpreter =
        await Interpreter.fromAsset('model/lite-model_mirnet-fixed_integer_1.tflite');

    var inputShape = _interpreter.getInputTensor(0).shape;
    var outputShape = _interpreter.getOutputTensor(0).shape;
    print(inputShape);
    print(outputShape);
    print('Load Model - $inputShape / $outputShape');
  }

  void _loadLabel() async {
    final labelData = await rootBundle.loadString('assets/rps.txt');
    final labelList = labelData.split('\n');
    _labelList = labelList;
    print(labelData);
    print(labelList);
    print('Load Label');
  }

  Future<img.Image> loadImage(String imagePath) async {
    var originData = File(imagePath).readAsBytesSync();
    var originImage = img.decodeImage(originData);
    print("Loading Image");
    return originImage;
  }

  Future<dynamic> runModel(img.Image loadImage) async {
    var modelImage = img.copyResize(loadImage, width: 400, height: 400);
    var modelInput = imageToByteListFloat32(modelImage, 400);
    print("Run Model");
    print(modelInput.buffer);
    print(modelInput.length);
    print(modelInput.runtimeType);
    print(modelInput);
    var outputsForPrediction = List.generate(modelInput.length, (index) => 0.0);
    print("Before $outputsForPrediction");
    _interpreter.run(modelInput.buffer, outputsForPrediction);
    print("After $outputsForPrediction");
    print("After ${outputsForPrediction.runtimeType}");
    List<dynamic> result = [];
    // for (var i = 0; i < 3; i++) {
    //   result.add({
    //     'label': _labelList[sortedKeys[i]],
    //     'value': map[sortedKeys[i]],
    //   });
    // }
    // print("Result $result");
    return result;
  }

  // Uint8List imageToByteListUint8(img.Image image, int inputSize) {
  //   var convertedBytes = Uint8List(1 * inputSize * inputSize * 3);
  //   var buffer = Uint8List.view(convertedBytes.buffer);
  //
  //   int pixelIndex = 0;
  //   for (var i = 0; i < inputSize; i++) {
  //     for (var j = 0; j < inputSize; j++) {
  //       var pixel = image.getPixel(i, j);
  //       buffer[pixelIndex++] = img.getRed(pixel);
  //       buffer[pixelIndex++] = img.getGreen(pixel);
  //       buffer[pixelIndex++] = img.getBlue(pixel);
  //     }
  //   }
  //   return convertedBytes.buffer.asUint8List();
  // }

  Float32List imageToByteListFloat32(img.Image image, int inputSize) {
    var convertedBytes = Float32List(1 * inputSize * inputSize * 3);
    var buffer = Float32List.view(convertedBytes.buffer);
    int pixelIndex = 0;

    for (var i = 0; i < inputSize; i++) {
      for (var j = 0; j < inputSize; j++) {
        var pixel = image.getPixel(j, i);

        buffer[pixelIndex++] = (img.getRed(pixel) - 0) / 255;
        buffer[pixelIndex++] = (img.getGreen(pixel) - 0) / 255;
        buffer[pixelIndex++] = (img.getBlue(pixel) - 0) / 255;
      }
    }
    return convertedBytes.buffer.asFloat32List();
  }
}
