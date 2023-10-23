import 'dart:convert';
import 'package:dart_frog/dart_frog.dart';
import 'package:pixelart_server/src/helpers.dart';
import 'package:pixelart_server/src/hive_repository.dart';
import 'package:pixelart_shared/pixelart_shared.dart';

Future<Response> onRequest(RequestContext context) async {
  return switch (context.request.method) {
    HttpMethod.get => get(context),
    HttpMethod.post => post(context),
    _ => Future.value(
        Response(statusCode: CRUDStatus.NotFound.toHTTPStatusCode),
      )
  };
}

Future<Response> post(RequestContext context) async {
  final repository = await context.read<Future<HivePixelArtRepository>>();
  final request = context.request;

   
   final requestData= PixelArt.deserialize(request.body().toString());

  // TODO: 10. Deserialize the request body to retrieve a pixelArt for creation.
   
    final Map<String, dynamic> requestD = json.decode(requestData.id );//do i need to decode to get pixelArt
    final PixelArt pixelArt = PixelArt.fromJson(requestD);
    //----------------------------

  final result = await repository.create(pixelArt);

  if (result.isSuccess) {
    return result.toHTTPSuccess(
      body: pixelArt.serialize(),
    );
  } else {
    return result.toHTTPError();
  }
}

Future<Response> get(RequestContext context) async {
  final repository = await context.read<Future<HivePixelArtRepository>>();

  final result = await repository.list();

  if (result.isSuccess) {
    final pixelarts = result.value!.map((e) => e.serialize()).toList();
    return result.toHTTPSuccess(
      body: jsonEncode(pixelarts),
    );
  } else {
    return result.toHTTPError();
  }
}
