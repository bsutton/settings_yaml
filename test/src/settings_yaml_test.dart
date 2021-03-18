// @dart=2.9
import 'package:settings_yaml/src/util/file_util.dart';
import 'package:test/test.dart';

import 'package:settings_yaml/settings_yaml.dart';

void main() {
  test('SettingsYaml fromString', () async {
    var content = '''name: brett
hostname: slayer
port: 10
''';
    var path = '/tmp/settings.yaml';
    var yaml = SettingsYaml.fromString(content: content, filePath: path);
    expect(yaml['name'], equals('brett'));
    expect(yaml['hostname'], equals('slayer'));
    expect(yaml['port'], equals(10));
  });

  test('SettingsYaml fromFile', () async {
    var path = '/tmp/settings.yaml';
    var content = '''name: brett
hostname: slayer
port: 10
coefficient: 8.25
''';
    if (exists(path)) {
      delete(path);
    }
    write(path, content);

    var yaml = SettingsYaml.load(pathToSettings: path);
    expect(yaml['name'], equals('brett'));
    expect(yaml['hostname'], equals('slayer'));
    expect(yaml['port'], equals(10));
    expect(yaml['coefficient'], equals(8.25));
  });

  test('SettingsYaml save', () async {
    var path = '/tmp/settings.yaml';
    var content = '''name: brett
hostname: slayer
port: 10
''';
    if (exists(path)) {
      delete(path);
    }
    write(path, content);

    var yaml = SettingsYaml.fromString(content: content, filePath: path);
    delete(path);
    yaml.save();

    yaml = SettingsYaml.load(pathToSettings: path);
    expect(yaml['name'], equals('brett'));
    expect(yaml['hostname'], equals('slayer'));
    expect(yaml['port'], equals(10));
  });

  test('SettingsYaml load create with no file.', () async {
    var path = '/tmp/settings.yaml';

    if (exists(path)) {
      delete(path);
    }

    var yaml = SettingsYaml.load(pathToSettings: path);
    yaml.save();
  });

  test('SettingsYaml load create with no file and save settings.', () async {
    var path = '/tmp/settings.yaml';

    if (exists(path)) {
      delete(path);
    }

    var yaml = SettingsYaml.load(pathToSettings: path);

    yaml['name'] = 'brett';
    yaml['hostname'] = 'slayer';
    yaml['port'] = 10;
    yaml['coefficient'] = 8.25;

    expect(yaml['name'], equals('brett'));
    expect(yaml['hostname'], equals('slayer'));
    expect(yaml['port'], equals(10));
    expect(yaml['coefficient'], equals(8.25));
    yaml.save();

    // reload saved data and make certain that its intact.
    yaml = SettingsYaml.load(pathToSettings: path);

    expect(yaml['name'], equals('brett'));
    expect(yaml['hostname'], equals('slayer'));
    expect(yaml['port'], equals(10));
  });

  test('SettingsYaml validXXX', () async {
    var path = '/tmp/settings.yaml';
    var content = '''name: brett
hostname: slayer
port: 10
active: true
volume: 10.0
''';

    var yaml = SettingsYaml.fromString(content: content, filePath: path);

    expect(yaml.validString('name'), equals(true));

    expect(yaml.validString('hostname'), equals(true));
    expect(yaml.validInt('hostname'), equals(false));
    expect(yaml.validDouble('hostname'), equals(false));
    expect(yaml.validBool('hostname'), equals(false));

    /// Int
    expect(yaml.validInt('port'), equals(true));

    expect(yaml.validString('port'), equals(false));
    expect(yaml.validDouble('port'), equals(false));
    expect(yaml.validBool('port'), equals(false));

    /// double
    expect(yaml.validDouble('volume'), equals(true));

    expect(yaml.validString('volume'), equals(false));
    expect(yaml.validInt('volume'), equals(false));
    expect(yaml.validBool('volume'), equals(false));

    /// Bool
    expect(yaml.validBool('active'), equals(true));

    expect(yaml.validString('active'), equals(false));
    expect(yaml.validInt('active'), equals(false));
    expect(yaml.validDouble('active'), equals(false));

    /// non- existant key
    expect(yaml.validString('badkey'), equals(false));
  });
}
