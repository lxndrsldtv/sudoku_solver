import 'dart:io';
import 'dart:math';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_texts.dart';
import 'package:image/image.dart' as image_tools;
import 'package:logging/logging.dart';
import 'package:sudoku_solver/blocs/sudoku_events.dart';

import '../blocs/sudoku_bloc.dart';

class CameraWidget extends StatefulWidget {
  const CameraWidget({super.key});

  @override
  CameraWidgetState createState() => CameraWidgetState();
}

class CameraWidgetState extends State<CameraWidget> {
  final logger = Logger('CameraWidget');

  final previewKey = GlobalKey();

  late final CameraDescription _camera;
  late final CameraController _controller;
  late final Future<void> _controllerInitialized;

  final overlayFrameWidth = 4.0;
  double overlayFrameSideLength = 0.0;

  bool _workDone = false;
  bool _imageProcessingInProgress = false;

  Future<void> _initController() async {
    final cameras = await availableCameras();
    _camera = cameras.first;
    _controller = CameraController(
      _camera,
      ResolutionPreset.max,
    );
    await _controller.initialize();
  }

  @override
  initState() {
    logger.info('initState start');
    super.initState();
    _workDone = false;
    _imageProcessingInProgress = false;
    _controllerInitialized = _initController();
  }

  @override
  void dispose() {
    logger.info('dispose start');
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    logger.info('build start');
    logger.info('_pictureStored = $_workDone');

    if (_workDone) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pop();
      });
      return const SizedBox(
        width: 0.0,
        height: 0.0,
      );
    }

    final screenSize = MediaQuery.of(context).size;
    logger.info('screenSize = $screenSize');

    final sudokuBloc = BlocProvider.of<SudokuBloc>(context);

    final screenOrientation = MediaQuery.of(context).orientation;

    overlayFrameSideLength =
        min(screenSize.width, screenSize.height) - 100 + 2 * overlayFrameWidth;

    return Scaffold(
      body: FutureBuilder<void>(
        future: _controllerInitialized,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Stack(
              children: [
                Center(
                  child: CameraPreview(
                    _controller,
                    key: previewKey,
                  ),
                ),
                Center(
                  child: Center(
                    child: Container(
                      width: overlayFrameSideLength,
                      height: overlayFrameSideLength,
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: overlayFrameWidth,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                Center(
                  child: screenOrientation == Orientation.landscape
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            createSnapButton(sudokuBloc: sudokuBloc),
                            const SizedBox(width: 32.0, height: 0.0),
                          ],
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                createSnapButton(sudokuBloc: sudokuBloc),
                              ],
                            ),
                            const SizedBox(width: 0.0, height: 32.0),
                          ],
                        ),
                ),
                Visibility(
                  visible: _imageProcessingInProgress,
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    color: Colors.black54,
                    child: Center(
                      child: Text(
                        AppLocalizations.of(context)?.txtProcessingImage ??
                            'Processing image...',
                        style:
                            const TextStyle(color: Colors.white, fontSize: 24),
                      ),
                    ),
                  ),
                ),
              ],
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  Widget createSnapButton({required SudokuBloc sudokuBloc}) {
    return IconButton(
      onPressed: () async {
        try {
          final imageFile = await _controller.takePicture();
          setState(() {
            _imageProcessingInProgress = true;
          });
          final croppedImageBytes = await _getCroppedImageCenter(imageFile);
          await File(imageFile.path).delete();

          sudokuBloc.add(SudokuImageSelected(image: croppedImageBytes));

          setState(() {
            _imageProcessingInProgress = false;
            _workDone = true;
          });
        } catch (e) {
          logger.shout(e);
        }
      },
      style: ElevatedButton.styleFrom(
        elevation: 16.0,
        shadowColor: Colors.white70,
      ),
      icon: const Icon(
        Icons.camera_outlined,
        color: Colors.white,
      ),
      iconSize: 72.0,
    );
  }

  Future<image_tools.Image> _getCroppedImageCenter(XFile imageFile) async {
    final imageBytes = await File(imageFile.path).readAsBytes();
    final image = image_tools.decodeImage(imageBytes);

    if (image == null) return image_tools.Image.empty();
    logger.info('imageWidth = ${image.width}');
    logger.info('imageHeight = ${image.height}');

    final cameraPreviewRenderBox =
        previewKey.currentContext?.findRenderObject() as RenderBox;

    final imageToPreviewScaleRatio =
        image.height / cameraPreviewRenderBox.size.height;
    logger.info('imageToPreviewScaleRatio = $imageToPreviewScaleRatio');

    final scaledOverlayFrameSideLength =
        overlayFrameSideLength * imageToPreviewScaleRatio;
    logger.info('overlayFrameSideLength = $overlayFrameSideLength');
    logger.info('scaledOverlayFrameSideLength = $scaledOverlayFrameSideLength');

    final imageCenterByX = image.width / 2;
    logger.info('imageCenterByX = $imageCenterByX');

    final imageCenterByY = image.height / 2;
    logger.info('imageCenterByY = $imageCenterByY');

    final overlayTopLeftXCoordinate =
        imageCenterByX - scaledOverlayFrameSideLength / 2;
    logger.info('overlayTopLeftXCoordinate = $overlayTopLeftXCoordinate');

    final overlayTopLeftYCoordinate =
        imageCenterByY - scaledOverlayFrameSideLength / 2;
    logger.info('overlayTopLeftYCoordinate = $overlayTopLeftYCoordinate');

    final croppedImage = image_tools.copyCrop(
      image,
      x: overlayTopLeftXCoordinate.toInt(),
      y: overlayTopLeftYCoordinate.toInt(),
      width: scaledOverlayFrameSideLength.toInt(),
      height: scaledOverlayFrameSideLength.toInt(),
    );

    return croppedImage;
  }
}
