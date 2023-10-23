// immutable data, from/toJson, copyWith functions for easily yielding new copies
import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';

// required: associates our `pixelart_data.dart` with the code generated by Freezed
part 'pixelart_data.freezed.dart';

// optional: Since our PixelArt class is serializable, we must add this line.
part 'pixelart_data.g.dart';

@freezed
class Participant with _$Participant {
  const factory Participant({
    required String id,
    required String name,
  }) = _Participant;
  factory Participant.fromJson(Map<String, dynamic> json) =>
      _$ParticipantFromJson(json);
}

@freezed
class Pixel with _$Pixel {
  const factory Pixel({
    required int red,
    required int green,
    required int blue,
    required int alpha,
    required Participant placedBy,
  }) = _Pixel;
  factory Pixel.fromJson(Map<String, dynamic> json) => _$PixelFromJson(json);
}

@freezed
class PixelArt with _$PixelArt {
  const PixelArt._();

  @JsonSerializable(explicitToJson: true) // call toJson on collection objects 
  const factory PixelArt({
    required String id,
    required String name,
    required String description,
    required int width,
    required int height,
    required List<Participant> editors,
    required List<List<Pixel>> pixelMatrix,
  }) = _PixelArt;

  factory PixelArt.fromJson(Map<String, dynamic> json) =>
      _$PixelArtFromJson(json);

  String serialize() => json.encode(toJson());
  
  factory PixelArt.deserialize(String source) =>
      PixelArt.fromJson(json.decode(source));
}

extension CloneHelper on PixelArt {
  PixelArt placePixel(int x, int y, Pixel pixel) {
    List<List<Pixel>> tempMatrix = List.of(pixelMatrix.map(List.of));
    if (x >= 0 && x < width && y >= 0 && y < height) {
      tempMatrix[y][x] = pixel;
    }
    return copyWith(pixelMatrix: tempMatrix);
  }
}
