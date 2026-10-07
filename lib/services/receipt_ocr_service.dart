import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

import '../domain/services/receipt_parser.dart';
import '../domain/entities/receipt_models.dart';

class ReceiptOcrService {
  ReceiptOcrService()
    : _recognizer = TextRecognizer(script: TextRecognitionScript.korean);

  final TextRecognizer _recognizer;

  Future<ReceiptScanResult> scanImage(String imagePath) async {
    final inputImage = InputImage.fromFilePath(imagePath);
    final recognizedText = await _recognizer.processImage(inputImage);
    return parseReceiptText(recognizedText.text);
  }

  void dispose() {
    _recognizer.close();
  }
}
