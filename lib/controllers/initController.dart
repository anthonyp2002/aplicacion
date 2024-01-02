// ignore_for_file: avoid_print, unused_field
import 'package:aplicacion/models/img_gustos.dart';
import 'package:aplicacion/models/orto.dart';
import 'package:aplicacion/models/prolcec_model.dart';
import 'package:aplicacion/models/prolecb_model.dart';
import 'package:aplicacion/models/seudo.dart';
import 'package:aplicacion/services/firebase_service.dart';
import 'package:flutter/material.dart';
import "package:get/get.dart";
import 'package:flutter_tts/flutter_tts.dart';
import 'dart:async';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:speech_to_text/speech_to_text.dart';
import '../../models/user.dart';
import 'ProlecR_Controller/prolecrccontroller.dart';

class InitController extends GetxController {
  final RxList<String> palabrasVisibles = <String>[].obs;
  final RxInt indexPalabra = 0.obs;
  late FlutterTts flutterTts;
  bool isMicrophoneActive = false;
  Rx<Color> containerColor = Rx<Color>(Colors.blue);
  RxInt selectedContainerIndex = RxInt(0);
  String words = "";
  List<dynamic> result = [];
  List<String> p = [];
  String? language;
  String? enunciado = "";
  String? engine;
  double volume = 0.5;
  double pitch = 1.0;
  double rate = 0.5;
  MaterialColor colorsp = Colors.green;
  MaterialColor colorsLec = Colors.green;
  bool isCurrentLanguageInstalled = false;
  RxInt seconds = 0.obs;
  var isLisent = false.obs;
  var isSelect = false;
  String? speed = "Di la palabra";
  SpeechToText speechToText = SpeechToText();
  late StreamController<String> _speechTextStreamController;
  Stream<String> get speechTextStream => _speechTextStreamController.stream;

  late Timer cronometro;
  late User use = User("Juanjsn", "12", "2", "", "password", "phone");
  String tiempo = '';
  int puntos = 0;
  int puntosH = 0;
  int puntosO = 0;
  int puntosIA = 0;
  int puntosIB = 0;
  int puntosIC = 0;
  int puntosID = 0;
  String? _newVoiceText;
  List<OptionsModel> imgOption = [];
  List<OptionsText> optionsText = [];
  List<SeudoModel> seuModel = [];
  List<OrtModel> ortografia = [];
  List<ImgGustos> imggustos = [];
  late PageController pageController;

  late Timer _textDisplayTimer;
  TtsState ttsState = TtsState.stopped;
  var showButtons = false.obs;
  get isPlaying => ttsState == TtsState.playing;

  bool get isIOS => !kIsWeb && Platform.isIOS;
  bool get isAndroid => !kIsWeb && Platform.isAndroid;
  bool get isWindows => !kIsWeb && Platform.isWindows;
  bool get isWeb => kIsWeb;

  @override
  onInit() async {
    super.onInit();
    initTts();
    _speechTextStreamController = StreamController<String>.broadcast();
    pageController = PageController(initialPage: 0);
  }

  void datos(User a, String tmp, int ptn, int pntH, int pntO, int pntIA,
      int pntIB, int pntIC, int pntID) {
    use = a;
    tiempo = tmp;
    puntos = ptn;
    puntosH = pntH;
    puntosO = pntO;
    puntosIA = pntIA;
    puntosIB = pntIB;
    puntosIC = pntIC;
    puntosID = pntID;
    update();
  }

  recuperarDatosImg() async {
    imgOption = await getImg();
  }

  recuperarDatosText() async {
    optionsText = await getStories();
  }

  recuperarPal(String palab) async {
    seuModel = (await getPalabras(palab)).cast<SeudoModel>();
  }

  recuperarOrto() async {
    ortografia = await getOrtografia();
  }

  recuperarGusOne() async {
    imggustos = await getGustosOne();
  }

  initTts() {
    flutterTts = FlutterTts();
    flutterTts.setStartHandler(() {
      ttsState = TtsState.playing;
    });
    flutterTts.setCompletionHandler(() {
      ttsState = TtsState.stopped;
    });
  }

  Future speak() async {
    await Future.delayed(const Duration(seconds: 1));
    flutterTts.setLanguage("es-ES");
    _newVoiceText = enunciado;
    if (_newVoiceText != null && _newVoiceText!.isNotEmpty) {
      await flutterTts.speak(_newVoiceText!);
      List<String> words = _newVoiceText!.split(' ');
      const fragmentDisplayInterval = 225;
      int currentIndex = 0;
      _textDisplayTimer = Timer.periodic(
        const Duration(milliseconds: fragmentDisplayInterval),
        (timer) {
          if (currentIndex < words.length) {
            String fragmentToShow =
                words.sublist(0, currentIndex + 1).join(' ');
            _speechTextStreamController.sink.add(fragmentToShow);
            currentIndex++;
          } else {
            timer.cancel();
          }
        },
      );
      flutterTts.setCompletionHandler(() {
        _speechTextStreamController.sink.add(_newVoiceText!);
        showButtons.value = true;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    flutterTts.stop();
    _speechTextStreamController.close();
  }
}
