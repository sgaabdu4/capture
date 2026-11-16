import 'package:capture/core/data/notion/notion_http_service.dart';
import 'package:capture/core/domain/values/result.dart';
import 'package:capture/features/capture/data/datasources/notion_capture_remote_datasource.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mocktail/mocktail.dart';

class _MockHttp extends Mock implements INotionHttpService {}

_MockHttp _http({
  NotionResult<String> upload = const .ok('upload-1'),
  NotionResult<Json> patch = const .ok({}),
}) {
  final http = _MockHttp();
  when(
    () => http.uploadFile(
      any(),
      filename: any(named: 'filename'),
      type: any(named: 'type'),
    ),
  ).thenAnswer((_) async => upload);
  when(() => http.patch(any(), any())).thenAnswer((_) async => patch);
  return http;
}

Future<NotionResult<String>> _attach(_MockHttp http) =>
    NotionCaptureRemoteDatasource(http).attachRecording('page-1', [1, 2], name: 'capture-c1.m4a');

void main() {
  setUpAll(() {
    registerFallbackValue(MediaType('audio', 'mp4'));
    registerFallbackValue(<String, Object?>{});
  });

  group('attaching a recording to a capture page', () {
    test('uploads the audio, attaches the upload by id and returns it', () async {
      final http = _http();

      final attached = await _attach(http);

      expect(attached, equals(const Result<String, NotionFailure>.ok('upload-1')));
      final body = verify(() => http.patch('/v1/pages/page-1', captureAny())).captured.single;
      expect(
        body,
        equals({
          'properties': {
            'Recording': {
              'files': [
                {
                  'type': 'file_upload',
                  'file_upload': {'id': 'upload-1'},
                  'name': 'capture-c1.m4a',
                },
              ],
            },
          },
        }),
      );
    });

    test('a refused upload is returned and nothing is attached', () async {
      final http = _http(upload: const .err(.unavailable));

      final attached = await _attach(http);

      expect(attached, equals(const Result<String, NotionFailure>.err(.unavailable)));
      verifyNever(() => http.patch(any(), any()));
    });

    test('a refused attach is returned', () async {
      final attached = await _attach(_http(patch: const .err(.notShared)));

      expect(attached, equals(const Result<String, NotionFailure>.err(.notShared)));
    });
  });
}
