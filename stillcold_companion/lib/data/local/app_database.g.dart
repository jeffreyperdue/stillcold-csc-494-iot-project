// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $ReadingsTable extends Readings with TableInfo<$ReadingsTable, Reading> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReadingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _timestampMeta = const VerificationMeta(
    'timestamp',
  );
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
    'timestamp',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _temperatureCMeta = const VerificationMeta(
    'temperatureC',
  );
  @override
  late final GeneratedColumn<double> temperatureC = GeneratedColumn<double>(
    'temperature_c',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _humidityPercentMeta = const VerificationMeta(
    'humidityPercent',
  );
  @override
  late final GeneratedColumn<double> humidityPercent = GeneratedColumn<double>(
    'humidity_percent',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    deviceId,
    timestamp,
    temperatureC,
    humidityPercent,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'readings';
  @override
  VerificationContext validateIntegrity(
    Insertable<Reading> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_deviceIdMeta);
    }
    if (data.containsKey('timestamp')) {
      context.handle(
        _timestampMeta,
        timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta),
      );
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    if (data.containsKey('temperature_c')) {
      context.handle(
        _temperatureCMeta,
        temperatureC.isAcceptableOrUnknown(
          data['temperature_c']!,
          _temperatureCMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_temperatureCMeta);
    }
    if (data.containsKey('humidity_percent')) {
      context.handle(
        _humidityPercentMeta,
        humidityPercent.isAcceptableOrUnknown(
          data['humidity_percent']!,
          _humidityPercentMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Reading map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Reading(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      deviceId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}device_id'],
          )!,
      timestamp:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}timestamp'],
          )!,
      temperatureC:
          attachedDatabase.typeMapping.read(
            DriftSqlType.double,
            data['${effectivePrefix}temperature_c'],
          )!,
      humidityPercent: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}humidity_percent'],
      ),
    );
  }

  @override
  $ReadingsTable createAlias(String alias) {
    return $ReadingsTable(attachedDatabase, alias);
  }
}

class Reading extends DataClass implements Insertable<Reading> {
  final int id;
  final String deviceId;
  final DateTime timestamp;
  final double temperatureC;
  final double? humidityPercent;
  const Reading({
    required this.id,
    required this.deviceId,
    required this.timestamp,
    required this.temperatureC,
    this.humidityPercent,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['device_id'] = Variable<String>(deviceId);
    map['timestamp'] = Variable<DateTime>(timestamp);
    map['temperature_c'] = Variable<double>(temperatureC);
    if (!nullToAbsent || humidityPercent != null) {
      map['humidity_percent'] = Variable<double>(humidityPercent);
    }
    return map;
  }

  ReadingsCompanion toCompanion(bool nullToAbsent) {
    return ReadingsCompanion(
      id: Value(id),
      deviceId: Value(deviceId),
      timestamp: Value(timestamp),
      temperatureC: Value(temperatureC),
      humidityPercent:
          humidityPercent == null && nullToAbsent
              ? const Value.absent()
              : Value(humidityPercent),
    );
  }

  factory Reading.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Reading(
      id: serializer.fromJson<int>(json['id']),
      deviceId: serializer.fromJson<String>(json['deviceId']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
      temperatureC: serializer.fromJson<double>(json['temperatureC']),
      humidityPercent: serializer.fromJson<double?>(json['humidityPercent']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'deviceId': serializer.toJson<String>(deviceId),
      'timestamp': serializer.toJson<DateTime>(timestamp),
      'temperatureC': serializer.toJson<double>(temperatureC),
      'humidityPercent': serializer.toJson<double?>(humidityPercent),
    };
  }

  Reading copyWith({
    int? id,
    String? deviceId,
    DateTime? timestamp,
    double? temperatureC,
    Value<double?> humidityPercent = const Value.absent(),
  }) => Reading(
    id: id ?? this.id,
    deviceId: deviceId ?? this.deviceId,
    timestamp: timestamp ?? this.timestamp,
    temperatureC: temperatureC ?? this.temperatureC,
    humidityPercent:
        humidityPercent.present ? humidityPercent.value : this.humidityPercent,
  );
  Reading copyWithCompanion(ReadingsCompanion data) {
    return Reading(
      id: data.id.present ? data.id.value : this.id,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
      temperatureC:
          data.temperatureC.present
              ? data.temperatureC.value
              : this.temperatureC,
      humidityPercent:
          data.humidityPercent.present
              ? data.humidityPercent.value
              : this.humidityPercent,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Reading(')
          ..write('id: $id, ')
          ..write('deviceId: $deviceId, ')
          ..write('timestamp: $timestamp, ')
          ..write('temperatureC: $temperatureC, ')
          ..write('humidityPercent: $humidityPercent')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, deviceId, timestamp, temperatureC, humidityPercent);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Reading &&
          other.id == this.id &&
          other.deviceId == this.deviceId &&
          other.timestamp == this.timestamp &&
          other.temperatureC == this.temperatureC &&
          other.humidityPercent == this.humidityPercent);
}

class ReadingsCompanion extends UpdateCompanion<Reading> {
  final Value<int> id;
  final Value<String> deviceId;
  final Value<DateTime> timestamp;
  final Value<double> temperatureC;
  final Value<double?> humidityPercent;
  const ReadingsCompanion({
    this.id = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.temperatureC = const Value.absent(),
    this.humidityPercent = const Value.absent(),
  });
  ReadingsCompanion.insert({
    this.id = const Value.absent(),
    required String deviceId,
    required DateTime timestamp,
    required double temperatureC,
    this.humidityPercent = const Value.absent(),
  }) : deviceId = Value(deviceId),
       timestamp = Value(timestamp),
       temperatureC = Value(temperatureC);
  static Insertable<Reading> custom({
    Expression<int>? id,
    Expression<String>? deviceId,
    Expression<DateTime>? timestamp,
    Expression<double>? temperatureC,
    Expression<double>? humidityPercent,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (deviceId != null) 'device_id': deviceId,
      if (timestamp != null) 'timestamp': timestamp,
      if (temperatureC != null) 'temperature_c': temperatureC,
      if (humidityPercent != null) 'humidity_percent': humidityPercent,
    });
  }

  ReadingsCompanion copyWith({
    Value<int>? id,
    Value<String>? deviceId,
    Value<DateTime>? timestamp,
    Value<double>? temperatureC,
    Value<double?>? humidityPercent,
  }) {
    return ReadingsCompanion(
      id: id ?? this.id,
      deviceId: deviceId ?? this.deviceId,
      timestamp: timestamp ?? this.timestamp,
      temperatureC: temperatureC ?? this.temperatureC,
      humidityPercent: humidityPercent ?? this.humidityPercent,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    if (temperatureC.present) {
      map['temperature_c'] = Variable<double>(temperatureC.value);
    }
    if (humidityPercent.present) {
      map['humidity_percent'] = Variable<double>(humidityPercent.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReadingsCompanion(')
          ..write('id: $id, ')
          ..write('deviceId: $deviceId, ')
          ..write('timestamp: $timestamp, ')
          ..write('temperatureC: $temperatureC, ')
          ..write('humidityPercent: $humidityPercent')
          ..write(')'))
        .toString();
  }
}

class $SettingsTable extends Settings with TableInfo<$SettingsTable, Setting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _useFahrenheitMeta = const VerificationMeta(
    'useFahrenheit',
  );
  @override
  late final GeneratedColumn<bool> useFahrenheit = GeneratedColumn<bool>(
    'use_fahrenheit',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("use_fahrenheit" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _lowThresholdCMeta = const VerificationMeta(
    'lowThresholdC',
  );
  @override
  late final GeneratedColumn<double> lowThresholdC = GeneratedColumn<double>(
    'low_threshold_c',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _highThresholdCMeta = const VerificationMeta(
    'highThresholdC',
  );
  @override
  late final GeneratedColumn<double> highThresholdC = GeneratedColumn<double>(
    'high_threshold_c',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(4.0),
  );
  static const VerificationMeta _pollingIntervalSecondsMeta =
      const VerificationMeta('pollingIntervalSeconds');
  @override
  late final GeneratedColumn<int> pollingIntervalSeconds = GeneratedColumn<int>(
    'polling_interval_seconds',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(15),
  );
  static const VerificationMeta _quietHoursStartMinutesMeta =
      const VerificationMeta('quietHoursStartMinutes');
  @override
  late final GeneratedColumn<int> quietHoursStartMinutes = GeneratedColumn<int>(
    'quiet_hours_start_minutes',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _quietHoursEndMinutesMeta =
      const VerificationMeta('quietHoursEndMinutes');
  @override
  late final GeneratedColumn<int> quietHoursEndMinutes = GeneratedColumn<int>(
    'quiet_hours_end_minutes',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastConnectedDeviceIdMeta =
      const VerificationMeta('lastConnectedDeviceId');
  @override
  late final GeneratedColumn<String> lastConnectedDeviceId =
      GeneratedColumn<String>(
        'last_connected_device_id',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _autoConnectEnabledMeta =
      const VerificationMeta('autoConnectEnabled');
  @override
  late final GeneratedColumn<bool> autoConnectEnabled = GeneratedColumn<bool>(
    'auto_connect_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("auto_connect_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    useFahrenheit,
    lowThresholdC,
    highThresholdC,
    pollingIntervalSeconds,
    quietHoursStartMinutes,
    quietHoursEndMinutes,
    lastConnectedDeviceId,
    autoConnectEnabled,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<Setting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('use_fahrenheit')) {
      context.handle(
        _useFahrenheitMeta,
        useFahrenheit.isAcceptableOrUnknown(
          data['use_fahrenheit']!,
          _useFahrenheitMeta,
        ),
      );
    }
    if (data.containsKey('low_threshold_c')) {
      context.handle(
        _lowThresholdCMeta,
        lowThresholdC.isAcceptableOrUnknown(
          data['low_threshold_c']!,
          _lowThresholdCMeta,
        ),
      );
    }
    if (data.containsKey('high_threshold_c')) {
      context.handle(
        _highThresholdCMeta,
        highThresholdC.isAcceptableOrUnknown(
          data['high_threshold_c']!,
          _highThresholdCMeta,
        ),
      );
    }
    if (data.containsKey('polling_interval_seconds')) {
      context.handle(
        _pollingIntervalSecondsMeta,
        pollingIntervalSeconds.isAcceptableOrUnknown(
          data['polling_interval_seconds']!,
          _pollingIntervalSecondsMeta,
        ),
      );
    }
    if (data.containsKey('quiet_hours_start_minutes')) {
      context.handle(
        _quietHoursStartMinutesMeta,
        quietHoursStartMinutes.isAcceptableOrUnknown(
          data['quiet_hours_start_minutes']!,
          _quietHoursStartMinutesMeta,
        ),
      );
    }
    if (data.containsKey('quiet_hours_end_minutes')) {
      context.handle(
        _quietHoursEndMinutesMeta,
        quietHoursEndMinutes.isAcceptableOrUnknown(
          data['quiet_hours_end_minutes']!,
          _quietHoursEndMinutesMeta,
        ),
      );
    }
    if (data.containsKey('last_connected_device_id')) {
      context.handle(
        _lastConnectedDeviceIdMeta,
        lastConnectedDeviceId.isAcceptableOrUnknown(
          data['last_connected_device_id']!,
          _lastConnectedDeviceIdMeta,
        ),
      );
    }
    if (data.containsKey('auto_connect_enabled')) {
      context.handle(
        _autoConnectEnabledMeta,
        autoConnectEnabled.isAcceptableOrUnknown(
          data['auto_connect_enabled']!,
          _autoConnectEnabledMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Setting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Setting(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      useFahrenheit:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}use_fahrenheit'],
          )!,
      lowThresholdC:
          attachedDatabase.typeMapping.read(
            DriftSqlType.double,
            data['${effectivePrefix}low_threshold_c'],
          )!,
      highThresholdC:
          attachedDatabase.typeMapping.read(
            DriftSqlType.double,
            data['${effectivePrefix}high_threshold_c'],
          )!,
      pollingIntervalSeconds:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}polling_interval_seconds'],
          )!,
      quietHoursStartMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quiet_hours_start_minutes'],
      ),
      quietHoursEndMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quiet_hours_end_minutes'],
      ),
      lastConnectedDeviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_connected_device_id'],
      ),
      autoConnectEnabled:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}auto_connect_enabled'],
          )!,
    );
  }

  @override
  $SettingsTable createAlias(String alias) {
    return $SettingsTable(attachedDatabase, alias);
  }
}

class Setting extends DataClass implements Insertable<Setting> {
  final int id;
  final bool useFahrenheit;
  final double lowThresholdC;
  final double highThresholdC;
  final int pollingIntervalSeconds;
  final int? quietHoursStartMinutes;
  final int? quietHoursEndMinutes;
  final String? lastConnectedDeviceId;
  final bool autoConnectEnabled;
  const Setting({
    required this.id,
    required this.useFahrenheit,
    required this.lowThresholdC,
    required this.highThresholdC,
    required this.pollingIntervalSeconds,
    this.quietHoursStartMinutes,
    this.quietHoursEndMinutes,
    this.lastConnectedDeviceId,
    required this.autoConnectEnabled,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['use_fahrenheit'] = Variable<bool>(useFahrenheit);
    map['low_threshold_c'] = Variable<double>(lowThresholdC);
    map['high_threshold_c'] = Variable<double>(highThresholdC);
    map['polling_interval_seconds'] = Variable<int>(pollingIntervalSeconds);
    if (!nullToAbsent || quietHoursStartMinutes != null) {
      map['quiet_hours_start_minutes'] = Variable<int>(quietHoursStartMinutes);
    }
    if (!nullToAbsent || quietHoursEndMinutes != null) {
      map['quiet_hours_end_minutes'] = Variable<int>(quietHoursEndMinutes);
    }
    if (!nullToAbsent || lastConnectedDeviceId != null) {
      map['last_connected_device_id'] = Variable<String>(lastConnectedDeviceId);
    }
    map['auto_connect_enabled'] = Variable<bool>(autoConnectEnabled);
    return map;
  }

  SettingsCompanion toCompanion(bool nullToAbsent) {
    return SettingsCompanion(
      id: Value(id),
      useFahrenheit: Value(useFahrenheit),
      lowThresholdC: Value(lowThresholdC),
      highThresholdC: Value(highThresholdC),
      pollingIntervalSeconds: Value(pollingIntervalSeconds),
      quietHoursStartMinutes:
          quietHoursStartMinutes == null && nullToAbsent
              ? const Value.absent()
              : Value(quietHoursStartMinutes),
      quietHoursEndMinutes:
          quietHoursEndMinutes == null && nullToAbsent
              ? const Value.absent()
              : Value(quietHoursEndMinutes),
      lastConnectedDeviceId:
          lastConnectedDeviceId == null && nullToAbsent
              ? const Value.absent()
              : Value(lastConnectedDeviceId),
      autoConnectEnabled: Value(autoConnectEnabled),
    );
  }

  factory Setting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Setting(
      id: serializer.fromJson<int>(json['id']),
      useFahrenheit: serializer.fromJson<bool>(json['useFahrenheit']),
      lowThresholdC: serializer.fromJson<double>(json['lowThresholdC']),
      highThresholdC: serializer.fromJson<double>(json['highThresholdC']),
      pollingIntervalSeconds: serializer.fromJson<int>(
        json['pollingIntervalSeconds'],
      ),
      quietHoursStartMinutes: serializer.fromJson<int?>(
        json['quietHoursStartMinutes'],
      ),
      quietHoursEndMinutes: serializer.fromJson<int?>(
        json['quietHoursEndMinutes'],
      ),
      lastConnectedDeviceId: serializer.fromJson<String?>(
        json['lastConnectedDeviceId'],
      ),
      autoConnectEnabled: serializer.fromJson<bool>(json['autoConnectEnabled']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'useFahrenheit': serializer.toJson<bool>(useFahrenheit),
      'lowThresholdC': serializer.toJson<double>(lowThresholdC),
      'highThresholdC': serializer.toJson<double>(highThresholdC),
      'pollingIntervalSeconds': serializer.toJson<int>(pollingIntervalSeconds),
      'quietHoursStartMinutes': serializer.toJson<int?>(quietHoursStartMinutes),
      'quietHoursEndMinutes': serializer.toJson<int?>(quietHoursEndMinutes),
      'lastConnectedDeviceId': serializer.toJson<String?>(
        lastConnectedDeviceId,
      ),
      'autoConnectEnabled': serializer.toJson<bool>(autoConnectEnabled),
    };
  }

  Setting copyWith({
    int? id,
    bool? useFahrenheit,
    double? lowThresholdC,
    double? highThresholdC,
    int? pollingIntervalSeconds,
    Value<int?> quietHoursStartMinutes = const Value.absent(),
    Value<int?> quietHoursEndMinutes = const Value.absent(),
    Value<String?> lastConnectedDeviceId = const Value.absent(),
    bool? autoConnectEnabled,
  }) => Setting(
    id: id ?? this.id,
    useFahrenheit: useFahrenheit ?? this.useFahrenheit,
    lowThresholdC: lowThresholdC ?? this.lowThresholdC,
    highThresholdC: highThresholdC ?? this.highThresholdC,
    pollingIntervalSeconds:
        pollingIntervalSeconds ?? this.pollingIntervalSeconds,
    quietHoursStartMinutes:
        quietHoursStartMinutes.present
            ? quietHoursStartMinutes.value
            : this.quietHoursStartMinutes,
    quietHoursEndMinutes:
        quietHoursEndMinutes.present
            ? quietHoursEndMinutes.value
            : this.quietHoursEndMinutes,
    lastConnectedDeviceId:
        lastConnectedDeviceId.present
            ? lastConnectedDeviceId.value
            : this.lastConnectedDeviceId,
    autoConnectEnabled: autoConnectEnabled ?? this.autoConnectEnabled,
  );
  Setting copyWithCompanion(SettingsCompanion data) {
    return Setting(
      id: data.id.present ? data.id.value : this.id,
      useFahrenheit:
          data.useFahrenheit.present
              ? data.useFahrenheit.value
              : this.useFahrenheit,
      lowThresholdC:
          data.lowThresholdC.present
              ? data.lowThresholdC.value
              : this.lowThresholdC,
      highThresholdC:
          data.highThresholdC.present
              ? data.highThresholdC.value
              : this.highThresholdC,
      pollingIntervalSeconds:
          data.pollingIntervalSeconds.present
              ? data.pollingIntervalSeconds.value
              : this.pollingIntervalSeconds,
      quietHoursStartMinutes:
          data.quietHoursStartMinutes.present
              ? data.quietHoursStartMinutes.value
              : this.quietHoursStartMinutes,
      quietHoursEndMinutes:
          data.quietHoursEndMinutes.present
              ? data.quietHoursEndMinutes.value
              : this.quietHoursEndMinutes,
      lastConnectedDeviceId:
          data.lastConnectedDeviceId.present
              ? data.lastConnectedDeviceId.value
              : this.lastConnectedDeviceId,
      autoConnectEnabled:
          data.autoConnectEnabled.present
              ? data.autoConnectEnabled.value
              : this.autoConnectEnabled,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Setting(')
          ..write('id: $id, ')
          ..write('useFahrenheit: $useFahrenheit, ')
          ..write('lowThresholdC: $lowThresholdC, ')
          ..write('highThresholdC: $highThresholdC, ')
          ..write('pollingIntervalSeconds: $pollingIntervalSeconds, ')
          ..write('quietHoursStartMinutes: $quietHoursStartMinutes, ')
          ..write('quietHoursEndMinutes: $quietHoursEndMinutes, ')
          ..write('lastConnectedDeviceId: $lastConnectedDeviceId, ')
          ..write('autoConnectEnabled: $autoConnectEnabled')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    useFahrenheit,
    lowThresholdC,
    highThresholdC,
    pollingIntervalSeconds,
    quietHoursStartMinutes,
    quietHoursEndMinutes,
    lastConnectedDeviceId,
    autoConnectEnabled,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Setting &&
          other.id == this.id &&
          other.useFahrenheit == this.useFahrenheit &&
          other.lowThresholdC == this.lowThresholdC &&
          other.highThresholdC == this.highThresholdC &&
          other.pollingIntervalSeconds == this.pollingIntervalSeconds &&
          other.quietHoursStartMinutes == this.quietHoursStartMinutes &&
          other.quietHoursEndMinutes == this.quietHoursEndMinutes &&
          other.lastConnectedDeviceId == this.lastConnectedDeviceId &&
          other.autoConnectEnabled == this.autoConnectEnabled);
}

class SettingsCompanion extends UpdateCompanion<Setting> {
  final Value<int> id;
  final Value<bool> useFahrenheit;
  final Value<double> lowThresholdC;
  final Value<double> highThresholdC;
  final Value<int> pollingIntervalSeconds;
  final Value<int?> quietHoursStartMinutes;
  final Value<int?> quietHoursEndMinutes;
  final Value<String?> lastConnectedDeviceId;
  final Value<bool> autoConnectEnabled;
  const SettingsCompanion({
    this.id = const Value.absent(),
    this.useFahrenheit = const Value.absent(),
    this.lowThresholdC = const Value.absent(),
    this.highThresholdC = const Value.absent(),
    this.pollingIntervalSeconds = const Value.absent(),
    this.quietHoursStartMinutes = const Value.absent(),
    this.quietHoursEndMinutes = const Value.absent(),
    this.lastConnectedDeviceId = const Value.absent(),
    this.autoConnectEnabled = const Value.absent(),
  });
  SettingsCompanion.insert({
    this.id = const Value.absent(),
    this.useFahrenheit = const Value.absent(),
    this.lowThresholdC = const Value.absent(),
    this.highThresholdC = const Value.absent(),
    this.pollingIntervalSeconds = const Value.absent(),
    this.quietHoursStartMinutes = const Value.absent(),
    this.quietHoursEndMinutes = const Value.absent(),
    this.lastConnectedDeviceId = const Value.absent(),
    this.autoConnectEnabled = const Value.absent(),
  });
  static Insertable<Setting> custom({
    Expression<int>? id,
    Expression<bool>? useFahrenheit,
    Expression<double>? lowThresholdC,
    Expression<double>? highThresholdC,
    Expression<int>? pollingIntervalSeconds,
    Expression<int>? quietHoursStartMinutes,
    Expression<int>? quietHoursEndMinutes,
    Expression<String>? lastConnectedDeviceId,
    Expression<bool>? autoConnectEnabled,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (useFahrenheit != null) 'use_fahrenheit': useFahrenheit,
      if (lowThresholdC != null) 'low_threshold_c': lowThresholdC,
      if (highThresholdC != null) 'high_threshold_c': highThresholdC,
      if (pollingIntervalSeconds != null)
        'polling_interval_seconds': pollingIntervalSeconds,
      if (quietHoursStartMinutes != null)
        'quiet_hours_start_minutes': quietHoursStartMinutes,
      if (quietHoursEndMinutes != null)
        'quiet_hours_end_minutes': quietHoursEndMinutes,
      if (lastConnectedDeviceId != null)
        'last_connected_device_id': lastConnectedDeviceId,
      if (autoConnectEnabled != null)
        'auto_connect_enabled': autoConnectEnabled,
    });
  }

  SettingsCompanion copyWith({
    Value<int>? id,
    Value<bool>? useFahrenheit,
    Value<double>? lowThresholdC,
    Value<double>? highThresholdC,
    Value<int>? pollingIntervalSeconds,
    Value<int?>? quietHoursStartMinutes,
    Value<int?>? quietHoursEndMinutes,
    Value<String?>? lastConnectedDeviceId,
    Value<bool>? autoConnectEnabled,
  }) {
    return SettingsCompanion(
      id: id ?? this.id,
      useFahrenheit: useFahrenheit ?? this.useFahrenheit,
      lowThresholdC: lowThresholdC ?? this.lowThresholdC,
      highThresholdC: highThresholdC ?? this.highThresholdC,
      pollingIntervalSeconds:
          pollingIntervalSeconds ?? this.pollingIntervalSeconds,
      quietHoursStartMinutes:
          quietHoursStartMinutes ?? this.quietHoursStartMinutes,
      quietHoursEndMinutes: quietHoursEndMinutes ?? this.quietHoursEndMinutes,
      lastConnectedDeviceId:
          lastConnectedDeviceId ?? this.lastConnectedDeviceId,
      autoConnectEnabled: autoConnectEnabled ?? this.autoConnectEnabled,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (useFahrenheit.present) {
      map['use_fahrenheit'] = Variable<bool>(useFahrenheit.value);
    }
    if (lowThresholdC.present) {
      map['low_threshold_c'] = Variable<double>(lowThresholdC.value);
    }
    if (highThresholdC.present) {
      map['high_threshold_c'] = Variable<double>(highThresholdC.value);
    }
    if (pollingIntervalSeconds.present) {
      map['polling_interval_seconds'] = Variable<int>(
        pollingIntervalSeconds.value,
      );
    }
    if (quietHoursStartMinutes.present) {
      map['quiet_hours_start_minutes'] = Variable<int>(
        quietHoursStartMinutes.value,
      );
    }
    if (quietHoursEndMinutes.present) {
      map['quiet_hours_end_minutes'] = Variable<int>(
        quietHoursEndMinutes.value,
      );
    }
    if (lastConnectedDeviceId.present) {
      map['last_connected_device_id'] = Variable<String>(
        lastConnectedDeviceId.value,
      );
    }
    if (autoConnectEnabled.present) {
      map['auto_connect_enabled'] = Variable<bool>(autoConnectEnabled.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SettingsCompanion(')
          ..write('id: $id, ')
          ..write('useFahrenheit: $useFahrenheit, ')
          ..write('lowThresholdC: $lowThresholdC, ')
          ..write('highThresholdC: $highThresholdC, ')
          ..write('pollingIntervalSeconds: $pollingIntervalSeconds, ')
          ..write('quietHoursStartMinutes: $quietHoursStartMinutes, ')
          ..write('quietHoursEndMinutes: $quietHoursEndMinutes, ')
          ..write('lastConnectedDeviceId: $lastConnectedDeviceId, ')
          ..write('autoConnectEnabled: $autoConnectEnabled')
          ..write(')'))
        .toString();
  }
}

class $AlertEventsTable extends AlertEvents
    with TableInfo<$AlertEventsTable, AlertEvent> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AlertEventsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _timestampMeta = const VerificationMeta(
    'timestamp',
  );
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
    'timestamp',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _temperatureCMeta = const VerificationMeta(
    'temperatureC',
  );
  @override
  late final GeneratedColumn<double> temperatureC = GeneratedColumn<double>(
    'temperature_c',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _humidityPercentMeta = const VerificationMeta(
    'humidityPercent',
  );
  @override
  late final GeneratedColumn<double> humidityPercent = GeneratedColumn<double>(
    'humidity_percent',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isHighThresholdMeta = const VerificationMeta(
    'isHighThreshold',
  );
  @override
  late final GeneratedColumn<bool> isHighThreshold = GeneratedColumn<bool>(
    'is_high_threshold',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_high_threshold" IN (0, 1))',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    deviceId,
    timestamp,
    temperatureC,
    humidityPercent,
    isHighThreshold,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'alert_events';
  @override
  VerificationContext validateIntegrity(
    Insertable<AlertEvent> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_deviceIdMeta);
    }
    if (data.containsKey('timestamp')) {
      context.handle(
        _timestampMeta,
        timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta),
      );
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    if (data.containsKey('temperature_c')) {
      context.handle(
        _temperatureCMeta,
        temperatureC.isAcceptableOrUnknown(
          data['temperature_c']!,
          _temperatureCMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_temperatureCMeta);
    }
    if (data.containsKey('humidity_percent')) {
      context.handle(
        _humidityPercentMeta,
        humidityPercent.isAcceptableOrUnknown(
          data['humidity_percent']!,
          _humidityPercentMeta,
        ),
      );
    }
    if (data.containsKey('is_high_threshold')) {
      context.handle(
        _isHighThresholdMeta,
        isHighThreshold.isAcceptableOrUnknown(
          data['is_high_threshold']!,
          _isHighThresholdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_isHighThresholdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AlertEvent map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AlertEvent(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      deviceId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}device_id'],
          )!,
      timestamp:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}timestamp'],
          )!,
      temperatureC:
          attachedDatabase.typeMapping.read(
            DriftSqlType.double,
            data['${effectivePrefix}temperature_c'],
          )!,
      humidityPercent: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}humidity_percent'],
      ),
      isHighThreshold:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}is_high_threshold'],
          )!,
    );
  }

  @override
  $AlertEventsTable createAlias(String alias) {
    return $AlertEventsTable(attachedDatabase, alias);
  }
}

class AlertEvent extends DataClass implements Insertable<AlertEvent> {
  final int id;
  final String deviceId;
  final DateTime timestamp;
  final double temperatureC;
  final double? humidityPercent;
  final bool isHighThreshold;
  const AlertEvent({
    required this.id,
    required this.deviceId,
    required this.timestamp,
    required this.temperatureC,
    this.humidityPercent,
    required this.isHighThreshold,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['device_id'] = Variable<String>(deviceId);
    map['timestamp'] = Variable<DateTime>(timestamp);
    map['temperature_c'] = Variable<double>(temperatureC);
    if (!nullToAbsent || humidityPercent != null) {
      map['humidity_percent'] = Variable<double>(humidityPercent);
    }
    map['is_high_threshold'] = Variable<bool>(isHighThreshold);
    return map;
  }

  AlertEventsCompanion toCompanion(bool nullToAbsent) {
    return AlertEventsCompanion(
      id: Value(id),
      deviceId: Value(deviceId),
      timestamp: Value(timestamp),
      temperatureC: Value(temperatureC),
      humidityPercent:
          humidityPercent == null && nullToAbsent
              ? const Value.absent()
              : Value(humidityPercent),
      isHighThreshold: Value(isHighThreshold),
    );
  }

  factory AlertEvent.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AlertEvent(
      id: serializer.fromJson<int>(json['id']),
      deviceId: serializer.fromJson<String>(json['deviceId']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
      temperatureC: serializer.fromJson<double>(json['temperatureC']),
      humidityPercent: serializer.fromJson<double?>(json['humidityPercent']),
      isHighThreshold: serializer.fromJson<bool>(json['isHighThreshold']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'deviceId': serializer.toJson<String>(deviceId),
      'timestamp': serializer.toJson<DateTime>(timestamp),
      'temperatureC': serializer.toJson<double>(temperatureC),
      'humidityPercent': serializer.toJson<double?>(humidityPercent),
      'isHighThreshold': serializer.toJson<bool>(isHighThreshold),
    };
  }

  AlertEvent copyWith({
    int? id,
    String? deviceId,
    DateTime? timestamp,
    double? temperatureC,
    Value<double?> humidityPercent = const Value.absent(),
    bool? isHighThreshold,
  }) => AlertEvent(
    id: id ?? this.id,
    deviceId: deviceId ?? this.deviceId,
    timestamp: timestamp ?? this.timestamp,
    temperatureC: temperatureC ?? this.temperatureC,
    humidityPercent:
        humidityPercent.present ? humidityPercent.value : this.humidityPercent,
    isHighThreshold: isHighThreshold ?? this.isHighThreshold,
  );
  AlertEvent copyWithCompanion(AlertEventsCompanion data) {
    return AlertEvent(
      id: data.id.present ? data.id.value : this.id,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
      temperatureC:
          data.temperatureC.present
              ? data.temperatureC.value
              : this.temperatureC,
      humidityPercent:
          data.humidityPercent.present
              ? data.humidityPercent.value
              : this.humidityPercent,
      isHighThreshold:
          data.isHighThreshold.present
              ? data.isHighThreshold.value
              : this.isHighThreshold,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AlertEvent(')
          ..write('id: $id, ')
          ..write('deviceId: $deviceId, ')
          ..write('timestamp: $timestamp, ')
          ..write('temperatureC: $temperatureC, ')
          ..write('humidityPercent: $humidityPercent, ')
          ..write('isHighThreshold: $isHighThreshold')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    deviceId,
    timestamp,
    temperatureC,
    humidityPercent,
    isHighThreshold,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AlertEvent &&
          other.id == this.id &&
          other.deviceId == this.deviceId &&
          other.timestamp == this.timestamp &&
          other.temperatureC == this.temperatureC &&
          other.humidityPercent == this.humidityPercent &&
          other.isHighThreshold == this.isHighThreshold);
}

class AlertEventsCompanion extends UpdateCompanion<AlertEvent> {
  final Value<int> id;
  final Value<String> deviceId;
  final Value<DateTime> timestamp;
  final Value<double> temperatureC;
  final Value<double?> humidityPercent;
  final Value<bool> isHighThreshold;
  const AlertEventsCompanion({
    this.id = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.temperatureC = const Value.absent(),
    this.humidityPercent = const Value.absent(),
    this.isHighThreshold = const Value.absent(),
  });
  AlertEventsCompanion.insert({
    this.id = const Value.absent(),
    required String deviceId,
    required DateTime timestamp,
    required double temperatureC,
    this.humidityPercent = const Value.absent(),
    required bool isHighThreshold,
  }) : deviceId = Value(deviceId),
       timestamp = Value(timestamp),
       temperatureC = Value(temperatureC),
       isHighThreshold = Value(isHighThreshold);
  static Insertable<AlertEvent> custom({
    Expression<int>? id,
    Expression<String>? deviceId,
    Expression<DateTime>? timestamp,
    Expression<double>? temperatureC,
    Expression<double>? humidityPercent,
    Expression<bool>? isHighThreshold,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (deviceId != null) 'device_id': deviceId,
      if (timestamp != null) 'timestamp': timestamp,
      if (temperatureC != null) 'temperature_c': temperatureC,
      if (humidityPercent != null) 'humidity_percent': humidityPercent,
      if (isHighThreshold != null) 'is_high_threshold': isHighThreshold,
    });
  }

  AlertEventsCompanion copyWith({
    Value<int>? id,
    Value<String>? deviceId,
    Value<DateTime>? timestamp,
    Value<double>? temperatureC,
    Value<double?>? humidityPercent,
    Value<bool>? isHighThreshold,
  }) {
    return AlertEventsCompanion(
      id: id ?? this.id,
      deviceId: deviceId ?? this.deviceId,
      timestamp: timestamp ?? this.timestamp,
      temperatureC: temperatureC ?? this.temperatureC,
      humidityPercent: humidityPercent ?? this.humidityPercent,
      isHighThreshold: isHighThreshold ?? this.isHighThreshold,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    if (temperatureC.present) {
      map['temperature_c'] = Variable<double>(temperatureC.value);
    }
    if (humidityPercent.present) {
      map['humidity_percent'] = Variable<double>(humidityPercent.value);
    }
    if (isHighThreshold.present) {
      map['is_high_threshold'] = Variable<bool>(isHighThreshold.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AlertEventsCompanion(')
          ..write('id: $id, ')
          ..write('deviceId: $deviceId, ')
          ..write('timestamp: $timestamp, ')
          ..write('temperatureC: $temperatureC, ')
          ..write('humidityPercent: $humidityPercent, ')
          ..write('isHighThreshold: $isHighThreshold')
          ..write(')'))
        .toString();
  }
}

class $DeviceLabelsTable extends DeviceLabels
    with TableInfo<$DeviceLabelsTable, DeviceLabel> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DeviceLabelsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
    'label',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, deviceId, label];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'device_labels';
  @override
  VerificationContext validateIntegrity(
    Insertable<DeviceLabel> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_deviceIdMeta);
    }
    if (data.containsKey('label')) {
      context.handle(
        _labelMeta,
        label.isAcceptableOrUnknown(data['label']!, _labelMeta),
      );
    } else if (isInserting) {
      context.missing(_labelMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DeviceLabel map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DeviceLabel(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      deviceId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}device_id'],
          )!,
      label:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}label'],
          )!,
    );
  }

  @override
  $DeviceLabelsTable createAlias(String alias) {
    return $DeviceLabelsTable(attachedDatabase, alias);
  }
}

class DeviceLabel extends DataClass implements Insertable<DeviceLabel> {
  final int id;
  final String deviceId;
  final String label;
  const DeviceLabel({
    required this.id,
    required this.deviceId,
    required this.label,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['device_id'] = Variable<String>(deviceId);
    map['label'] = Variable<String>(label);
    return map;
  }

  DeviceLabelsCompanion toCompanion(bool nullToAbsent) {
    return DeviceLabelsCompanion(
      id: Value(id),
      deviceId: Value(deviceId),
      label: Value(label),
    );
  }

  factory DeviceLabel.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DeviceLabel(
      id: serializer.fromJson<int>(json['id']),
      deviceId: serializer.fromJson<String>(json['deviceId']),
      label: serializer.fromJson<String>(json['label']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'deviceId': serializer.toJson<String>(deviceId),
      'label': serializer.toJson<String>(label),
    };
  }

  DeviceLabel copyWith({int? id, String? deviceId, String? label}) =>
      DeviceLabel(
        id: id ?? this.id,
        deviceId: deviceId ?? this.deviceId,
        label: label ?? this.label,
      );
  DeviceLabel copyWithCompanion(DeviceLabelsCompanion data) {
    return DeviceLabel(
      id: data.id.present ? data.id.value : this.id,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      label: data.label.present ? data.label.value : this.label,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DeviceLabel(')
          ..write('id: $id, ')
          ..write('deviceId: $deviceId, ')
          ..write('label: $label')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, deviceId, label);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DeviceLabel &&
          other.id == this.id &&
          other.deviceId == this.deviceId &&
          other.label == this.label);
}

class DeviceLabelsCompanion extends UpdateCompanion<DeviceLabel> {
  final Value<int> id;
  final Value<String> deviceId;
  final Value<String> label;
  const DeviceLabelsCompanion({
    this.id = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.label = const Value.absent(),
  });
  DeviceLabelsCompanion.insert({
    this.id = const Value.absent(),
    required String deviceId,
    required String label,
  }) : deviceId = Value(deviceId),
       label = Value(label);
  static Insertable<DeviceLabel> custom({
    Expression<int>? id,
    Expression<String>? deviceId,
    Expression<String>? label,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (deviceId != null) 'device_id': deviceId,
      if (label != null) 'label': label,
    });
  }

  DeviceLabelsCompanion copyWith({
    Value<int>? id,
    Value<String>? deviceId,
    Value<String>? label,
  }) {
    return DeviceLabelsCompanion(
      id: id ?? this.id,
      deviceId: deviceId ?? this.deviceId,
      label: label ?? this.label,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DeviceLabelsCompanion(')
          ..write('id: $id, ')
          ..write('deviceId: $deviceId, ')
          ..write('label: $label')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ReadingsTable readings = $ReadingsTable(this);
  late final $SettingsTable settings = $SettingsTable(this);
  late final $AlertEventsTable alertEvents = $AlertEventsTable(this);
  late final $DeviceLabelsTable deviceLabels = $DeviceLabelsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    readings,
    settings,
    alertEvents,
    deviceLabels,
  ];
}

typedef $$ReadingsTableCreateCompanionBuilder =
    ReadingsCompanion Function({
      Value<int> id,
      required String deviceId,
      required DateTime timestamp,
      required double temperatureC,
      Value<double?> humidityPercent,
    });
typedef $$ReadingsTableUpdateCompanionBuilder =
    ReadingsCompanion Function({
      Value<int> id,
      Value<String> deviceId,
      Value<DateTime> timestamp,
      Value<double> temperatureC,
      Value<double?> humidityPercent,
    });

class $$ReadingsTableFilterComposer
    extends Composer<_$AppDatabase, $ReadingsTable> {
  $$ReadingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get temperatureC => $composableBuilder(
    column: $table.temperatureC,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get humidityPercent => $composableBuilder(
    column: $table.humidityPercent,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ReadingsTableOrderingComposer
    extends Composer<_$AppDatabase, $ReadingsTable> {
  $$ReadingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get temperatureC => $composableBuilder(
    column: $table.temperatureC,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get humidityPercent => $composableBuilder(
    column: $table.humidityPercent,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ReadingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ReadingsTable> {
  $$ReadingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<DateTime> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);

  GeneratedColumn<double> get temperatureC => $composableBuilder(
    column: $table.temperatureC,
    builder: (column) => column,
  );

  GeneratedColumn<double> get humidityPercent => $composableBuilder(
    column: $table.humidityPercent,
    builder: (column) => column,
  );
}

class $$ReadingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ReadingsTable,
          Reading,
          $$ReadingsTableFilterComposer,
          $$ReadingsTableOrderingComposer,
          $$ReadingsTableAnnotationComposer,
          $$ReadingsTableCreateCompanionBuilder,
          $$ReadingsTableUpdateCompanionBuilder,
          (Reading, BaseReferences<_$AppDatabase, $ReadingsTable, Reading>),
          Reading,
          PrefetchHooks Function()
        > {
  $$ReadingsTableTableManager(_$AppDatabase db, $ReadingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$ReadingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$ReadingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$ReadingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> deviceId = const Value.absent(),
                Value<DateTime> timestamp = const Value.absent(),
                Value<double> temperatureC = const Value.absent(),
                Value<double?> humidityPercent = const Value.absent(),
              }) => ReadingsCompanion(
                id: id,
                deviceId: deviceId,
                timestamp: timestamp,
                temperatureC: temperatureC,
                humidityPercent: humidityPercent,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String deviceId,
                required DateTime timestamp,
                required double temperatureC,
                Value<double?> humidityPercent = const Value.absent(),
              }) => ReadingsCompanion.insert(
                id: id,
                deviceId: deviceId,
                timestamp: timestamp,
                temperatureC: temperatureC,
                humidityPercent: humidityPercent,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ReadingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ReadingsTable,
      Reading,
      $$ReadingsTableFilterComposer,
      $$ReadingsTableOrderingComposer,
      $$ReadingsTableAnnotationComposer,
      $$ReadingsTableCreateCompanionBuilder,
      $$ReadingsTableUpdateCompanionBuilder,
      (Reading, BaseReferences<_$AppDatabase, $ReadingsTable, Reading>),
      Reading,
      PrefetchHooks Function()
    >;
typedef $$SettingsTableCreateCompanionBuilder =
    SettingsCompanion Function({
      Value<int> id,
      Value<bool> useFahrenheit,
      Value<double> lowThresholdC,
      Value<double> highThresholdC,
      Value<int> pollingIntervalSeconds,
      Value<int?> quietHoursStartMinutes,
      Value<int?> quietHoursEndMinutes,
      Value<String?> lastConnectedDeviceId,
      Value<bool> autoConnectEnabled,
    });
typedef $$SettingsTableUpdateCompanionBuilder =
    SettingsCompanion Function({
      Value<int> id,
      Value<bool> useFahrenheit,
      Value<double> lowThresholdC,
      Value<double> highThresholdC,
      Value<int> pollingIntervalSeconds,
      Value<int?> quietHoursStartMinutes,
      Value<int?> quietHoursEndMinutes,
      Value<String?> lastConnectedDeviceId,
      Value<bool> autoConnectEnabled,
    });

class $$SettingsTableFilterComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get useFahrenheit => $composableBuilder(
    column: $table.useFahrenheit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get lowThresholdC => $composableBuilder(
    column: $table.lowThresholdC,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get highThresholdC => $composableBuilder(
    column: $table.highThresholdC,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get pollingIntervalSeconds => $composableBuilder(
    column: $table.pollingIntervalSeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get quietHoursStartMinutes => $composableBuilder(
    column: $table.quietHoursStartMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get quietHoursEndMinutes => $composableBuilder(
    column: $table.quietHoursEndMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastConnectedDeviceId => $composableBuilder(
    column: $table.lastConnectedDeviceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get autoConnectEnabled => $composableBuilder(
    column: $table.autoConnectEnabled,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get useFahrenheit => $composableBuilder(
    column: $table.useFahrenheit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get lowThresholdC => $composableBuilder(
    column: $table.lowThresholdC,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get highThresholdC => $composableBuilder(
    column: $table.highThresholdC,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get pollingIntervalSeconds => $composableBuilder(
    column: $table.pollingIntervalSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get quietHoursStartMinutes => $composableBuilder(
    column: $table.quietHoursStartMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get quietHoursEndMinutes => $composableBuilder(
    column: $table.quietHoursEndMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastConnectedDeviceId => $composableBuilder(
    column: $table.lastConnectedDeviceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get autoConnectEnabled => $composableBuilder(
    column: $table.autoConnectEnabled,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<bool> get useFahrenheit => $composableBuilder(
    column: $table.useFahrenheit,
    builder: (column) => column,
  );

  GeneratedColumn<double> get lowThresholdC => $composableBuilder(
    column: $table.lowThresholdC,
    builder: (column) => column,
  );

  GeneratedColumn<double> get highThresholdC => $composableBuilder(
    column: $table.highThresholdC,
    builder: (column) => column,
  );

  GeneratedColumn<int> get pollingIntervalSeconds => $composableBuilder(
    column: $table.pollingIntervalSeconds,
    builder: (column) => column,
  );

  GeneratedColumn<int> get quietHoursStartMinutes => $composableBuilder(
    column: $table.quietHoursStartMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get quietHoursEndMinutes => $composableBuilder(
    column: $table.quietHoursEndMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<String> get lastConnectedDeviceId => $composableBuilder(
    column: $table.lastConnectedDeviceId,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get autoConnectEnabled => $composableBuilder(
    column: $table.autoConnectEnabled,
    builder: (column) => column,
  );
}

class $$SettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SettingsTable,
          Setting,
          $$SettingsTableFilterComposer,
          $$SettingsTableOrderingComposer,
          $$SettingsTableAnnotationComposer,
          $$SettingsTableCreateCompanionBuilder,
          $$SettingsTableUpdateCompanionBuilder,
          (Setting, BaseReferences<_$AppDatabase, $SettingsTable, Setting>),
          Setting,
          PrefetchHooks Function()
        > {
  $$SettingsTableTableManager(_$AppDatabase db, $SettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$SettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$SettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$SettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<bool> useFahrenheit = const Value.absent(),
                Value<double> lowThresholdC = const Value.absent(),
                Value<double> highThresholdC = const Value.absent(),
                Value<int> pollingIntervalSeconds = const Value.absent(),
                Value<int?> quietHoursStartMinutes = const Value.absent(),
                Value<int?> quietHoursEndMinutes = const Value.absent(),
                Value<String?> lastConnectedDeviceId = const Value.absent(),
                Value<bool> autoConnectEnabled = const Value.absent(),
              }) => SettingsCompanion(
                id: id,
                useFahrenheit: useFahrenheit,
                lowThresholdC: lowThresholdC,
                highThresholdC: highThresholdC,
                pollingIntervalSeconds: pollingIntervalSeconds,
                quietHoursStartMinutes: quietHoursStartMinutes,
                quietHoursEndMinutes: quietHoursEndMinutes,
                lastConnectedDeviceId: lastConnectedDeviceId,
                autoConnectEnabled: autoConnectEnabled,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<bool> useFahrenheit = const Value.absent(),
                Value<double> lowThresholdC = const Value.absent(),
                Value<double> highThresholdC = const Value.absent(),
                Value<int> pollingIntervalSeconds = const Value.absent(),
                Value<int?> quietHoursStartMinutes = const Value.absent(),
                Value<int?> quietHoursEndMinutes = const Value.absent(),
                Value<String?> lastConnectedDeviceId = const Value.absent(),
                Value<bool> autoConnectEnabled = const Value.absent(),
              }) => SettingsCompanion.insert(
                id: id,
                useFahrenheit: useFahrenheit,
                lowThresholdC: lowThresholdC,
                highThresholdC: highThresholdC,
                pollingIntervalSeconds: pollingIntervalSeconds,
                quietHoursStartMinutes: quietHoursStartMinutes,
                quietHoursEndMinutes: quietHoursEndMinutes,
                lastConnectedDeviceId: lastConnectedDeviceId,
                autoConnectEnabled: autoConnectEnabled,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SettingsTable,
      Setting,
      $$SettingsTableFilterComposer,
      $$SettingsTableOrderingComposer,
      $$SettingsTableAnnotationComposer,
      $$SettingsTableCreateCompanionBuilder,
      $$SettingsTableUpdateCompanionBuilder,
      (Setting, BaseReferences<_$AppDatabase, $SettingsTable, Setting>),
      Setting,
      PrefetchHooks Function()
    >;
typedef $$AlertEventsTableCreateCompanionBuilder =
    AlertEventsCompanion Function({
      Value<int> id,
      required String deviceId,
      required DateTime timestamp,
      required double temperatureC,
      Value<double?> humidityPercent,
      required bool isHighThreshold,
    });
typedef $$AlertEventsTableUpdateCompanionBuilder =
    AlertEventsCompanion Function({
      Value<int> id,
      Value<String> deviceId,
      Value<DateTime> timestamp,
      Value<double> temperatureC,
      Value<double?> humidityPercent,
      Value<bool> isHighThreshold,
    });

class $$AlertEventsTableFilterComposer
    extends Composer<_$AppDatabase, $AlertEventsTable> {
  $$AlertEventsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get temperatureC => $composableBuilder(
    column: $table.temperatureC,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get humidityPercent => $composableBuilder(
    column: $table.humidityPercent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isHighThreshold => $composableBuilder(
    column: $table.isHighThreshold,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AlertEventsTableOrderingComposer
    extends Composer<_$AppDatabase, $AlertEventsTable> {
  $$AlertEventsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get temperatureC => $composableBuilder(
    column: $table.temperatureC,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get humidityPercent => $composableBuilder(
    column: $table.humidityPercent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isHighThreshold => $composableBuilder(
    column: $table.isHighThreshold,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AlertEventsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AlertEventsTable> {
  $$AlertEventsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<DateTime> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);

  GeneratedColumn<double> get temperatureC => $composableBuilder(
    column: $table.temperatureC,
    builder: (column) => column,
  );

  GeneratedColumn<double> get humidityPercent => $composableBuilder(
    column: $table.humidityPercent,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isHighThreshold => $composableBuilder(
    column: $table.isHighThreshold,
    builder: (column) => column,
  );
}

class $$AlertEventsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AlertEventsTable,
          AlertEvent,
          $$AlertEventsTableFilterComposer,
          $$AlertEventsTableOrderingComposer,
          $$AlertEventsTableAnnotationComposer,
          $$AlertEventsTableCreateCompanionBuilder,
          $$AlertEventsTableUpdateCompanionBuilder,
          (
            AlertEvent,
            BaseReferences<_$AppDatabase, $AlertEventsTable, AlertEvent>,
          ),
          AlertEvent,
          PrefetchHooks Function()
        > {
  $$AlertEventsTableTableManager(_$AppDatabase db, $AlertEventsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$AlertEventsTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$AlertEventsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () =>
                  $$AlertEventsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> deviceId = const Value.absent(),
                Value<DateTime> timestamp = const Value.absent(),
                Value<double> temperatureC = const Value.absent(),
                Value<double?> humidityPercent = const Value.absent(),
                Value<bool> isHighThreshold = const Value.absent(),
              }) => AlertEventsCompanion(
                id: id,
                deviceId: deviceId,
                timestamp: timestamp,
                temperatureC: temperatureC,
                humidityPercent: humidityPercent,
                isHighThreshold: isHighThreshold,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String deviceId,
                required DateTime timestamp,
                required double temperatureC,
                Value<double?> humidityPercent = const Value.absent(),
                required bool isHighThreshold,
              }) => AlertEventsCompanion.insert(
                id: id,
                deviceId: deviceId,
                timestamp: timestamp,
                temperatureC: temperatureC,
                humidityPercent: humidityPercent,
                isHighThreshold: isHighThreshold,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AlertEventsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AlertEventsTable,
      AlertEvent,
      $$AlertEventsTableFilterComposer,
      $$AlertEventsTableOrderingComposer,
      $$AlertEventsTableAnnotationComposer,
      $$AlertEventsTableCreateCompanionBuilder,
      $$AlertEventsTableUpdateCompanionBuilder,
      (
        AlertEvent,
        BaseReferences<_$AppDatabase, $AlertEventsTable, AlertEvent>,
      ),
      AlertEvent,
      PrefetchHooks Function()
    >;
typedef $$DeviceLabelsTableCreateCompanionBuilder =
    DeviceLabelsCompanion Function({
      Value<int> id,
      required String deviceId,
      required String label,
    });
typedef $$DeviceLabelsTableUpdateCompanionBuilder =
    DeviceLabelsCompanion Function({
      Value<int> id,
      Value<String> deviceId,
      Value<String> label,
    });

class $$DeviceLabelsTableFilterComposer
    extends Composer<_$AppDatabase, $DeviceLabelsTable> {
  $$DeviceLabelsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DeviceLabelsTableOrderingComposer
    extends Composer<_$AppDatabase, $DeviceLabelsTable> {
  $$DeviceLabelsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DeviceLabelsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DeviceLabelsTable> {
  $$DeviceLabelsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);
}

class $$DeviceLabelsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DeviceLabelsTable,
          DeviceLabel,
          $$DeviceLabelsTableFilterComposer,
          $$DeviceLabelsTableOrderingComposer,
          $$DeviceLabelsTableAnnotationComposer,
          $$DeviceLabelsTableCreateCompanionBuilder,
          $$DeviceLabelsTableUpdateCompanionBuilder,
          (
            DeviceLabel,
            BaseReferences<_$AppDatabase, $DeviceLabelsTable, DeviceLabel>,
          ),
          DeviceLabel,
          PrefetchHooks Function()
        > {
  $$DeviceLabelsTableTableManager(_$AppDatabase db, $DeviceLabelsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$DeviceLabelsTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$DeviceLabelsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () =>
                  $$DeviceLabelsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> deviceId = const Value.absent(),
                Value<String> label = const Value.absent(),
              }) => DeviceLabelsCompanion(
                id: id,
                deviceId: deviceId,
                label: label,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String deviceId,
                required String label,
              }) => DeviceLabelsCompanion.insert(
                id: id,
                deviceId: deviceId,
                label: label,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DeviceLabelsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DeviceLabelsTable,
      DeviceLabel,
      $$DeviceLabelsTableFilterComposer,
      $$DeviceLabelsTableOrderingComposer,
      $$DeviceLabelsTableAnnotationComposer,
      $$DeviceLabelsTableCreateCompanionBuilder,
      $$DeviceLabelsTableUpdateCompanionBuilder,
      (
        DeviceLabel,
        BaseReferences<_$AppDatabase, $DeviceLabelsTable, DeviceLabel>,
      ),
      DeviceLabel,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ReadingsTableTableManager get readings =>
      $$ReadingsTableTableManager(_db, _db.readings);
  $$SettingsTableTableManager get settings =>
      $$SettingsTableTableManager(_db, _db.settings);
  $$AlertEventsTableTableManager get alertEvents =>
      $$AlertEventsTableTableManager(_db, _db.alertEvents);
  $$DeviceLabelsTableTableManager get deviceLabels =>
      $$DeviceLabelsTableTableManager(_db, _db.deviceLabels);
}
