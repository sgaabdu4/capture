import 'dart:io';

import 'package:capture/core/data/system/system_datasource.dart';
import 'package:capture/core/domain/values/result.dart';
import 'package:capture/core/services/native_platform_service.dart';
import 'package:capture/features/capture/data/datasources/transcription_datasource.dart';
import 'package:capture/features/capture/domain/entities/capture_failure.dart';
import 'package:capture/features/capture/domain/entities/capture_record.dart';
import 'package:capture/features/capture/domain/entities/capture_stage.dart';
import 'package:capture/features/capture/repositories/capture_repository.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/app_harness.dart';
import '../../../../helpers/sample_workspace.dart';
import '../../../../helpers/test_fakes.dart';

ProviderContainer _container({required bool phone, required INativePlatformService native}) =>
    .test(
      overrides: [
        systemDatasourceProvider.overrideWithValue(FakeSystem(isPhone: phone)),
        nativePlatformServiceProvider.overrideWithValue(native),
      ],
    );

void main() {
  test('iPhone transcribes through the Swift bridge with the Core ML model', () async {
    final native = stubNative();
    when(
      () => native.transcribe(
        pcmPath: 'c.pcm',
        modelDir: any(named: 'modelDir'),
      ),
    ).thenAnswer((_) async => 'Call the dentist.');
    final container = _container(phone: true, native: native);

    final text = await container.read(transcriptionDatasourceProvider).transcribe('c.pcm');

    expect(text, equals('Call the dentist.'));
    verify(
      () => native.transcribe(
        pcmPath: 'c.pcm',
        modelDir: any(named: 'modelDir', that: endsWith('/parakeet-tdt-0.6b-v3-coreml')),
      ),
    ).called(1);
  });

  test('the Mac keeps its sherpa-onnx transcription', () {
    final container = _container(phone: false, native: stubNative());

    expect(
      container.read(transcriptionDatasourceProvider),
      isA<SherpaTranscriptionDatasource>().having(
        (d) => d.modelDir,
        'modelDir',
        endsWith('/parakeet-tdt-0.6b-v3-int8'),
      ),
    );
  });

  test('a failed iPhone transcription keeps the capture recorded for Retry', () async {
    final support = Directory.systemTemp.createTempSync('transcription_test');
    addTearDown(() => support.deleteSync(recursive: true));
    final native = stubNative();
    when(
      () => native.transcribe(
        pcmPath: any(named: 'pcmPath'),
        modelDir: any(named: 'modelDir'),
      ),
    ).thenThrow(PlatformException(code: 'transcribe'));
    final container = ProviderContainer.test(
      overrides: appOverrides(
        support: support,
        native: native,
        fakes: (secrets: null, reminders: null, system: FakeSystem(isPhone: true)),
      ),
    );
    final captures = container.read(captureRepositoryProvider);
    final recorded = sampleProposedCapture.copyWith(stage: .recorded, transcript: null);
    captures.put(recorded);

    final outcome = await captures.transcribe(recorded);

    expect(outcome, equals(const Result<CaptureRecord, CaptureFailure>.err(.transcription)));
    expect(captures.get(recorded.id.value)?.stage, equals(CaptureStage.recorded));
  });
}
