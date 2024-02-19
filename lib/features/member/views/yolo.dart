import 'package:flutter/services.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;

Future<List<String>> Yolov8(img.Image image, Interpreter interpreter) async {
  // img.Image? image = await _loadImage('assets/images/any_image.png');
  // Interpreter interpreter = await Interpreter.fromAsset('assets/models/yolov8n_float16.tflite');
  try {
    final input = _preProcess(image);

    // output shape:
    // 1 : batch size
    // 4 + 80: left, top, right, bottom and probabilities for each class
    // 8400: num predictions
    // final output = List<num>.filled(1 * 84 * 8400, 0).reshape([1, 84, 8400]);
    final output = List.filled(84 * 8400, 0.0).reshape([1, 84, 8400]);
    int predictionTimeStart = DateTime.now().millisecondsSinceEpoch;
    interpreter.run([input], output);
    int predictionTime =
        DateTime.now().millisecondsSinceEpoch - predictionTimeStart;
    print('Prediction time: $predictionTime ms');

    List<double> maxPredList = List.filled(84, 0.0);
    double premaxPred = 0;
    for (int i = 5; i < 84; i++) {
      premaxPred = 0;
      for (int t = 0; t < 8400; t++) {
        if (premaxPred < output[0][i][t]) {
          premaxPred = output[0][i][t];
        }
      }
      maxPredList[i] = premaxPred;
    }

    // print(max_pred_list);

    List<int> indices = [];
    double threshold = 0.4; // 60%를 나타내는 임계값

    for (int i = 0; i < maxPredList.length; i++) {
      if (maxPredList[i] > threshold) {
        indices.add(i);
      }
    }

    print("Indices of values over 40%: $indices");

    return get_labels(indices);
  } finally {
    // interpreter.close(); // 리소스 해제
  }
}

List<String> get_labels(List<int> num) {
  List<String> objects = [
    'person',
    'bicycle',
    'car',
    'motorbike',
    'aeroplane',
    'bus',
    'train',
    'truck',
    'boat',
    'traffic light',
    'fire hydrant',
    'stop sign',
    'parking meter',
    'bench',
    'bird',
    'cat',
    'dog',
    'horse',
    'sheep',
    'cow',
    'elephant',
    'bear',
    'zebra',
    'giraffe',
    'backpack',
    'umbrella',
    'handbag',
    'tie',
    'suitcase',
    'frisbee',
    'skis',
    'snowboard',
    'sports ball',
    'kite',
    'baseball bat',
    'baseball glove',
    'skateboard',
    'surfboard',
    'tennis racket',
    'bottle',
    'wine glass',
    'cup',
    'fork',
    'knife',
    'spoon',
    'bowl',
    'banana',
    'apple',
    'sandwich',
    'orange',
    'broccoli',
    'carrot',
    'hot dog',
    'pizza',
    'donut',
    'cake',
    'chair',
    'sofa',
    'pottedplant',
    'bed',
    'diningtable',
    'toilet',
    'tvmonitor',
    'laptop',
    'mouse',
    'remote',
    'keyboard',
    'cell phone',
    'microwave',
    'oven',
    'toaster',
    'sink',
    'refrigerator',
    'book',
    'clock',
    'vase',
    'scissors',
    'teddy bear',
    'hair drier',
    'toothbrush'
  ];

  List<String> temp = [];

  for (int i = 0; i < num.length; i++) {
    temp.add(objects[num[i] - 4]);
  }

  return temp;
}

Future<img.Image?> _loadImage(String imagePath) async {
  final imageData = await rootBundle.load(imagePath);
  print(imageData.buffer.asUint8List().shape);
  return img.decodeImage(imageData.buffer.asUint8List());
}

List<List<List<num>>> _preProcess(img.Image image) {
  final imgResized = img.copyResize(image, width: 640, height: 640);

  return convertImageToMatrix(imgResized);
}

// yolov8 requires input normalized between 0 and 1
List<List<List<num>>> convertImageToMatrix(img.Image image) {
  return List.generate(
    image.height,
    (y) => List.generate(
      image.width,
      (x) {
        final pixel = image.getPixel(x, y);
        return [pixel.rNormalized, pixel.gNormalized, pixel.bNormalized];
      },
    ),
  );
}
