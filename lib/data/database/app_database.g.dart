// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $ProfilesTable extends Profiles
    with TableInfo<$ProfilesTable, ProfileRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProfilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<EmploymentType, String>
  employmentType = GeneratedColumn<String>(
    'employment_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<EmploymentType>($ProfilesTable.$converteremploymentType);
  @override
  late final GeneratedColumnWithTypeConverter<DateTime, String>
  employmentStartDate = GeneratedColumn<String>(
    'employment_start_date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<DateTime>($ProfilesTable.$converteremploymentStartDate);
  @override
  late final GeneratedColumnWithTypeConverter<DateTime?, String> birthDate =
      GeneratedColumn<String>(
        'birth_date',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<DateTime?>($ProfilesTable.$converterbirthDaten);
  @override
  late final GeneratedColumnWithTypeConverter<List<int>, String> workDays =
      GeneratedColumn<String>(
        'work_days',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<List<int>>($ProfilesTable.$converterworkDays);
  static const VerificationMeta _weeklyRestDayMeta = const VerificationMeta(
    'weeklyRestDay',
  );
  @override
  late final GeneratedColumn<int> weeklyRestDay = GeneratedColumn<int>(
    'weekly_rest_day',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _saturdayCountsAsLeaveMeta =
      const VerificationMeta('saturdayCountsAsLeave');
  @override
  late final GeneratedColumn<bool> saturdayCountsAsLeave =
      GeneratedColumn<bool>(
        'saturday_counts_as_leave',
        aliasedName,
        false,
        type: DriftSqlType.bool,
        requiredDuringInsert: true,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("saturday_counts_as_leave" IN (0, 1))',
        ),
      );
  @override
  late final GeneratedColumnWithTypeConverter<HalfDayDeduction, String>
  halfDayDeduction = GeneratedColumn<String>(
    'half_day_deduction',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<HalfDayDeduction>($ProfilesTable.$converterhalfDayDeduction);
  static const VerificationMeta _dailyWorkingHoursMeta = const VerificationMeta(
    'dailyWorkingHours',
  );
  @override
  late final GeneratedColumn<double> dailyWorkingHours =
      GeneratedColumn<double>(
        'daily_working_hours',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _priorServiceYearsMeta = const VerificationMeta(
    'priorServiceYears',
  );
  @override
  late final GeneratedColumn<int> priorServiceYears = GeneratedColumn<int>(
    'prior_service_years',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _priorServiceMonthsMeta =
      const VerificationMeta('priorServiceMonths');
  @override
  late final GeneratedColumn<int> priorServiceMonths = GeneratedColumn<int>(
    'prior_service_months',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _priorServiceDaysMeta = const VerificationMeta(
    'priorServiceDays',
  );
  @override
  late final GeneratedColumn<int> priorServiceDays = GeneratedColumn<int>(
    'prior_service_days',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isUndergroundMeta = const VerificationMeta(
    'isUnderground',
  );
  @override
  late final GeneratedColumn<bool> isUnderground = GeneratedColumn<bool>(
    'is_underground',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_underground" IN (0, 1))',
    ),
  );
  static const VerificationMeta _contractExtraDaysMeta = const VerificationMeta(
    'contractExtraDays',
  );
  @override
  late final GeneratedColumn<int> contractExtraDays = GeneratedColumn<int>(
    'contract_extra_days',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _leaveUsedBeforeTrackingMeta =
      const VerificationMeta('leaveUsedBeforeTracking');
  @override
  late final GeneratedColumn<double> leaveUsedBeforeTracking =
      GeneratedColumn<double>(
        'leave_used_before_tracking',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _isTeacherMeta = const VerificationMeta(
    'isTeacher',
  );
  @override
  late final GeneratedColumn<bool> isTeacher = GeneratedColumn<bool>(
    'is_teacher',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_teacher" IN (0, 1))',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<List<DateTime>, String>
  administrativeLeaveDays =
      GeneratedColumn<String>(
        'administrative_leave_days',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<List<DateTime>>(
        $ProfilesTable.$converteradministrativeLeaveDays,
      );
  @override
  late final GeneratedColumnWithTypeConverter<List<DateRange>, String>
  absencePeriods = GeneratedColumn<String>(
    'absence_periods',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<List<DateRange>>($ProfilesTable.$converterabsencePeriods);
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    employmentType,
    employmentStartDate,
    birthDate,
    workDays,
    weeklyRestDay,
    saturdayCountsAsLeave,
    halfDayDeduction,
    dailyWorkingHours,
    priorServiceYears,
    priorServiceMonths,
    priorServiceDays,
    isUnderground,
    contractExtraDays,
    leaveUsedBeforeTracking,
    isTeacher,
    administrativeLeaveDays,
    absencePeriods,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'profiles';
  @override
  VerificationContext validateIntegrity(
    Insertable<ProfileRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('weekly_rest_day')) {
      context.handle(
        _weeklyRestDayMeta,
        weeklyRestDay.isAcceptableOrUnknown(
          data['weekly_rest_day']!,
          _weeklyRestDayMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_weeklyRestDayMeta);
    }
    if (data.containsKey('saturday_counts_as_leave')) {
      context.handle(
        _saturdayCountsAsLeaveMeta,
        saturdayCountsAsLeave.isAcceptableOrUnknown(
          data['saturday_counts_as_leave']!,
          _saturdayCountsAsLeaveMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_saturdayCountsAsLeaveMeta);
    }
    if (data.containsKey('daily_working_hours')) {
      context.handle(
        _dailyWorkingHoursMeta,
        dailyWorkingHours.isAcceptableOrUnknown(
          data['daily_working_hours']!,
          _dailyWorkingHoursMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_dailyWorkingHoursMeta);
    }
    if (data.containsKey('prior_service_years')) {
      context.handle(
        _priorServiceYearsMeta,
        priorServiceYears.isAcceptableOrUnknown(
          data['prior_service_years']!,
          _priorServiceYearsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_priorServiceYearsMeta);
    }
    if (data.containsKey('prior_service_months')) {
      context.handle(
        _priorServiceMonthsMeta,
        priorServiceMonths.isAcceptableOrUnknown(
          data['prior_service_months']!,
          _priorServiceMonthsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_priorServiceMonthsMeta);
    }
    if (data.containsKey('prior_service_days')) {
      context.handle(
        _priorServiceDaysMeta,
        priorServiceDays.isAcceptableOrUnknown(
          data['prior_service_days']!,
          _priorServiceDaysMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_priorServiceDaysMeta);
    }
    if (data.containsKey('is_underground')) {
      context.handle(
        _isUndergroundMeta,
        isUnderground.isAcceptableOrUnknown(
          data['is_underground']!,
          _isUndergroundMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_isUndergroundMeta);
    }
    if (data.containsKey('contract_extra_days')) {
      context.handle(
        _contractExtraDaysMeta,
        contractExtraDays.isAcceptableOrUnknown(
          data['contract_extra_days']!,
          _contractExtraDaysMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_contractExtraDaysMeta);
    }
    if (data.containsKey('leave_used_before_tracking')) {
      context.handle(
        _leaveUsedBeforeTrackingMeta,
        leaveUsedBeforeTracking.isAcceptableOrUnknown(
          data['leave_used_before_tracking']!,
          _leaveUsedBeforeTrackingMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_leaveUsedBeforeTrackingMeta);
    }
    if (data.containsKey('is_teacher')) {
      context.handle(
        _isTeacherMeta,
        isTeacher.isAcceptableOrUnknown(data['is_teacher']!, _isTeacherMeta),
      );
    } else if (isInserting) {
      context.missing(_isTeacherMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProfileRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProfileRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      employmentType: $ProfilesTable.$converteremploymentType.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}employment_type'],
        )!,
      ),
      employmentStartDate: $ProfilesTable.$converteremploymentStartDate.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}employment_start_date'],
        )!,
      ),
      birthDate: $ProfilesTable.$converterbirthDaten.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}birth_date'],
        ),
      ),
      workDays: $ProfilesTable.$converterworkDays.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}work_days'],
        )!,
      ),
      weeklyRestDay: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}weekly_rest_day'],
      )!,
      saturdayCountsAsLeave: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}saturday_counts_as_leave'],
      )!,
      halfDayDeduction: $ProfilesTable.$converterhalfDayDeduction.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}half_day_deduction'],
        )!,
      ),
      dailyWorkingHours: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}daily_working_hours'],
      )!,
      priorServiceYears: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}prior_service_years'],
      )!,
      priorServiceMonths: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}prior_service_months'],
      )!,
      priorServiceDays: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}prior_service_days'],
      )!,
      isUnderground: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_underground'],
      )!,
      contractExtraDays: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}contract_extra_days'],
      )!,
      leaveUsedBeforeTracking: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}leave_used_before_tracking'],
      )!,
      isTeacher: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_teacher'],
      )!,
      administrativeLeaveDays: $ProfilesTable.$converteradministrativeLeaveDays
          .fromSql(
            attachedDatabase.typeMapping.read(
              DriftSqlType.string,
              data['${effectivePrefix}administrative_leave_days'],
            )!,
          ),
      absencePeriods: $ProfilesTable.$converterabsencePeriods.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}absence_periods'],
        )!,
      ),
    );
  }

  @override
  $ProfilesTable createAlias(String alias) {
    return $ProfilesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<EmploymentType, String, String>
  $converteremploymentType = const EnumNameConverter<EmploymentType>(
    EmploymentType.values,
  );
  static TypeConverter<DateTime, String> $converteremploymentStartDate =
      const DayConverter();
  static TypeConverter<DateTime, String> $converterbirthDate =
      const DayConverter();
  static TypeConverter<DateTime?, String?> $converterbirthDaten =
      NullAwareTypeConverter.wrap($converterbirthDate);
  static TypeConverter<List<int>, String> $converterworkDays =
      const IntListConverter();
  static JsonTypeConverter2<HalfDayDeduction, String, String>
  $converterhalfDayDeduction = const EnumNameConverter<HalfDayDeduction>(
    HalfDayDeduction.values,
  );
  static TypeConverter<List<DateTime>, String>
  $converteradministrativeLeaveDays = const DayListConverter();
  static TypeConverter<List<DateRange>, String> $converterabsencePeriods =
      const DateRangeListConverter();
  @override
  bool get isStrict => true;
}

class ProfileRow extends DataClass implements Insertable<ProfileRow> {
  /// Stable id chosen by the app.
  final String id;

  /// Display name.
  final String name;

  /// Law that defines the leave rights, stored by enum name.
  final EmploymentType employmentType;

  /// Hire date (4857) or start of duty (657).
  final DateTime employmentStartDate;

  /// Birth date for the age rules of 4857, null for civil servants.
  final DateTime? birthDate;

  /// Working weekdays, `WorkSchedule.workDays`.
  final List<int> workDays;

  /// Weekly rest day, `WorkSchedule.weeklyRestDay`.
  final int weeklyRestDay;

  /// `WorkSchedule.saturdayCountsAsLeave`.
  final bool saturdayCountsAsLeave;

  /// `WorkSchedule.halfDayDeduction`, stored by enum name.
  final HalfDayDeduction halfDayDeduction;

  /// `WorkSchedule.dailyWorkingHours`.
  final double dailyWorkingHours;

  /// Years of `Profile.priorService`.
  final int priorServiceYears;

  /// Months of `Profile.priorService`.
  final int priorServiceMonths;

  /// Days of `Profile.priorService`.
  final int priorServiceDays;

  /// Whether the person works underground (4857 art. 53/4).
  final bool isUnderground;

  /// Extra days granted by contract or union agreement.
  final int contractExtraDays;

  /// Annual leave days used before tracking started.
  final double leaveUsedBeforeTracking;

  /// Whether the person is a teacher (657 art. 103/2).
  final bool isTeacher;

  /// Administrative leave days of a civil servant.
  final List<DateTime> administrativeLeaveDays;

  /// Absences that shift accrual dates (4857 art. 54/2).
  final List<DateRange> absencePeriods;
  const ProfileRow({
    required this.id,
    required this.name,
    required this.employmentType,
    required this.employmentStartDate,
    this.birthDate,
    required this.workDays,
    required this.weeklyRestDay,
    required this.saturdayCountsAsLeave,
    required this.halfDayDeduction,
    required this.dailyWorkingHours,
    required this.priorServiceYears,
    required this.priorServiceMonths,
    required this.priorServiceDays,
    required this.isUnderground,
    required this.contractExtraDays,
    required this.leaveUsedBeforeTracking,
    required this.isTeacher,
    required this.administrativeLeaveDays,
    required this.absencePeriods,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    {
      map['employment_type'] = Variable<String>(
        $ProfilesTable.$converteremploymentType.toSql(employmentType),
      );
    }
    {
      map['employment_start_date'] = Variable<String>(
        $ProfilesTable.$converteremploymentStartDate.toSql(employmentStartDate),
      );
    }
    if (!nullToAbsent || birthDate != null) {
      map['birth_date'] = Variable<String>(
        $ProfilesTable.$converterbirthDaten.toSql(birthDate),
      );
    }
    {
      map['work_days'] = Variable<String>(
        $ProfilesTable.$converterworkDays.toSql(workDays),
      );
    }
    map['weekly_rest_day'] = Variable<int>(weeklyRestDay);
    map['saturday_counts_as_leave'] = Variable<bool>(saturdayCountsAsLeave);
    {
      map['half_day_deduction'] = Variable<String>(
        $ProfilesTable.$converterhalfDayDeduction.toSql(halfDayDeduction),
      );
    }
    map['daily_working_hours'] = Variable<double>(dailyWorkingHours);
    map['prior_service_years'] = Variable<int>(priorServiceYears);
    map['prior_service_months'] = Variable<int>(priorServiceMonths);
    map['prior_service_days'] = Variable<int>(priorServiceDays);
    map['is_underground'] = Variable<bool>(isUnderground);
    map['contract_extra_days'] = Variable<int>(contractExtraDays);
    map['leave_used_before_tracking'] = Variable<double>(
      leaveUsedBeforeTracking,
    );
    map['is_teacher'] = Variable<bool>(isTeacher);
    {
      map['administrative_leave_days'] = Variable<String>(
        $ProfilesTable.$converteradministrativeLeaveDays.toSql(
          administrativeLeaveDays,
        ),
      );
    }
    {
      map['absence_periods'] = Variable<String>(
        $ProfilesTable.$converterabsencePeriods.toSql(absencePeriods),
      );
    }
    return map;
  }

  ProfilesCompanion toCompanion(bool nullToAbsent) {
    return ProfilesCompanion(
      id: Value(id),
      name: Value(name),
      employmentType: Value(employmentType),
      employmentStartDate: Value(employmentStartDate),
      birthDate: birthDate == null && nullToAbsent
          ? const Value.absent()
          : Value(birthDate),
      workDays: Value(workDays),
      weeklyRestDay: Value(weeklyRestDay),
      saturdayCountsAsLeave: Value(saturdayCountsAsLeave),
      halfDayDeduction: Value(halfDayDeduction),
      dailyWorkingHours: Value(dailyWorkingHours),
      priorServiceYears: Value(priorServiceYears),
      priorServiceMonths: Value(priorServiceMonths),
      priorServiceDays: Value(priorServiceDays),
      isUnderground: Value(isUnderground),
      contractExtraDays: Value(contractExtraDays),
      leaveUsedBeforeTracking: Value(leaveUsedBeforeTracking),
      isTeacher: Value(isTeacher),
      administrativeLeaveDays: Value(administrativeLeaveDays),
      absencePeriods: Value(absencePeriods),
    );
  }

  factory ProfileRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProfileRow(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      employmentType: $ProfilesTable.$converteremploymentType.fromJson(
        serializer.fromJson<String>(json['employmentType']),
      ),
      employmentStartDate: serializer.fromJson<DateTime>(
        json['employmentStartDate'],
      ),
      birthDate: serializer.fromJson<DateTime?>(json['birthDate']),
      workDays: serializer.fromJson<List<int>>(json['workDays']),
      weeklyRestDay: serializer.fromJson<int>(json['weeklyRestDay']),
      saturdayCountsAsLeave: serializer.fromJson<bool>(
        json['saturdayCountsAsLeave'],
      ),
      halfDayDeduction: $ProfilesTable.$converterhalfDayDeduction.fromJson(
        serializer.fromJson<String>(json['halfDayDeduction']),
      ),
      dailyWorkingHours: serializer.fromJson<double>(json['dailyWorkingHours']),
      priorServiceYears: serializer.fromJson<int>(json['priorServiceYears']),
      priorServiceMonths: serializer.fromJson<int>(json['priorServiceMonths']),
      priorServiceDays: serializer.fromJson<int>(json['priorServiceDays']),
      isUnderground: serializer.fromJson<bool>(json['isUnderground']),
      contractExtraDays: serializer.fromJson<int>(json['contractExtraDays']),
      leaveUsedBeforeTracking: serializer.fromJson<double>(
        json['leaveUsedBeforeTracking'],
      ),
      isTeacher: serializer.fromJson<bool>(json['isTeacher']),
      administrativeLeaveDays: serializer.fromJson<List<DateTime>>(
        json['administrativeLeaveDays'],
      ),
      absencePeriods: serializer.fromJson<List<DateRange>>(
        json['absencePeriods'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'employmentType': serializer.toJson<String>(
        $ProfilesTable.$converteremploymentType.toJson(employmentType),
      ),
      'employmentStartDate': serializer.toJson<DateTime>(employmentStartDate),
      'birthDate': serializer.toJson<DateTime?>(birthDate),
      'workDays': serializer.toJson<List<int>>(workDays),
      'weeklyRestDay': serializer.toJson<int>(weeklyRestDay),
      'saturdayCountsAsLeave': serializer.toJson<bool>(saturdayCountsAsLeave),
      'halfDayDeduction': serializer.toJson<String>(
        $ProfilesTable.$converterhalfDayDeduction.toJson(halfDayDeduction),
      ),
      'dailyWorkingHours': serializer.toJson<double>(dailyWorkingHours),
      'priorServiceYears': serializer.toJson<int>(priorServiceYears),
      'priorServiceMonths': serializer.toJson<int>(priorServiceMonths),
      'priorServiceDays': serializer.toJson<int>(priorServiceDays),
      'isUnderground': serializer.toJson<bool>(isUnderground),
      'contractExtraDays': serializer.toJson<int>(contractExtraDays),
      'leaveUsedBeforeTracking': serializer.toJson<double>(
        leaveUsedBeforeTracking,
      ),
      'isTeacher': serializer.toJson<bool>(isTeacher),
      'administrativeLeaveDays': serializer.toJson<List<DateTime>>(
        administrativeLeaveDays,
      ),
      'absencePeriods': serializer.toJson<List<DateRange>>(absencePeriods),
    };
  }

  ProfileRow copyWith({
    String? id,
    String? name,
    EmploymentType? employmentType,
    DateTime? employmentStartDate,
    Value<DateTime?> birthDate = const Value.absent(),
    List<int>? workDays,
    int? weeklyRestDay,
    bool? saturdayCountsAsLeave,
    HalfDayDeduction? halfDayDeduction,
    double? dailyWorkingHours,
    int? priorServiceYears,
    int? priorServiceMonths,
    int? priorServiceDays,
    bool? isUnderground,
    int? contractExtraDays,
    double? leaveUsedBeforeTracking,
    bool? isTeacher,
    List<DateTime>? administrativeLeaveDays,
    List<DateRange>? absencePeriods,
  }) => ProfileRow(
    id: id ?? this.id,
    name: name ?? this.name,
    employmentType: employmentType ?? this.employmentType,
    employmentStartDate: employmentStartDate ?? this.employmentStartDate,
    birthDate: birthDate.present ? birthDate.value : this.birthDate,
    workDays: workDays ?? this.workDays,
    weeklyRestDay: weeklyRestDay ?? this.weeklyRestDay,
    saturdayCountsAsLeave: saturdayCountsAsLeave ?? this.saturdayCountsAsLeave,
    halfDayDeduction: halfDayDeduction ?? this.halfDayDeduction,
    dailyWorkingHours: dailyWorkingHours ?? this.dailyWorkingHours,
    priorServiceYears: priorServiceYears ?? this.priorServiceYears,
    priorServiceMonths: priorServiceMonths ?? this.priorServiceMonths,
    priorServiceDays: priorServiceDays ?? this.priorServiceDays,
    isUnderground: isUnderground ?? this.isUnderground,
    contractExtraDays: contractExtraDays ?? this.contractExtraDays,
    leaveUsedBeforeTracking:
        leaveUsedBeforeTracking ?? this.leaveUsedBeforeTracking,
    isTeacher: isTeacher ?? this.isTeacher,
    administrativeLeaveDays:
        administrativeLeaveDays ?? this.administrativeLeaveDays,
    absencePeriods: absencePeriods ?? this.absencePeriods,
  );
  ProfileRow copyWithCompanion(ProfilesCompanion data) {
    return ProfileRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      employmentType: data.employmentType.present
          ? data.employmentType.value
          : this.employmentType,
      employmentStartDate: data.employmentStartDate.present
          ? data.employmentStartDate.value
          : this.employmentStartDate,
      birthDate: data.birthDate.present ? data.birthDate.value : this.birthDate,
      workDays: data.workDays.present ? data.workDays.value : this.workDays,
      weeklyRestDay: data.weeklyRestDay.present
          ? data.weeklyRestDay.value
          : this.weeklyRestDay,
      saturdayCountsAsLeave: data.saturdayCountsAsLeave.present
          ? data.saturdayCountsAsLeave.value
          : this.saturdayCountsAsLeave,
      halfDayDeduction: data.halfDayDeduction.present
          ? data.halfDayDeduction.value
          : this.halfDayDeduction,
      dailyWorkingHours: data.dailyWorkingHours.present
          ? data.dailyWorkingHours.value
          : this.dailyWorkingHours,
      priorServiceYears: data.priorServiceYears.present
          ? data.priorServiceYears.value
          : this.priorServiceYears,
      priorServiceMonths: data.priorServiceMonths.present
          ? data.priorServiceMonths.value
          : this.priorServiceMonths,
      priorServiceDays: data.priorServiceDays.present
          ? data.priorServiceDays.value
          : this.priorServiceDays,
      isUnderground: data.isUnderground.present
          ? data.isUnderground.value
          : this.isUnderground,
      contractExtraDays: data.contractExtraDays.present
          ? data.contractExtraDays.value
          : this.contractExtraDays,
      leaveUsedBeforeTracking: data.leaveUsedBeforeTracking.present
          ? data.leaveUsedBeforeTracking.value
          : this.leaveUsedBeforeTracking,
      isTeacher: data.isTeacher.present ? data.isTeacher.value : this.isTeacher,
      administrativeLeaveDays: data.administrativeLeaveDays.present
          ? data.administrativeLeaveDays.value
          : this.administrativeLeaveDays,
      absencePeriods: data.absencePeriods.present
          ? data.absencePeriods.value
          : this.absencePeriods,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProfileRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('employmentType: $employmentType, ')
          ..write('employmentStartDate: $employmentStartDate, ')
          ..write('birthDate: $birthDate, ')
          ..write('workDays: $workDays, ')
          ..write('weeklyRestDay: $weeklyRestDay, ')
          ..write('saturdayCountsAsLeave: $saturdayCountsAsLeave, ')
          ..write('halfDayDeduction: $halfDayDeduction, ')
          ..write('dailyWorkingHours: $dailyWorkingHours, ')
          ..write('priorServiceYears: $priorServiceYears, ')
          ..write('priorServiceMonths: $priorServiceMonths, ')
          ..write('priorServiceDays: $priorServiceDays, ')
          ..write('isUnderground: $isUnderground, ')
          ..write('contractExtraDays: $contractExtraDays, ')
          ..write('leaveUsedBeforeTracking: $leaveUsedBeforeTracking, ')
          ..write('isTeacher: $isTeacher, ')
          ..write('administrativeLeaveDays: $administrativeLeaveDays, ')
          ..write('absencePeriods: $absencePeriods')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    employmentType,
    employmentStartDate,
    birthDate,
    workDays,
    weeklyRestDay,
    saturdayCountsAsLeave,
    halfDayDeduction,
    dailyWorkingHours,
    priorServiceYears,
    priorServiceMonths,
    priorServiceDays,
    isUnderground,
    contractExtraDays,
    leaveUsedBeforeTracking,
    isTeacher,
    administrativeLeaveDays,
    absencePeriods,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProfileRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.employmentType == this.employmentType &&
          other.employmentStartDate == this.employmentStartDate &&
          other.birthDate == this.birthDate &&
          other.workDays == this.workDays &&
          other.weeklyRestDay == this.weeklyRestDay &&
          other.saturdayCountsAsLeave == this.saturdayCountsAsLeave &&
          other.halfDayDeduction == this.halfDayDeduction &&
          other.dailyWorkingHours == this.dailyWorkingHours &&
          other.priorServiceYears == this.priorServiceYears &&
          other.priorServiceMonths == this.priorServiceMonths &&
          other.priorServiceDays == this.priorServiceDays &&
          other.isUnderground == this.isUnderground &&
          other.contractExtraDays == this.contractExtraDays &&
          other.leaveUsedBeforeTracking == this.leaveUsedBeforeTracking &&
          other.isTeacher == this.isTeacher &&
          other.administrativeLeaveDays == this.administrativeLeaveDays &&
          other.absencePeriods == this.absencePeriods);
}

class ProfilesCompanion extends UpdateCompanion<ProfileRow> {
  final Value<String> id;
  final Value<String> name;
  final Value<EmploymentType> employmentType;
  final Value<DateTime> employmentStartDate;
  final Value<DateTime?> birthDate;
  final Value<List<int>> workDays;
  final Value<int> weeklyRestDay;
  final Value<bool> saturdayCountsAsLeave;
  final Value<HalfDayDeduction> halfDayDeduction;
  final Value<double> dailyWorkingHours;
  final Value<int> priorServiceYears;
  final Value<int> priorServiceMonths;
  final Value<int> priorServiceDays;
  final Value<bool> isUnderground;
  final Value<int> contractExtraDays;
  final Value<double> leaveUsedBeforeTracking;
  final Value<bool> isTeacher;
  final Value<List<DateTime>> administrativeLeaveDays;
  final Value<List<DateRange>> absencePeriods;
  final Value<int> rowid;
  const ProfilesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.employmentType = const Value.absent(),
    this.employmentStartDate = const Value.absent(),
    this.birthDate = const Value.absent(),
    this.workDays = const Value.absent(),
    this.weeklyRestDay = const Value.absent(),
    this.saturdayCountsAsLeave = const Value.absent(),
    this.halfDayDeduction = const Value.absent(),
    this.dailyWorkingHours = const Value.absent(),
    this.priorServiceYears = const Value.absent(),
    this.priorServiceMonths = const Value.absent(),
    this.priorServiceDays = const Value.absent(),
    this.isUnderground = const Value.absent(),
    this.contractExtraDays = const Value.absent(),
    this.leaveUsedBeforeTracking = const Value.absent(),
    this.isTeacher = const Value.absent(),
    this.administrativeLeaveDays = const Value.absent(),
    this.absencePeriods = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProfilesCompanion.insert({
    required String id,
    required String name,
    required EmploymentType employmentType,
    required DateTime employmentStartDate,
    this.birthDate = const Value.absent(),
    required List<int> workDays,
    required int weeklyRestDay,
    required bool saturdayCountsAsLeave,
    required HalfDayDeduction halfDayDeduction,
    required double dailyWorkingHours,
    required int priorServiceYears,
    required int priorServiceMonths,
    required int priorServiceDays,
    required bool isUnderground,
    required int contractExtraDays,
    required double leaveUsedBeforeTracking,
    required bool isTeacher,
    required List<DateTime> administrativeLeaveDays,
    required List<DateRange> absencePeriods,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       employmentType = Value(employmentType),
       employmentStartDate = Value(employmentStartDate),
       workDays = Value(workDays),
       weeklyRestDay = Value(weeklyRestDay),
       saturdayCountsAsLeave = Value(saturdayCountsAsLeave),
       halfDayDeduction = Value(halfDayDeduction),
       dailyWorkingHours = Value(dailyWorkingHours),
       priorServiceYears = Value(priorServiceYears),
       priorServiceMonths = Value(priorServiceMonths),
       priorServiceDays = Value(priorServiceDays),
       isUnderground = Value(isUnderground),
       contractExtraDays = Value(contractExtraDays),
       leaveUsedBeforeTracking = Value(leaveUsedBeforeTracking),
       isTeacher = Value(isTeacher),
       administrativeLeaveDays = Value(administrativeLeaveDays),
       absencePeriods = Value(absencePeriods);
  static Insertable<ProfileRow> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? employmentType,
    Expression<String>? employmentStartDate,
    Expression<String>? birthDate,
    Expression<String>? workDays,
    Expression<int>? weeklyRestDay,
    Expression<bool>? saturdayCountsAsLeave,
    Expression<String>? halfDayDeduction,
    Expression<double>? dailyWorkingHours,
    Expression<int>? priorServiceYears,
    Expression<int>? priorServiceMonths,
    Expression<int>? priorServiceDays,
    Expression<bool>? isUnderground,
    Expression<int>? contractExtraDays,
    Expression<double>? leaveUsedBeforeTracking,
    Expression<bool>? isTeacher,
    Expression<String>? administrativeLeaveDays,
    Expression<String>? absencePeriods,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (employmentType != null) 'employment_type': employmentType,
      if (employmentStartDate != null)
        'employment_start_date': employmentStartDate,
      if (birthDate != null) 'birth_date': birthDate,
      if (workDays != null) 'work_days': workDays,
      if (weeklyRestDay != null) 'weekly_rest_day': weeklyRestDay,
      if (saturdayCountsAsLeave != null)
        'saturday_counts_as_leave': saturdayCountsAsLeave,
      if (halfDayDeduction != null) 'half_day_deduction': halfDayDeduction,
      if (dailyWorkingHours != null) 'daily_working_hours': dailyWorkingHours,
      if (priorServiceYears != null) 'prior_service_years': priorServiceYears,
      if (priorServiceMonths != null)
        'prior_service_months': priorServiceMonths,
      if (priorServiceDays != null) 'prior_service_days': priorServiceDays,
      if (isUnderground != null) 'is_underground': isUnderground,
      if (contractExtraDays != null) 'contract_extra_days': contractExtraDays,
      if (leaveUsedBeforeTracking != null)
        'leave_used_before_tracking': leaveUsedBeforeTracking,
      if (isTeacher != null) 'is_teacher': isTeacher,
      if (administrativeLeaveDays != null)
        'administrative_leave_days': administrativeLeaveDays,
      if (absencePeriods != null) 'absence_periods': absencePeriods,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProfilesCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<EmploymentType>? employmentType,
    Value<DateTime>? employmentStartDate,
    Value<DateTime?>? birthDate,
    Value<List<int>>? workDays,
    Value<int>? weeklyRestDay,
    Value<bool>? saturdayCountsAsLeave,
    Value<HalfDayDeduction>? halfDayDeduction,
    Value<double>? dailyWorkingHours,
    Value<int>? priorServiceYears,
    Value<int>? priorServiceMonths,
    Value<int>? priorServiceDays,
    Value<bool>? isUnderground,
    Value<int>? contractExtraDays,
    Value<double>? leaveUsedBeforeTracking,
    Value<bool>? isTeacher,
    Value<List<DateTime>>? administrativeLeaveDays,
    Value<List<DateRange>>? absencePeriods,
    Value<int>? rowid,
  }) {
    return ProfilesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      employmentType: employmentType ?? this.employmentType,
      employmentStartDate: employmentStartDate ?? this.employmentStartDate,
      birthDate: birthDate ?? this.birthDate,
      workDays: workDays ?? this.workDays,
      weeklyRestDay: weeklyRestDay ?? this.weeklyRestDay,
      saturdayCountsAsLeave:
          saturdayCountsAsLeave ?? this.saturdayCountsAsLeave,
      halfDayDeduction: halfDayDeduction ?? this.halfDayDeduction,
      dailyWorkingHours: dailyWorkingHours ?? this.dailyWorkingHours,
      priorServiceYears: priorServiceYears ?? this.priorServiceYears,
      priorServiceMonths: priorServiceMonths ?? this.priorServiceMonths,
      priorServiceDays: priorServiceDays ?? this.priorServiceDays,
      isUnderground: isUnderground ?? this.isUnderground,
      contractExtraDays: contractExtraDays ?? this.contractExtraDays,
      leaveUsedBeforeTracking:
          leaveUsedBeforeTracking ?? this.leaveUsedBeforeTracking,
      isTeacher: isTeacher ?? this.isTeacher,
      administrativeLeaveDays:
          administrativeLeaveDays ?? this.administrativeLeaveDays,
      absencePeriods: absencePeriods ?? this.absencePeriods,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (employmentType.present) {
      map['employment_type'] = Variable<String>(
        $ProfilesTable.$converteremploymentType.toSql(employmentType.value),
      );
    }
    if (employmentStartDate.present) {
      map['employment_start_date'] = Variable<String>(
        $ProfilesTable.$converteremploymentStartDate.toSql(
          employmentStartDate.value,
        ),
      );
    }
    if (birthDate.present) {
      map['birth_date'] = Variable<String>(
        $ProfilesTable.$converterbirthDaten.toSql(birthDate.value),
      );
    }
    if (workDays.present) {
      map['work_days'] = Variable<String>(
        $ProfilesTable.$converterworkDays.toSql(workDays.value),
      );
    }
    if (weeklyRestDay.present) {
      map['weekly_rest_day'] = Variable<int>(weeklyRestDay.value);
    }
    if (saturdayCountsAsLeave.present) {
      map['saturday_counts_as_leave'] = Variable<bool>(
        saturdayCountsAsLeave.value,
      );
    }
    if (halfDayDeduction.present) {
      map['half_day_deduction'] = Variable<String>(
        $ProfilesTable.$converterhalfDayDeduction.toSql(halfDayDeduction.value),
      );
    }
    if (dailyWorkingHours.present) {
      map['daily_working_hours'] = Variable<double>(dailyWorkingHours.value);
    }
    if (priorServiceYears.present) {
      map['prior_service_years'] = Variable<int>(priorServiceYears.value);
    }
    if (priorServiceMonths.present) {
      map['prior_service_months'] = Variable<int>(priorServiceMonths.value);
    }
    if (priorServiceDays.present) {
      map['prior_service_days'] = Variable<int>(priorServiceDays.value);
    }
    if (isUnderground.present) {
      map['is_underground'] = Variable<bool>(isUnderground.value);
    }
    if (contractExtraDays.present) {
      map['contract_extra_days'] = Variable<int>(contractExtraDays.value);
    }
    if (leaveUsedBeforeTracking.present) {
      map['leave_used_before_tracking'] = Variable<double>(
        leaveUsedBeforeTracking.value,
      );
    }
    if (isTeacher.present) {
      map['is_teacher'] = Variable<bool>(isTeacher.value);
    }
    if (administrativeLeaveDays.present) {
      map['administrative_leave_days'] = Variable<String>(
        $ProfilesTable.$converteradministrativeLeaveDays.toSql(
          administrativeLeaveDays.value,
        ),
      );
    }
    if (absencePeriods.present) {
      map['absence_periods'] = Variable<String>(
        $ProfilesTable.$converterabsencePeriods.toSql(absencePeriods.value),
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProfilesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('employmentType: $employmentType, ')
          ..write('employmentStartDate: $employmentStartDate, ')
          ..write('birthDate: $birthDate, ')
          ..write('workDays: $workDays, ')
          ..write('weeklyRestDay: $weeklyRestDay, ')
          ..write('saturdayCountsAsLeave: $saturdayCountsAsLeave, ')
          ..write('halfDayDeduction: $halfDayDeduction, ')
          ..write('dailyWorkingHours: $dailyWorkingHours, ')
          ..write('priorServiceYears: $priorServiceYears, ')
          ..write('priorServiceMonths: $priorServiceMonths, ')
          ..write('priorServiceDays: $priorServiceDays, ')
          ..write('isUnderground: $isUnderground, ')
          ..write('contractExtraDays: $contractExtraDays, ')
          ..write('leaveUsedBeforeTracking: $leaveUsedBeforeTracking, ')
          ..write('isTeacher: $isTeacher, ')
          ..write('administrativeLeaveDays: $administrativeLeaveDays, ')
          ..write('absencePeriods: $absencePeriods, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LeaveRecordsTable extends LeaveRecords
    with TableInfo<$LeaveRecordsTable, LeaveRecordRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LeaveRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _profileIdMeta = const VerificationMeta(
    'profileId',
  );
  @override
  late final GeneratedColumn<String> profileId = GeneratedColumn<String>(
    'profile_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES profiles (id) ON DELETE CASCADE',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<LeaveType, String> type =
      GeneratedColumn<String>(
        'type',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<LeaveType>($LeaveRecordsTable.$convertertype);
  @override
  late final GeneratedColumnWithTypeConverter<DateTime, String> startDate =
      GeneratedColumn<String>(
        'start_date',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<DateTime>($LeaveRecordsTable.$converterstartDate);
  @override
  late final GeneratedColumnWithTypeConverter<DateTime, String> endDate =
      GeneratedColumn<String>(
        'end_date',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<DateTime>($LeaveRecordsTable.$converterendDate);
  @override
  late final GeneratedColumnWithTypeConverter<LeaveUnit, String> unit =
      GeneratedColumn<String>(
        'unit',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<LeaveUnit>($LeaveRecordsTable.$converterunit);
  static const VerificationMeta _hoursMeta = const VerificationMeta('hours');
  @override
  late final GeneratedColumn<double> hours = GeneratedColumn<double>(
    'hours',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _customTypeNameMeta = const VerificationMeta(
    'customTypeName',
  );
  @override
  late final GeneratedColumn<String> customTypeName = GeneratedColumn<String>(
    'custom_type_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<DateTime?, String> eventDate =
      GeneratedColumn<String>(
        'event_date',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<DateTime?>($LeaveRecordsTable.$convertereventDaten);
  static const VerificationMeta _deductsFromAnnualMeta = const VerificationMeta(
    'deductsFromAnnual',
  );
  @override
  late final GeneratedColumn<bool> deductsFromAnnual = GeneratedColumn<bool>(
    'deducts_from_annual',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("deducts_from_annual" IN (0, 1))',
    ),
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    profileId,
    type,
    startDate,
    endDate,
    unit,
    hours,
    customTypeName,
    eventDate,
    deductsFromAnnual,
    note,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'leave_records';
  @override
  VerificationContext validateIntegrity(
    Insertable<LeaveRecordRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('profile_id')) {
      context.handle(
        _profileIdMeta,
        profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta),
      );
    } else if (isInserting) {
      context.missing(_profileIdMeta);
    }
    if (data.containsKey('hours')) {
      context.handle(
        _hoursMeta,
        hours.isAcceptableOrUnknown(data['hours']!, _hoursMeta),
      );
    }
    if (data.containsKey('custom_type_name')) {
      context.handle(
        _customTypeNameMeta,
        customTypeName.isAcceptableOrUnknown(
          data['custom_type_name']!,
          _customTypeNameMeta,
        ),
      );
    }
    if (data.containsKey('deducts_from_annual')) {
      context.handle(
        _deductsFromAnnualMeta,
        deductsFromAnnual.isAcceptableOrUnknown(
          data['deducts_from_annual']!,
          _deductsFromAnnualMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_deductsFromAnnualMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LeaveRecordRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LeaveRecordRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      profileId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}profile_id'],
      )!,
      type: $LeaveRecordsTable.$convertertype.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}type'],
        )!,
      ),
      startDate: $LeaveRecordsTable.$converterstartDate.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}start_date'],
        )!,
      ),
      endDate: $LeaveRecordsTable.$converterendDate.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}end_date'],
        )!,
      ),
      unit: $LeaveRecordsTable.$converterunit.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}unit'],
        )!,
      ),
      hours: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}hours'],
      ),
      customTypeName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}custom_type_name'],
      ),
      eventDate: $LeaveRecordsTable.$convertereventDaten.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}event_date'],
        ),
      ),
      deductsFromAnnual: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}deducts_from_annual'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
    );
  }

  @override
  $LeaveRecordsTable createAlias(String alias) {
    return $LeaveRecordsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<LeaveType, String, String> $convertertype =
      const EnumNameConverter<LeaveType>(LeaveType.values);
  static TypeConverter<DateTime, String> $converterstartDate =
      const DayConverter();
  static TypeConverter<DateTime, String> $converterendDate =
      const DayConverter();
  static JsonTypeConverter2<LeaveUnit, String, String> $converterunit =
      const EnumNameConverter<LeaveUnit>(LeaveUnit.values);
  static TypeConverter<DateTime, String> $convertereventDate =
      const DayConverter();
  static TypeConverter<DateTime?, String?> $convertereventDaten =
      NullAwareTypeConverter.wrap($convertereventDate);
  @override
  bool get isStrict => true;
}

class LeaveRecordRow extends DataClass implements Insertable<LeaveRecordRow> {
  /// Stable id chosen by the app.
  final String id;

  /// Owner profile.
  final String profileId;

  /// Leave category, stored by enum name.
  final LeaveType type;

  /// First day of the range.
  final DateTime startDate;

  /// Last day of the range, inclusive.
  final DateTime endDate;

  /// How the record is measured, stored by enum name.
  final LeaveUnit unit;

  /// Hours for hourly leave.
  final double? hours;

  /// Name shown for `LeaveType.other`.
  final String? customTypeName;

  /// Event date, e.g. a child's birth date for paternity leave.
  final DateTime? eventDate;

  /// `LeaveRecord.deductsFromAnnual`.
  final bool deductsFromAnnual;

  /// Free text note.
  final String? note;
  const LeaveRecordRow({
    required this.id,
    required this.profileId,
    required this.type,
    required this.startDate,
    required this.endDate,
    required this.unit,
    this.hours,
    this.customTypeName,
    this.eventDate,
    required this.deductsFromAnnual,
    this.note,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['profile_id'] = Variable<String>(profileId);
    {
      map['type'] = Variable<String>(
        $LeaveRecordsTable.$convertertype.toSql(type),
      );
    }
    {
      map['start_date'] = Variable<String>(
        $LeaveRecordsTable.$converterstartDate.toSql(startDate),
      );
    }
    {
      map['end_date'] = Variable<String>(
        $LeaveRecordsTable.$converterendDate.toSql(endDate),
      );
    }
    {
      map['unit'] = Variable<String>(
        $LeaveRecordsTable.$converterunit.toSql(unit),
      );
    }
    if (!nullToAbsent || hours != null) {
      map['hours'] = Variable<double>(hours);
    }
    if (!nullToAbsent || customTypeName != null) {
      map['custom_type_name'] = Variable<String>(customTypeName);
    }
    if (!nullToAbsent || eventDate != null) {
      map['event_date'] = Variable<String>(
        $LeaveRecordsTable.$convertereventDaten.toSql(eventDate),
      );
    }
    map['deducts_from_annual'] = Variable<bool>(deductsFromAnnual);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    return map;
  }

  LeaveRecordsCompanion toCompanion(bool nullToAbsent) {
    return LeaveRecordsCompanion(
      id: Value(id),
      profileId: Value(profileId),
      type: Value(type),
      startDate: Value(startDate),
      endDate: Value(endDate),
      unit: Value(unit),
      hours: hours == null && nullToAbsent
          ? const Value.absent()
          : Value(hours),
      customTypeName: customTypeName == null && nullToAbsent
          ? const Value.absent()
          : Value(customTypeName),
      eventDate: eventDate == null && nullToAbsent
          ? const Value.absent()
          : Value(eventDate),
      deductsFromAnnual: Value(deductsFromAnnual),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
    );
  }

  factory LeaveRecordRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LeaveRecordRow(
      id: serializer.fromJson<String>(json['id']),
      profileId: serializer.fromJson<String>(json['profileId']),
      type: $LeaveRecordsTable.$convertertype.fromJson(
        serializer.fromJson<String>(json['type']),
      ),
      startDate: serializer.fromJson<DateTime>(json['startDate']),
      endDate: serializer.fromJson<DateTime>(json['endDate']),
      unit: $LeaveRecordsTable.$converterunit.fromJson(
        serializer.fromJson<String>(json['unit']),
      ),
      hours: serializer.fromJson<double?>(json['hours']),
      customTypeName: serializer.fromJson<String?>(json['customTypeName']),
      eventDate: serializer.fromJson<DateTime?>(json['eventDate']),
      deductsFromAnnual: serializer.fromJson<bool>(json['deductsFromAnnual']),
      note: serializer.fromJson<String?>(json['note']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'profileId': serializer.toJson<String>(profileId),
      'type': serializer.toJson<String>(
        $LeaveRecordsTable.$convertertype.toJson(type),
      ),
      'startDate': serializer.toJson<DateTime>(startDate),
      'endDate': serializer.toJson<DateTime>(endDate),
      'unit': serializer.toJson<String>(
        $LeaveRecordsTable.$converterunit.toJson(unit),
      ),
      'hours': serializer.toJson<double?>(hours),
      'customTypeName': serializer.toJson<String?>(customTypeName),
      'eventDate': serializer.toJson<DateTime?>(eventDate),
      'deductsFromAnnual': serializer.toJson<bool>(deductsFromAnnual),
      'note': serializer.toJson<String?>(note),
    };
  }

  LeaveRecordRow copyWith({
    String? id,
    String? profileId,
    LeaveType? type,
    DateTime? startDate,
    DateTime? endDate,
    LeaveUnit? unit,
    Value<double?> hours = const Value.absent(),
    Value<String?> customTypeName = const Value.absent(),
    Value<DateTime?> eventDate = const Value.absent(),
    bool? deductsFromAnnual,
    Value<String?> note = const Value.absent(),
  }) => LeaveRecordRow(
    id: id ?? this.id,
    profileId: profileId ?? this.profileId,
    type: type ?? this.type,
    startDate: startDate ?? this.startDate,
    endDate: endDate ?? this.endDate,
    unit: unit ?? this.unit,
    hours: hours.present ? hours.value : this.hours,
    customTypeName: customTypeName.present
        ? customTypeName.value
        : this.customTypeName,
    eventDate: eventDate.present ? eventDate.value : this.eventDate,
    deductsFromAnnual: deductsFromAnnual ?? this.deductsFromAnnual,
    note: note.present ? note.value : this.note,
  );
  LeaveRecordRow copyWithCompanion(LeaveRecordsCompanion data) {
    return LeaveRecordRow(
      id: data.id.present ? data.id.value : this.id,
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
      type: data.type.present ? data.type.value : this.type,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      endDate: data.endDate.present ? data.endDate.value : this.endDate,
      unit: data.unit.present ? data.unit.value : this.unit,
      hours: data.hours.present ? data.hours.value : this.hours,
      customTypeName: data.customTypeName.present
          ? data.customTypeName.value
          : this.customTypeName,
      eventDate: data.eventDate.present ? data.eventDate.value : this.eventDate,
      deductsFromAnnual: data.deductsFromAnnual.present
          ? data.deductsFromAnnual.value
          : this.deductsFromAnnual,
      note: data.note.present ? data.note.value : this.note,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LeaveRecordRow(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('type: $type, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('unit: $unit, ')
          ..write('hours: $hours, ')
          ..write('customTypeName: $customTypeName, ')
          ..write('eventDate: $eventDate, ')
          ..write('deductsFromAnnual: $deductsFromAnnual, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    profileId,
    type,
    startDate,
    endDate,
    unit,
    hours,
    customTypeName,
    eventDate,
    deductsFromAnnual,
    note,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LeaveRecordRow &&
          other.id == this.id &&
          other.profileId == this.profileId &&
          other.type == this.type &&
          other.startDate == this.startDate &&
          other.endDate == this.endDate &&
          other.unit == this.unit &&
          other.hours == this.hours &&
          other.customTypeName == this.customTypeName &&
          other.eventDate == this.eventDate &&
          other.deductsFromAnnual == this.deductsFromAnnual &&
          other.note == this.note);
}

class LeaveRecordsCompanion extends UpdateCompanion<LeaveRecordRow> {
  final Value<String> id;
  final Value<String> profileId;
  final Value<LeaveType> type;
  final Value<DateTime> startDate;
  final Value<DateTime> endDate;
  final Value<LeaveUnit> unit;
  final Value<double?> hours;
  final Value<String?> customTypeName;
  final Value<DateTime?> eventDate;
  final Value<bool> deductsFromAnnual;
  final Value<String?> note;
  final Value<int> rowid;
  const LeaveRecordsCompanion({
    this.id = const Value.absent(),
    this.profileId = const Value.absent(),
    this.type = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.unit = const Value.absent(),
    this.hours = const Value.absent(),
    this.customTypeName = const Value.absent(),
    this.eventDate = const Value.absent(),
    this.deductsFromAnnual = const Value.absent(),
    this.note = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LeaveRecordsCompanion.insert({
    required String id,
    required String profileId,
    required LeaveType type,
    required DateTime startDate,
    required DateTime endDate,
    required LeaveUnit unit,
    this.hours = const Value.absent(),
    this.customTypeName = const Value.absent(),
    this.eventDate = const Value.absent(),
    required bool deductsFromAnnual,
    this.note = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       profileId = Value(profileId),
       type = Value(type),
       startDate = Value(startDate),
       endDate = Value(endDate),
       unit = Value(unit),
       deductsFromAnnual = Value(deductsFromAnnual);
  static Insertable<LeaveRecordRow> custom({
    Expression<String>? id,
    Expression<String>? profileId,
    Expression<String>? type,
    Expression<String>? startDate,
    Expression<String>? endDate,
    Expression<String>? unit,
    Expression<double>? hours,
    Expression<String>? customTypeName,
    Expression<String>? eventDate,
    Expression<bool>? deductsFromAnnual,
    Expression<String>? note,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (profileId != null) 'profile_id': profileId,
      if (type != null) 'type': type,
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
      if (unit != null) 'unit': unit,
      if (hours != null) 'hours': hours,
      if (customTypeName != null) 'custom_type_name': customTypeName,
      if (eventDate != null) 'event_date': eventDate,
      if (deductsFromAnnual != null) 'deducts_from_annual': deductsFromAnnual,
      if (note != null) 'note': note,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LeaveRecordsCompanion copyWith({
    Value<String>? id,
    Value<String>? profileId,
    Value<LeaveType>? type,
    Value<DateTime>? startDate,
    Value<DateTime>? endDate,
    Value<LeaveUnit>? unit,
    Value<double?>? hours,
    Value<String?>? customTypeName,
    Value<DateTime?>? eventDate,
    Value<bool>? deductsFromAnnual,
    Value<String?>? note,
    Value<int>? rowid,
  }) {
    return LeaveRecordsCompanion(
      id: id ?? this.id,
      profileId: profileId ?? this.profileId,
      type: type ?? this.type,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      unit: unit ?? this.unit,
      hours: hours ?? this.hours,
      customTypeName: customTypeName ?? this.customTypeName,
      eventDate: eventDate ?? this.eventDate,
      deductsFromAnnual: deductsFromAnnual ?? this.deductsFromAnnual,
      note: note ?? this.note,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (profileId.present) {
      map['profile_id'] = Variable<String>(profileId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(
        $LeaveRecordsTable.$convertertype.toSql(type.value),
      );
    }
    if (startDate.present) {
      map['start_date'] = Variable<String>(
        $LeaveRecordsTable.$converterstartDate.toSql(startDate.value),
      );
    }
    if (endDate.present) {
      map['end_date'] = Variable<String>(
        $LeaveRecordsTable.$converterendDate.toSql(endDate.value),
      );
    }
    if (unit.present) {
      map['unit'] = Variable<String>(
        $LeaveRecordsTable.$converterunit.toSql(unit.value),
      );
    }
    if (hours.present) {
      map['hours'] = Variable<double>(hours.value);
    }
    if (customTypeName.present) {
      map['custom_type_name'] = Variable<String>(customTypeName.value);
    }
    if (eventDate.present) {
      map['event_date'] = Variable<String>(
        $LeaveRecordsTable.$convertereventDaten.toSql(eventDate.value),
      );
    }
    if (deductsFromAnnual.present) {
      map['deducts_from_annual'] = Variable<bool>(deductsFromAnnual.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LeaveRecordsCompanion(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('type: $type, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('unit: $unit, ')
          ..write('hours: $hours, ')
          ..write('customTypeName: $customTypeName, ')
          ..write('eventDate: $eventDate, ')
          ..write('deductsFromAnnual: $deductsFromAnnual, ')
          ..write('note: $note, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $OvertimeRecordsTable extends OvertimeRecords
    with TableInfo<$OvertimeRecordsTable, OvertimeRecordRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OvertimeRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _profileIdMeta = const VerificationMeta(
    'profileId',
  );
  @override
  late final GeneratedColumn<String> profileId = GeneratedColumn<String>(
    'profile_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES profiles (id) ON DELETE CASCADE',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<DateTime, String> date =
      GeneratedColumn<String>(
        'date',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<DateTime>($OvertimeRecordsTable.$converterdate);
  static const VerificationMeta _hoursMeta = const VerificationMeta('hours');
  @override
  late final GeneratedColumn<double> hours = GeneratedColumn<double>(
    'hours',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [id, profileId, date, hours, note];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'overtime_records';
  @override
  VerificationContext validateIntegrity(
    Insertable<OvertimeRecordRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('profile_id')) {
      context.handle(
        _profileIdMeta,
        profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta),
      );
    } else if (isInserting) {
      context.missing(_profileIdMeta);
    }
    if (data.containsKey('hours')) {
      context.handle(
        _hoursMeta,
        hours.isAcceptableOrUnknown(data['hours']!, _hoursMeta),
      );
    } else if (isInserting) {
      context.missing(_hoursMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  OvertimeRecordRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OvertimeRecordRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      profileId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}profile_id'],
      )!,
      date: $OvertimeRecordsTable.$converterdate.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}date'],
        )!,
      ),
      hours: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}hours'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
    );
  }

  @override
  $OvertimeRecordsTable createAlias(String alias) {
    return $OvertimeRecordsTable(attachedDatabase, alias);
  }

  static TypeConverter<DateTime, String> $converterdate = const DayConverter();
  @override
  bool get isStrict => true;
}

class OvertimeRecordRow extends DataClass
    implements Insertable<OvertimeRecordRow> {
  /// Stable id chosen by the app.
  final String id;

  /// Owner profile.
  final String profileId;

  /// Day the overtime was worked.
  final DateTime date;

  /// Hours worked, always positive.
  final double hours;

  /// Free text note.
  final String? note;
  const OvertimeRecordRow({
    required this.id,
    required this.profileId,
    required this.date,
    required this.hours,
    this.note,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['profile_id'] = Variable<String>(profileId);
    {
      map['date'] = Variable<String>(
        $OvertimeRecordsTable.$converterdate.toSql(date),
      );
    }
    map['hours'] = Variable<double>(hours);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    return map;
  }

  OvertimeRecordsCompanion toCompanion(bool nullToAbsent) {
    return OvertimeRecordsCompanion(
      id: Value(id),
      profileId: Value(profileId),
      date: Value(date),
      hours: Value(hours),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
    );
  }

  factory OvertimeRecordRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OvertimeRecordRow(
      id: serializer.fromJson<String>(json['id']),
      profileId: serializer.fromJson<String>(json['profileId']),
      date: serializer.fromJson<DateTime>(json['date']),
      hours: serializer.fromJson<double>(json['hours']),
      note: serializer.fromJson<String?>(json['note']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'profileId': serializer.toJson<String>(profileId),
      'date': serializer.toJson<DateTime>(date),
      'hours': serializer.toJson<double>(hours),
      'note': serializer.toJson<String?>(note),
    };
  }

  OvertimeRecordRow copyWith({
    String? id,
    String? profileId,
    DateTime? date,
    double? hours,
    Value<String?> note = const Value.absent(),
  }) => OvertimeRecordRow(
    id: id ?? this.id,
    profileId: profileId ?? this.profileId,
    date: date ?? this.date,
    hours: hours ?? this.hours,
    note: note.present ? note.value : this.note,
  );
  OvertimeRecordRow copyWithCompanion(OvertimeRecordsCompanion data) {
    return OvertimeRecordRow(
      id: data.id.present ? data.id.value : this.id,
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
      date: data.date.present ? data.date.value : this.date,
      hours: data.hours.present ? data.hours.value : this.hours,
      note: data.note.present ? data.note.value : this.note,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OvertimeRecordRow(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('date: $date, ')
          ..write('hours: $hours, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, profileId, date, hours, note);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OvertimeRecordRow &&
          other.id == this.id &&
          other.profileId == this.profileId &&
          other.date == this.date &&
          other.hours == this.hours &&
          other.note == this.note);
}

class OvertimeRecordsCompanion extends UpdateCompanion<OvertimeRecordRow> {
  final Value<String> id;
  final Value<String> profileId;
  final Value<DateTime> date;
  final Value<double> hours;
  final Value<String?> note;
  final Value<int> rowid;
  const OvertimeRecordsCompanion({
    this.id = const Value.absent(),
    this.profileId = const Value.absent(),
    this.date = const Value.absent(),
    this.hours = const Value.absent(),
    this.note = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  OvertimeRecordsCompanion.insert({
    required String id,
    required String profileId,
    required DateTime date,
    required double hours,
    this.note = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       profileId = Value(profileId),
       date = Value(date),
       hours = Value(hours);
  static Insertable<OvertimeRecordRow> custom({
    Expression<String>? id,
    Expression<String>? profileId,
    Expression<String>? date,
    Expression<double>? hours,
    Expression<String>? note,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (profileId != null) 'profile_id': profileId,
      if (date != null) 'date': date,
      if (hours != null) 'hours': hours,
      if (note != null) 'note': note,
      if (rowid != null) 'rowid': rowid,
    });
  }

  OvertimeRecordsCompanion copyWith({
    Value<String>? id,
    Value<String>? profileId,
    Value<DateTime>? date,
    Value<double>? hours,
    Value<String?>? note,
    Value<int>? rowid,
  }) {
    return OvertimeRecordsCompanion(
      id: id ?? this.id,
      profileId: profileId ?? this.profileId,
      date: date ?? this.date,
      hours: hours ?? this.hours,
      note: note ?? this.note,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (profileId.present) {
      map['profile_id'] = Variable<String>(profileId.value);
    }
    if (date.present) {
      map['date'] = Variable<String>(
        $OvertimeRecordsTable.$converterdate.toSql(date.value),
      );
    }
    if (hours.present) {
      map['hours'] = Variable<double>(hours.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OvertimeRecordsCompanion(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('date: $date, ')
          ..write('hours: $hours, ')
          ..write('note: $note, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SettingsTable extends Settings
    with TableInfo<$SettingsTable, SettingsRow> {
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
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  @override
  late final GeneratedColumnWithTypeConverter<AppThemeMode, String> themeMode =
      GeneratedColumn<String>(
        'theme_mode',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<AppThemeMode>($SettingsTable.$converterthemeMode);
  static const VerificationMeta _activeProfileIdMeta = const VerificationMeta(
    'activeProfileId',
  );
  @override
  late final GeneratedColumn<String> activeProfileId = GeneratedColumn<String>(
    'active_profile_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES profiles (id) ON DELETE SET NULL',
    ),
  );
  static const VerificationMeta _holidayReminderMeta = const VerificationMeta(
    'holidayReminder',
  );
  @override
  late final GeneratedColumn<bool> holidayReminder = GeneratedColumn<bool>(
    'holiday_reminder',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("holiday_reminder" IN (0, 1))',
    ),
  );
  static const VerificationMeta _holidayDaysBeforeMeta = const VerificationMeta(
    'holidayDaysBefore',
  );
  @override
  late final GeneratedColumn<int> holidayDaysBefore = GeneratedColumn<int>(
    'holiday_days_before',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _accrualReminderMeta = const VerificationMeta(
    'accrualReminder',
  );
  @override
  late final GeneratedColumn<bool> accrualReminder = GeneratedColumn<bool>(
    'accrual_reminder',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("accrual_reminder" IN (0, 1))',
    ),
  );
  static const VerificationMeta _plannedLeaveReminderMeta =
      const VerificationMeta('plannedLeaveReminder');
  @override
  late final GeneratedColumn<bool> plannedLeaveReminder = GeneratedColumn<bool>(
    'planned_leave_reminder',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("planned_leave_reminder" IN (0, 1))',
    ),
  );
  static const VerificationMeta _plannedLeaveDaysBeforeMeta =
      const VerificationMeta('plannedLeaveDaysBefore');
  @override
  late final GeneratedColumn<int> plannedLeaveDaysBefore = GeneratedColumn<int>(
    'planned_leave_days_before',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _yearEndReminderMeta = const VerificationMeta(
    'yearEndReminder',
  );
  @override
  late final GeneratedColumn<bool> yearEndReminder = GeneratedColumn<bool>(
    'year_end_reminder',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("year_end_reminder" IN (0, 1))',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    themeMode,
    activeProfileId,
    holidayReminder,
    holidayDaysBefore,
    accrualReminder,
    plannedLeaveReminder,
    plannedLeaveDaysBefore,
    yearEndReminder,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<SettingsRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('active_profile_id')) {
      context.handle(
        _activeProfileIdMeta,
        activeProfileId.isAcceptableOrUnknown(
          data['active_profile_id']!,
          _activeProfileIdMeta,
        ),
      );
    }
    if (data.containsKey('holiday_reminder')) {
      context.handle(
        _holidayReminderMeta,
        holidayReminder.isAcceptableOrUnknown(
          data['holiday_reminder']!,
          _holidayReminderMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_holidayReminderMeta);
    }
    if (data.containsKey('holiday_days_before')) {
      context.handle(
        _holidayDaysBeforeMeta,
        holidayDaysBefore.isAcceptableOrUnknown(
          data['holiday_days_before']!,
          _holidayDaysBeforeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_holidayDaysBeforeMeta);
    }
    if (data.containsKey('accrual_reminder')) {
      context.handle(
        _accrualReminderMeta,
        accrualReminder.isAcceptableOrUnknown(
          data['accrual_reminder']!,
          _accrualReminderMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_accrualReminderMeta);
    }
    if (data.containsKey('planned_leave_reminder')) {
      context.handle(
        _plannedLeaveReminderMeta,
        plannedLeaveReminder.isAcceptableOrUnknown(
          data['planned_leave_reminder']!,
          _plannedLeaveReminderMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_plannedLeaveReminderMeta);
    }
    if (data.containsKey('planned_leave_days_before')) {
      context.handle(
        _plannedLeaveDaysBeforeMeta,
        plannedLeaveDaysBefore.isAcceptableOrUnknown(
          data['planned_leave_days_before']!,
          _plannedLeaveDaysBeforeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_plannedLeaveDaysBeforeMeta);
    }
    if (data.containsKey('year_end_reminder')) {
      context.handle(
        _yearEndReminderMeta,
        yearEndReminder.isAcceptableOrUnknown(
          data['year_end_reminder']!,
          _yearEndReminderMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_yearEndReminderMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SettingsRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SettingsRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      themeMode: $SettingsTable.$converterthemeMode.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}theme_mode'],
        )!,
      ),
      activeProfileId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}active_profile_id'],
      ),
      holidayReminder: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}holiday_reminder'],
      )!,
      holidayDaysBefore: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}holiday_days_before'],
      )!,
      accrualReminder: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}accrual_reminder'],
      )!,
      plannedLeaveReminder: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}planned_leave_reminder'],
      )!,
      plannedLeaveDaysBefore: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}planned_leave_days_before'],
      )!,
      yearEndReminder: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}year_end_reminder'],
      )!,
    );
  }

  @override
  $SettingsTable createAlias(String alias) {
    return $SettingsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<AppThemeMode, String, String> $converterthemeMode =
      const EnumNameConverter<AppThemeMode>(AppThemeMode.values);
  @override
  bool get isStrict => true;
}

class SettingsRow extends DataClass implements Insertable<SettingsRow> {
  /// Always 1, so the table holds at most one row.
  final int id;

  /// Theme choice, stored by enum name.
  final AppThemeMode themeMode;

  /// Profile shown on the home screen. Cleared when that profile is deleted.
  final String? activeProfileId;

  /// `NotificationPreferences.holidayReminder`.
  final bool holidayReminder;

  /// `NotificationPreferences.holidayDaysBefore`.
  final int holidayDaysBefore;

  /// `NotificationPreferences.accrualReminder`.
  final bool accrualReminder;

  /// `NotificationPreferences.plannedLeaveReminder`.
  final bool plannedLeaveReminder;

  /// `NotificationPreferences.plannedLeaveDaysBefore`.
  final int plannedLeaveDaysBefore;

  /// `NotificationPreferences.yearEndReminder`.
  final bool yearEndReminder;
  const SettingsRow({
    required this.id,
    required this.themeMode,
    this.activeProfileId,
    required this.holidayReminder,
    required this.holidayDaysBefore,
    required this.accrualReminder,
    required this.plannedLeaveReminder,
    required this.plannedLeaveDaysBefore,
    required this.yearEndReminder,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    {
      map['theme_mode'] = Variable<String>(
        $SettingsTable.$converterthemeMode.toSql(themeMode),
      );
    }
    if (!nullToAbsent || activeProfileId != null) {
      map['active_profile_id'] = Variable<String>(activeProfileId);
    }
    map['holiday_reminder'] = Variable<bool>(holidayReminder);
    map['holiday_days_before'] = Variable<int>(holidayDaysBefore);
    map['accrual_reminder'] = Variable<bool>(accrualReminder);
    map['planned_leave_reminder'] = Variable<bool>(plannedLeaveReminder);
    map['planned_leave_days_before'] = Variable<int>(plannedLeaveDaysBefore);
    map['year_end_reminder'] = Variable<bool>(yearEndReminder);
    return map;
  }

  SettingsCompanion toCompanion(bool nullToAbsent) {
    return SettingsCompanion(
      id: Value(id),
      themeMode: Value(themeMode),
      activeProfileId: activeProfileId == null && nullToAbsent
          ? const Value.absent()
          : Value(activeProfileId),
      holidayReminder: Value(holidayReminder),
      holidayDaysBefore: Value(holidayDaysBefore),
      accrualReminder: Value(accrualReminder),
      plannedLeaveReminder: Value(plannedLeaveReminder),
      plannedLeaveDaysBefore: Value(plannedLeaveDaysBefore),
      yearEndReminder: Value(yearEndReminder),
    );
  }

  factory SettingsRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SettingsRow(
      id: serializer.fromJson<int>(json['id']),
      themeMode: $SettingsTable.$converterthemeMode.fromJson(
        serializer.fromJson<String>(json['themeMode']),
      ),
      activeProfileId: serializer.fromJson<String?>(json['activeProfileId']),
      holidayReminder: serializer.fromJson<bool>(json['holidayReminder']),
      holidayDaysBefore: serializer.fromJson<int>(json['holidayDaysBefore']),
      accrualReminder: serializer.fromJson<bool>(json['accrualReminder']),
      plannedLeaveReminder: serializer.fromJson<bool>(
        json['plannedLeaveReminder'],
      ),
      plannedLeaveDaysBefore: serializer.fromJson<int>(
        json['plannedLeaveDaysBefore'],
      ),
      yearEndReminder: serializer.fromJson<bool>(json['yearEndReminder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'themeMode': serializer.toJson<String>(
        $SettingsTable.$converterthemeMode.toJson(themeMode),
      ),
      'activeProfileId': serializer.toJson<String?>(activeProfileId),
      'holidayReminder': serializer.toJson<bool>(holidayReminder),
      'holidayDaysBefore': serializer.toJson<int>(holidayDaysBefore),
      'accrualReminder': serializer.toJson<bool>(accrualReminder),
      'plannedLeaveReminder': serializer.toJson<bool>(plannedLeaveReminder),
      'plannedLeaveDaysBefore': serializer.toJson<int>(plannedLeaveDaysBefore),
      'yearEndReminder': serializer.toJson<bool>(yearEndReminder),
    };
  }

  SettingsRow copyWith({
    int? id,
    AppThemeMode? themeMode,
    Value<String?> activeProfileId = const Value.absent(),
    bool? holidayReminder,
    int? holidayDaysBefore,
    bool? accrualReminder,
    bool? plannedLeaveReminder,
    int? plannedLeaveDaysBefore,
    bool? yearEndReminder,
  }) => SettingsRow(
    id: id ?? this.id,
    themeMode: themeMode ?? this.themeMode,
    activeProfileId: activeProfileId.present
        ? activeProfileId.value
        : this.activeProfileId,
    holidayReminder: holidayReminder ?? this.holidayReminder,
    holidayDaysBefore: holidayDaysBefore ?? this.holidayDaysBefore,
    accrualReminder: accrualReminder ?? this.accrualReminder,
    plannedLeaveReminder: plannedLeaveReminder ?? this.plannedLeaveReminder,
    plannedLeaveDaysBefore:
        plannedLeaveDaysBefore ?? this.plannedLeaveDaysBefore,
    yearEndReminder: yearEndReminder ?? this.yearEndReminder,
  );
  SettingsRow copyWithCompanion(SettingsCompanion data) {
    return SettingsRow(
      id: data.id.present ? data.id.value : this.id,
      themeMode: data.themeMode.present ? data.themeMode.value : this.themeMode,
      activeProfileId: data.activeProfileId.present
          ? data.activeProfileId.value
          : this.activeProfileId,
      holidayReminder: data.holidayReminder.present
          ? data.holidayReminder.value
          : this.holidayReminder,
      holidayDaysBefore: data.holidayDaysBefore.present
          ? data.holidayDaysBefore.value
          : this.holidayDaysBefore,
      accrualReminder: data.accrualReminder.present
          ? data.accrualReminder.value
          : this.accrualReminder,
      plannedLeaveReminder: data.plannedLeaveReminder.present
          ? data.plannedLeaveReminder.value
          : this.plannedLeaveReminder,
      plannedLeaveDaysBefore: data.plannedLeaveDaysBefore.present
          ? data.plannedLeaveDaysBefore.value
          : this.plannedLeaveDaysBefore,
      yearEndReminder: data.yearEndReminder.present
          ? data.yearEndReminder.value
          : this.yearEndReminder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SettingsRow(')
          ..write('id: $id, ')
          ..write('themeMode: $themeMode, ')
          ..write('activeProfileId: $activeProfileId, ')
          ..write('holidayReminder: $holidayReminder, ')
          ..write('holidayDaysBefore: $holidayDaysBefore, ')
          ..write('accrualReminder: $accrualReminder, ')
          ..write('plannedLeaveReminder: $plannedLeaveReminder, ')
          ..write('plannedLeaveDaysBefore: $plannedLeaveDaysBefore, ')
          ..write('yearEndReminder: $yearEndReminder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    themeMode,
    activeProfileId,
    holidayReminder,
    holidayDaysBefore,
    accrualReminder,
    plannedLeaveReminder,
    plannedLeaveDaysBefore,
    yearEndReminder,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SettingsRow &&
          other.id == this.id &&
          other.themeMode == this.themeMode &&
          other.activeProfileId == this.activeProfileId &&
          other.holidayReminder == this.holidayReminder &&
          other.holidayDaysBefore == this.holidayDaysBefore &&
          other.accrualReminder == this.accrualReminder &&
          other.plannedLeaveReminder == this.plannedLeaveReminder &&
          other.plannedLeaveDaysBefore == this.plannedLeaveDaysBefore &&
          other.yearEndReminder == this.yearEndReminder);
}

class SettingsCompanion extends UpdateCompanion<SettingsRow> {
  final Value<int> id;
  final Value<AppThemeMode> themeMode;
  final Value<String?> activeProfileId;
  final Value<bool> holidayReminder;
  final Value<int> holidayDaysBefore;
  final Value<bool> accrualReminder;
  final Value<bool> plannedLeaveReminder;
  final Value<int> plannedLeaveDaysBefore;
  final Value<bool> yearEndReminder;
  const SettingsCompanion({
    this.id = const Value.absent(),
    this.themeMode = const Value.absent(),
    this.activeProfileId = const Value.absent(),
    this.holidayReminder = const Value.absent(),
    this.holidayDaysBefore = const Value.absent(),
    this.accrualReminder = const Value.absent(),
    this.plannedLeaveReminder = const Value.absent(),
    this.plannedLeaveDaysBefore = const Value.absent(),
    this.yearEndReminder = const Value.absent(),
  });
  SettingsCompanion.insert({
    this.id = const Value.absent(),
    required AppThemeMode themeMode,
    this.activeProfileId = const Value.absent(),
    required bool holidayReminder,
    required int holidayDaysBefore,
    required bool accrualReminder,
    required bool plannedLeaveReminder,
    required int plannedLeaveDaysBefore,
    required bool yearEndReminder,
  }) : themeMode = Value(themeMode),
       holidayReminder = Value(holidayReminder),
       holidayDaysBefore = Value(holidayDaysBefore),
       accrualReminder = Value(accrualReminder),
       plannedLeaveReminder = Value(plannedLeaveReminder),
       plannedLeaveDaysBefore = Value(plannedLeaveDaysBefore),
       yearEndReminder = Value(yearEndReminder);
  static Insertable<SettingsRow> custom({
    Expression<int>? id,
    Expression<String>? themeMode,
    Expression<String>? activeProfileId,
    Expression<bool>? holidayReminder,
    Expression<int>? holidayDaysBefore,
    Expression<bool>? accrualReminder,
    Expression<bool>? plannedLeaveReminder,
    Expression<int>? plannedLeaveDaysBefore,
    Expression<bool>? yearEndReminder,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (themeMode != null) 'theme_mode': themeMode,
      if (activeProfileId != null) 'active_profile_id': activeProfileId,
      if (holidayReminder != null) 'holiday_reminder': holidayReminder,
      if (holidayDaysBefore != null) 'holiday_days_before': holidayDaysBefore,
      if (accrualReminder != null) 'accrual_reminder': accrualReminder,
      if (plannedLeaveReminder != null)
        'planned_leave_reminder': plannedLeaveReminder,
      if (plannedLeaveDaysBefore != null)
        'planned_leave_days_before': plannedLeaveDaysBefore,
      if (yearEndReminder != null) 'year_end_reminder': yearEndReminder,
    });
  }

  SettingsCompanion copyWith({
    Value<int>? id,
    Value<AppThemeMode>? themeMode,
    Value<String?>? activeProfileId,
    Value<bool>? holidayReminder,
    Value<int>? holidayDaysBefore,
    Value<bool>? accrualReminder,
    Value<bool>? plannedLeaveReminder,
    Value<int>? plannedLeaveDaysBefore,
    Value<bool>? yearEndReminder,
  }) {
    return SettingsCompanion(
      id: id ?? this.id,
      themeMode: themeMode ?? this.themeMode,
      activeProfileId: activeProfileId ?? this.activeProfileId,
      holidayReminder: holidayReminder ?? this.holidayReminder,
      holidayDaysBefore: holidayDaysBefore ?? this.holidayDaysBefore,
      accrualReminder: accrualReminder ?? this.accrualReminder,
      plannedLeaveReminder: plannedLeaveReminder ?? this.plannedLeaveReminder,
      plannedLeaveDaysBefore:
          plannedLeaveDaysBefore ?? this.plannedLeaveDaysBefore,
      yearEndReminder: yearEndReminder ?? this.yearEndReminder,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (themeMode.present) {
      map['theme_mode'] = Variable<String>(
        $SettingsTable.$converterthemeMode.toSql(themeMode.value),
      );
    }
    if (activeProfileId.present) {
      map['active_profile_id'] = Variable<String>(activeProfileId.value);
    }
    if (holidayReminder.present) {
      map['holiday_reminder'] = Variable<bool>(holidayReminder.value);
    }
    if (holidayDaysBefore.present) {
      map['holiday_days_before'] = Variable<int>(holidayDaysBefore.value);
    }
    if (accrualReminder.present) {
      map['accrual_reminder'] = Variable<bool>(accrualReminder.value);
    }
    if (plannedLeaveReminder.present) {
      map['planned_leave_reminder'] = Variable<bool>(
        plannedLeaveReminder.value,
      );
    }
    if (plannedLeaveDaysBefore.present) {
      map['planned_leave_days_before'] = Variable<int>(
        plannedLeaveDaysBefore.value,
      );
    }
    if (yearEndReminder.present) {
      map['year_end_reminder'] = Variable<bool>(yearEndReminder.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SettingsCompanion(')
          ..write('id: $id, ')
          ..write('themeMode: $themeMode, ')
          ..write('activeProfileId: $activeProfileId, ')
          ..write('holidayReminder: $holidayReminder, ')
          ..write('holidayDaysBefore: $holidayDaysBefore, ')
          ..write('accrualReminder: $accrualReminder, ')
          ..write('plannedLeaveReminder: $plannedLeaveReminder, ')
          ..write('plannedLeaveDaysBefore: $plannedLeaveDaysBefore, ')
          ..write('yearEndReminder: $yearEndReminder')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ProfilesTable profiles = $ProfilesTable(this);
  late final $LeaveRecordsTable leaveRecords = $LeaveRecordsTable(this);
  late final $OvertimeRecordsTable overtimeRecords = $OvertimeRecordsTable(
    this,
  );
  late final $SettingsTable settings = $SettingsTable(this);
  late final Index leaveRecordsProfileStart = Index(
    'leave_records_profile_start',
    'CREATE INDEX leave_records_profile_start ON leave_records (profile_id, start_date)',
  );
  late final Index overtimeRecordsProfileDate = Index(
    'overtime_records_profile_date',
    'CREATE INDEX overtime_records_profile_date ON overtime_records (profile_id, date)',
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    profiles,
    leaveRecords,
    overtimeRecords,
    settings,
    leaveRecordsProfileStart,
    overtimeRecordsProfileDate,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'profiles',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('leave_records', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'profiles',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('overtime_records', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'profiles',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('settings', kind: UpdateKind.update)],
    ),
  ]);
}

typedef $$ProfilesTableCreateCompanionBuilder = ProfilesCompanion Function({
  required String id,
  required String name,
  required EmploymentType employmentType,
  required DateTime employmentStartDate,
  Value<DateTime?> birthDate,
  required List<int> workDays,
  required int weeklyRestDay,
  required bool saturdayCountsAsLeave,
  required HalfDayDeduction halfDayDeduction,
  required double dailyWorkingHours,
  required int priorServiceYears,
  required int priorServiceMonths,
  required int priorServiceDays,
  required bool isUnderground,
  required int contractExtraDays,
  required double leaveUsedBeforeTracking,
  required bool isTeacher,
  required List<DateTime> administrativeLeaveDays,
  required List<DateRange> absencePeriods,
  Value<int> rowid,
});
typedef $$ProfilesTableUpdateCompanionBuilder = ProfilesCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<EmploymentType> employmentType,
  Value<DateTime> employmentStartDate,
  Value<DateTime?> birthDate,
  Value<List<int>> workDays,
  Value<int> weeklyRestDay,
  Value<bool> saturdayCountsAsLeave,
  Value<HalfDayDeduction> halfDayDeduction,
  Value<double> dailyWorkingHours,
  Value<int> priorServiceYears,
  Value<int> priorServiceMonths,
  Value<int> priorServiceDays,
  Value<bool> isUnderground,
  Value<int> contractExtraDays,
  Value<double> leaveUsedBeforeTracking,
  Value<bool> isTeacher,
  Value<List<DateTime>> administrativeLeaveDays,
  Value<List<DateRange>> absencePeriods,
  Value<int> rowid,
});

final class $$ProfilesTableReferences
    extends BaseReferences<_$AppDatabase, $ProfilesTable, ProfileRow> {
  $$ProfilesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$LeaveRecordsTable, List<LeaveRecordRow>>
  _leaveRecordsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.leaveRecords,
    aliasName: 'profiles__id__leave_records__profile_id',
  );

  $$LeaveRecordsTableProcessedTableManager get leaveRecordsRefs {
    final manager = $$LeaveRecordsTableTableManager(
      $_db,
      $_db.leaveRecords,
    ).filter((f) => f.profileId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_leaveRecordsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$OvertimeRecordsTable, List<OvertimeRecordRow>>
  _overtimeRecordsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.overtimeRecords,
    aliasName: 'profiles__id__overtime_records__profile_id',
  );

  $$OvertimeRecordsTableProcessedTableManager get overtimeRecordsRefs {
    final manager = $$OvertimeRecordsTableTableManager(
      $_db,
      $_db.overtimeRecords,
    ).filter((f) => f.profileId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _overtimeRecordsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$SettingsTable, List<SettingsRow>>
  _settingsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.settings,
    aliasName: 'profiles__id__settings__active_profile_id',
  );

  $$SettingsTableProcessedTableManager get settingsRefs {
    final manager = $$SettingsTableTableManager($_db, $_db.settings).filter(
      (f) => f.activeProfileId.id.sqlEquals($_itemColumn<String>('id')!),
    );

    final cache = $_typedResult.readTableOrNull(_settingsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ProfilesTableFilterComposer
    extends Composer<_$AppDatabase, $ProfilesTable> {
  $$ProfilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<EmploymentType, EmploymentType, String>
  get employmentType => $composableBuilder(
    column: $table.employmentType,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<DateTime, DateTime, String>
  get employmentStartDate => $composableBuilder(
    column: $table.employmentStartDate,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<DateTime?, DateTime, String> get birthDate =>
      $composableBuilder(
        column: $table.birthDate,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<List<int>, List<int>, String> get workDays =>
      $composableBuilder(
        column: $table.workDays,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get weeklyRestDay => $composableBuilder(
    column: $table.weeklyRestDay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get saturdayCountsAsLeave => $composableBuilder(
    column: $table.saturdayCountsAsLeave,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<HalfDayDeduction, HalfDayDeduction, String>
  get halfDayDeduction => $composableBuilder(
    column: $table.halfDayDeduction,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<double> get dailyWorkingHours => $composableBuilder(
    column: $table.dailyWorkingHours,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get priorServiceYears => $composableBuilder(
    column: $table.priorServiceYears,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get priorServiceMonths => $composableBuilder(
    column: $table.priorServiceMonths,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get priorServiceDays => $composableBuilder(
    column: $table.priorServiceDays,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isUnderground => $composableBuilder(
    column: $table.isUnderground,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get contractExtraDays => $composableBuilder(
    column: $table.contractExtraDays,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get leaveUsedBeforeTracking => $composableBuilder(
    column: $table.leaveUsedBeforeTracking,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isTeacher => $composableBuilder(
    column: $table.isTeacher,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<List<DateTime>, List<DateTime>, String>
  get administrativeLeaveDays => $composableBuilder(
    column: $table.administrativeLeaveDays,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<List<DateRange>, List<DateRange>, String>
  get absencePeriods => $composableBuilder(
    column: $table.absencePeriods,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  Expression<bool> leaveRecordsRefs(
    Expression<bool> Function($$LeaveRecordsTableFilterComposer f) f,
  ) {
    final $$LeaveRecordsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.leaveRecords,
      getReferencedColumn: (t) => t.profileId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LeaveRecordsTableFilterComposer(
            $db: $db,
            $table: $db.leaveRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> overtimeRecordsRefs(
    Expression<bool> Function($$OvertimeRecordsTableFilterComposer f) f,
  ) {
    final $$OvertimeRecordsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.overtimeRecords,
      getReferencedColumn: (t) => t.profileId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OvertimeRecordsTableFilterComposer(
            $db: $db,
            $table: $db.overtimeRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> settingsRefs(
    Expression<bool> Function($$SettingsTableFilterComposer f) f,
  ) {
    final $$SettingsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.settings,
      getReferencedColumn: (t) => t.activeProfileId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SettingsTableFilterComposer(
            $db: $db,
            $table: $db.settings,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ProfilesTableOrderingComposer
    extends Composer<_$AppDatabase, $ProfilesTable> {
  $$ProfilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get employmentType => $composableBuilder(
    column: $table.employmentType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get employmentStartDate => $composableBuilder(
    column: $table.employmentStartDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get birthDate => $composableBuilder(
    column: $table.birthDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get workDays => $composableBuilder(
    column: $table.workDays,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get weeklyRestDay => $composableBuilder(
    column: $table.weeklyRestDay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get saturdayCountsAsLeave => $composableBuilder(
    column: $table.saturdayCountsAsLeave,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get halfDayDeduction => $composableBuilder(
    column: $table.halfDayDeduction,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get dailyWorkingHours => $composableBuilder(
    column: $table.dailyWorkingHours,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get priorServiceYears => $composableBuilder(
    column: $table.priorServiceYears,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get priorServiceMonths => $composableBuilder(
    column: $table.priorServiceMonths,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get priorServiceDays => $composableBuilder(
    column: $table.priorServiceDays,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isUnderground => $composableBuilder(
    column: $table.isUnderground,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get contractExtraDays => $composableBuilder(
    column: $table.contractExtraDays,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get leaveUsedBeforeTracking => $composableBuilder(
    column: $table.leaveUsedBeforeTracking,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isTeacher => $composableBuilder(
    column: $table.isTeacher,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get administrativeLeaveDays => $composableBuilder(
    column: $table.administrativeLeaveDays,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get absencePeriods => $composableBuilder(
    column: $table.absencePeriods,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProfilesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProfilesTable> {
  $$ProfilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumnWithTypeConverter<EmploymentType, String> get employmentType =>
      $composableBuilder(
        column: $table.employmentType,
        builder: (column) => column,
      );

  GeneratedColumnWithTypeConverter<DateTime, String> get employmentStartDate =>
      $composableBuilder(
        column: $table.employmentStartDate,
        builder: (column) => column,
      );

  GeneratedColumnWithTypeConverter<DateTime?, String> get birthDate =>
      $composableBuilder(column: $table.birthDate, builder: (column) => column);

  GeneratedColumnWithTypeConverter<List<int>, String> get workDays =>
      $composableBuilder(column: $table.workDays, builder: (column) => column);

  GeneratedColumn<int> get weeklyRestDay => $composableBuilder(
    column: $table.weeklyRestDay,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get saturdayCountsAsLeave => $composableBuilder(
    column: $table.saturdayCountsAsLeave,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<HalfDayDeduction, String>
  get halfDayDeduction => $composableBuilder(
    column: $table.halfDayDeduction,
    builder: (column) => column,
  );

  GeneratedColumn<double> get dailyWorkingHours => $composableBuilder(
    column: $table.dailyWorkingHours,
    builder: (column) => column,
  );

  GeneratedColumn<int> get priorServiceYears => $composableBuilder(
    column: $table.priorServiceYears,
    builder: (column) => column,
  );

  GeneratedColumn<int> get priorServiceMonths => $composableBuilder(
    column: $table.priorServiceMonths,
    builder: (column) => column,
  );

  GeneratedColumn<int> get priorServiceDays => $composableBuilder(
    column: $table.priorServiceDays,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isUnderground => $composableBuilder(
    column: $table.isUnderground,
    builder: (column) => column,
  );

  GeneratedColumn<int> get contractExtraDays => $composableBuilder(
    column: $table.contractExtraDays,
    builder: (column) => column,
  );

  GeneratedColumn<double> get leaveUsedBeforeTracking => $composableBuilder(
    column: $table.leaveUsedBeforeTracking,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isTeacher =>
      $composableBuilder(column: $table.isTeacher, builder: (column) => column);

  GeneratedColumnWithTypeConverter<List<DateTime>, String>
  get administrativeLeaveDays => $composableBuilder(
    column: $table.administrativeLeaveDays,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<List<DateRange>, String>
  get absencePeriods => $composableBuilder(
    column: $table.absencePeriods,
    builder: (column) => column,
  );

  Expression<T> leaveRecordsRefs<T extends Object>(
    Expression<T> Function($$LeaveRecordsTableAnnotationComposer a) f,
  ) {
    final $$LeaveRecordsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.leaveRecords,
      getReferencedColumn: (t) => t.profileId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LeaveRecordsTableAnnotationComposer(
            $db: $db,
            $table: $db.leaveRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> overtimeRecordsRefs<T extends Object>(
    Expression<T> Function($$OvertimeRecordsTableAnnotationComposer a) f,
  ) {
    final $$OvertimeRecordsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.overtimeRecords,
      getReferencedColumn: (t) => t.profileId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OvertimeRecordsTableAnnotationComposer(
            $db: $db,
            $table: $db.overtimeRecords,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> settingsRefs<T extends Object>(
    Expression<T> Function($$SettingsTableAnnotationComposer a) f,
  ) {
    final $$SettingsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.settings,
      getReferencedColumn: (t) => t.activeProfileId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SettingsTableAnnotationComposer(
            $db: $db,
            $table: $db.settings,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ProfilesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProfilesTable,
          ProfileRow,
          $$ProfilesTableFilterComposer,
          $$ProfilesTableOrderingComposer,
          $$ProfilesTableAnnotationComposer,
          $$ProfilesTableCreateCompanionBuilder,
          $$ProfilesTableUpdateCompanionBuilder,
          (ProfileRow, $$ProfilesTableReferences),
          ProfileRow,
          PrefetchHooks Function({
            bool leaveRecordsRefs,
            bool overtimeRecordsRefs,
            bool settingsRefs,
          })
        > {
  $$ProfilesTableTableManager(_$AppDatabase db, $ProfilesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProfilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProfilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProfilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<EmploymentType> employmentType = const Value.absent(),
                Value<DateTime> employmentStartDate = const Value.absent(),
                Value<DateTime?> birthDate = const Value.absent(),
                Value<List<int>> workDays = const Value.absent(),
                Value<int> weeklyRestDay = const Value.absent(),
                Value<bool> saturdayCountsAsLeave = const Value.absent(),
                Value<HalfDayDeduction> halfDayDeduction = const Value.absent(),
                Value<double> dailyWorkingHours = const Value.absent(),
                Value<int> priorServiceYears = const Value.absent(),
                Value<int> priorServiceMonths = const Value.absent(),
                Value<int> priorServiceDays = const Value.absent(),
                Value<bool> isUnderground = const Value.absent(),
                Value<int> contractExtraDays = const Value.absent(),
                Value<double> leaveUsedBeforeTracking = const Value.absent(),
                Value<bool> isTeacher = const Value.absent(),
                Value<List<DateTime>> administrativeLeaveDays =
                    const Value.absent(),
                Value<List<DateRange>> absencePeriods = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProfilesCompanion(
                id: id,
                name: name,
                employmentType: employmentType,
                employmentStartDate: employmentStartDate,
                birthDate: birthDate,
                workDays: workDays,
                weeklyRestDay: weeklyRestDay,
                saturdayCountsAsLeave: saturdayCountsAsLeave,
                halfDayDeduction: halfDayDeduction,
                dailyWorkingHours: dailyWorkingHours,
                priorServiceYears: priorServiceYears,
                priorServiceMonths: priorServiceMonths,
                priorServiceDays: priorServiceDays,
                isUnderground: isUnderground,
                contractExtraDays: contractExtraDays,
                leaveUsedBeforeTracking: leaveUsedBeforeTracking,
                isTeacher: isTeacher,
                administrativeLeaveDays: administrativeLeaveDays,
                absencePeriods: absencePeriods,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required EmploymentType employmentType,
                required DateTime employmentStartDate,
                Value<DateTime?> birthDate = const Value.absent(),
                required List<int> workDays,
                required int weeklyRestDay,
                required bool saturdayCountsAsLeave,
                required HalfDayDeduction halfDayDeduction,
                required double dailyWorkingHours,
                required int priorServiceYears,
                required int priorServiceMonths,
                required int priorServiceDays,
                required bool isUnderground,
                required int contractExtraDays,
                required double leaveUsedBeforeTracking,
                required bool isTeacher,
                required List<DateTime> administrativeLeaveDays,
                required List<DateRange> absencePeriods,
                Value<int> rowid = const Value.absent(),
              }) => ProfilesCompanion.insert(
                id: id,
                name: name,
                employmentType: employmentType,
                employmentStartDate: employmentStartDate,
                birthDate: birthDate,
                workDays: workDays,
                weeklyRestDay: weeklyRestDay,
                saturdayCountsAsLeave: saturdayCountsAsLeave,
                halfDayDeduction: halfDayDeduction,
                dailyWorkingHours: dailyWorkingHours,
                priorServiceYears: priorServiceYears,
                priorServiceMonths: priorServiceMonths,
                priorServiceDays: priorServiceDays,
                isUnderground: isUnderground,
                contractExtraDays: contractExtraDays,
                leaveUsedBeforeTracking: leaveUsedBeforeTracking,
                isTeacher: isTeacher,
                administrativeLeaveDays: administrativeLeaveDays,
                absencePeriods: absencePeriods,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ProfilesTable, ProfileRow>(table),
                  $$ProfilesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                leaveRecordsRefs = false,
                overtimeRecordsRefs = false,
                settingsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (leaveRecordsRefs) db.leaveRecords,
                    if (overtimeRecordsRefs) db.overtimeRecords,
                    if (settingsRefs) db.settings,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (leaveRecordsRefs)
                        await $_getPrefetchedDataByColumns<
                          ProfileRow,
                          $ProfilesTable,
                          LeaveRecordRow,
                          $LeaveRecordsTable
                        >(
                          currentTable: table,
                          referencedTable: $$ProfilesTableReferences
                              ._leaveRecordsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProfilesTableReferences(
                                db,
                                table,
                                p0,
                              ).leaveRecordsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'profile_id',
                          typedResults: items,
                        ),
                      if (overtimeRecordsRefs)
                        await $_getPrefetchedDataByColumns<
                          ProfileRow,
                          $ProfilesTable,
                          OvertimeRecordRow,
                          $OvertimeRecordsTable
                        >(
                          currentTable: table,
                          referencedTable: $$ProfilesTableReferences
                              ._overtimeRecordsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProfilesTableReferences(
                                db,
                                table,
                                p0,
                              ).overtimeRecordsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'profile_id',
                          typedResults: items,
                        ),
                      if (settingsRefs)
                        await $_getPrefetchedDataByColumns<
                          ProfileRow,
                          $ProfilesTable,
                          SettingsRow,
                          $SettingsTable
                        >(
                          currentTable: table,
                          referencedTable: $$ProfilesTableReferences
                              ._settingsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProfilesTableReferences(
                                db,
                                table,
                                p0,
                              ).settingsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'active_profile_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$ProfilesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProfilesTable,
      ProfileRow,
      $$ProfilesTableFilterComposer,
      $$ProfilesTableOrderingComposer,
      $$ProfilesTableAnnotationComposer,
      $$ProfilesTableCreateCompanionBuilder,
      $$ProfilesTableUpdateCompanionBuilder,
      (ProfileRow, $$ProfilesTableReferences),
      ProfileRow,
      PrefetchHooks Function({
        bool leaveRecordsRefs,
        bool overtimeRecordsRefs,
        bool settingsRefs,
      })
    >;
typedef $$LeaveRecordsTableCreateCompanionBuilder =
    LeaveRecordsCompanion Function({
      required String id,
      required String profileId,
      required LeaveType type,
      required DateTime startDate,
      required DateTime endDate,
      required LeaveUnit unit,
      Value<double?> hours,
      Value<String?> customTypeName,
      Value<DateTime?> eventDate,
      required bool deductsFromAnnual,
      Value<String?> note,
      Value<int> rowid,
    });
typedef $$LeaveRecordsTableUpdateCompanionBuilder =
    LeaveRecordsCompanion Function({
      Value<String> id,
      Value<String> profileId,
      Value<LeaveType> type,
      Value<DateTime> startDate,
      Value<DateTime> endDate,
      Value<LeaveUnit> unit,
      Value<double?> hours,
      Value<String?> customTypeName,
      Value<DateTime?> eventDate,
      Value<bool> deductsFromAnnual,
      Value<String?> note,
      Value<int> rowid,
    });

final class $$LeaveRecordsTableReferences
    extends BaseReferences<_$AppDatabase, $LeaveRecordsTable, LeaveRecordRow> {
  $$LeaveRecordsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ProfilesTable _profileIdTable(_$AppDatabase db) =>
      db.profiles.createAlias('leave_records__profile_id__profiles__id');

  $$ProfilesTableProcessedTableManager get profileId {
    final $_column = $_itemColumn<String>('profile_id')!;

    final manager = $$ProfilesTableTableManager(
      $_db,
      $_db.profiles,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_profileIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$LeaveRecordsTableFilterComposer
    extends Composer<_$AppDatabase, $LeaveRecordsTable> {
  $$LeaveRecordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<LeaveType, LeaveType, String> get type =>
      $composableBuilder(
        column: $table.type,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<DateTime, DateTime, String> get startDate =>
      $composableBuilder(
        column: $table.startDate,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<DateTime, DateTime, String> get endDate =>
      $composableBuilder(
        column: $table.endDate,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<LeaveUnit, LeaveUnit, String> get unit =>
      $composableBuilder(
        column: $table.unit,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<double> get hours => $composableBuilder(
    column: $table.hours,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get customTypeName => $composableBuilder(
    column: $table.customTypeName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<DateTime?, DateTime, String> get eventDate =>
      $composableBuilder(
        column: $table.eventDate,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<bool> get deductsFromAnnual => $composableBuilder(
    column: $table.deductsFromAnnual,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  $$ProfilesTableFilterComposer get profileId {
    final $$ProfilesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.profiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProfilesTableFilterComposer(
            $db: $db,
            $table: $db.profiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LeaveRecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $LeaveRecordsTable> {
  $$LeaveRecordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get hours => $composableBuilder(
    column: $table.hours,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get customTypeName => $composableBuilder(
    column: $table.customTypeName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get eventDate => $composableBuilder(
    column: $table.eventDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get deductsFromAnnual => $composableBuilder(
    column: $table.deductsFromAnnual,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  $$ProfilesTableOrderingComposer get profileId {
    final $$ProfilesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.profiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProfilesTableOrderingComposer(
            $db: $db,
            $table: $db.profiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LeaveRecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LeaveRecordsTable> {
  $$LeaveRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<LeaveType, String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DateTime, String> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DateTime, String> get endDate =>
      $composableBuilder(column: $table.endDate, builder: (column) => column);

  GeneratedColumnWithTypeConverter<LeaveUnit, String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<double> get hours =>
      $composableBuilder(column: $table.hours, builder: (column) => column);

  GeneratedColumn<String> get customTypeName => $composableBuilder(
    column: $table.customTypeName,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<DateTime?, String> get eventDate =>
      $composableBuilder(column: $table.eventDate, builder: (column) => column);

  GeneratedColumn<bool> get deductsFromAnnual => $composableBuilder(
    column: $table.deductsFromAnnual,
    builder: (column) => column,
  );

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  $$ProfilesTableAnnotationComposer get profileId {
    final $$ProfilesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.profiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProfilesTableAnnotationComposer(
            $db: $db,
            $table: $db.profiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LeaveRecordsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LeaveRecordsTable,
          LeaveRecordRow,
          $$LeaveRecordsTableFilterComposer,
          $$LeaveRecordsTableOrderingComposer,
          $$LeaveRecordsTableAnnotationComposer,
          $$LeaveRecordsTableCreateCompanionBuilder,
          $$LeaveRecordsTableUpdateCompanionBuilder,
          (LeaveRecordRow, $$LeaveRecordsTableReferences),
          LeaveRecordRow,
          PrefetchHooks Function({bool profileId})
        > {
  $$LeaveRecordsTableTableManager(_$AppDatabase db, $LeaveRecordsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LeaveRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LeaveRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LeaveRecordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> profileId = const Value.absent(),
                Value<LeaveType> type = const Value.absent(),
                Value<DateTime> startDate = const Value.absent(),
                Value<DateTime> endDate = const Value.absent(),
                Value<LeaveUnit> unit = const Value.absent(),
                Value<double?> hours = const Value.absent(),
                Value<String?> customTypeName = const Value.absent(),
                Value<DateTime?> eventDate = const Value.absent(),
                Value<bool> deductsFromAnnual = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LeaveRecordsCompanion(
                id: id,
                profileId: profileId,
                type: type,
                startDate: startDate,
                endDate: endDate,
                unit: unit,
                hours: hours,
                customTypeName: customTypeName,
                eventDate: eventDate,
                deductsFromAnnual: deductsFromAnnual,
                note: note,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String profileId,
                required LeaveType type,
                required DateTime startDate,
                required DateTime endDate,
                required LeaveUnit unit,
                Value<double?> hours = const Value.absent(),
                Value<String?> customTypeName = const Value.absent(),
                Value<DateTime?> eventDate = const Value.absent(),
                required bool deductsFromAnnual,
                Value<String?> note = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LeaveRecordsCompanion.insert(
                id: id,
                profileId: profileId,
                type: type,
                startDate: startDate,
                endDate: endDate,
                unit: unit,
                hours: hours,
                customTypeName: customTypeName,
                eventDate: eventDate,
                deductsFromAnnual: deductsFromAnnual,
                note: note,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$LeaveRecordsTable, LeaveRecordRow>(table),
                  $$LeaveRecordsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({profileId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (profileId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.profileId,
                        referencedTable: $$LeaveRecordsTableReferences
                            ._profileIdTable(db),
                        referencedColumn: $$LeaveRecordsTableReferences
                            ._profileIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$LeaveRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LeaveRecordsTable,
      LeaveRecordRow,
      $$LeaveRecordsTableFilterComposer,
      $$LeaveRecordsTableOrderingComposer,
      $$LeaveRecordsTableAnnotationComposer,
      $$LeaveRecordsTableCreateCompanionBuilder,
      $$LeaveRecordsTableUpdateCompanionBuilder,
      (LeaveRecordRow, $$LeaveRecordsTableReferences),
      LeaveRecordRow,
      PrefetchHooks Function({bool profileId})
    >;
typedef $$OvertimeRecordsTableCreateCompanionBuilder =
    OvertimeRecordsCompanion Function({
      required String id,
      required String profileId,
      required DateTime date,
      required double hours,
      Value<String?> note,
      Value<int> rowid,
    });
typedef $$OvertimeRecordsTableUpdateCompanionBuilder =
    OvertimeRecordsCompanion Function({
      Value<String> id,
      Value<String> profileId,
      Value<DateTime> date,
      Value<double> hours,
      Value<String?> note,
      Value<int> rowid,
    });

final class $$OvertimeRecordsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $OvertimeRecordsTable,
          OvertimeRecordRow
        > {
  $$OvertimeRecordsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ProfilesTable _profileIdTable(_$AppDatabase db) =>
      db.profiles.createAlias('overtime_records__profile_id__profiles__id');

  $$ProfilesTableProcessedTableManager get profileId {
    final $_column = $_itemColumn<String>('profile_id')!;

    final manager = $$ProfilesTableTableManager(
      $_db,
      $_db.profiles,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_profileIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$OvertimeRecordsTableFilterComposer
    extends Composer<_$AppDatabase, $OvertimeRecordsTable> {
  $$OvertimeRecordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<DateTime, DateTime, String> get date =>
      $composableBuilder(
        column: $table.date,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<double> get hours => $composableBuilder(
    column: $table.hours,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  $$ProfilesTableFilterComposer get profileId {
    final $$ProfilesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.profiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProfilesTableFilterComposer(
            $db: $db,
            $table: $db.profiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$OvertimeRecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $OvertimeRecordsTable> {
  $$OvertimeRecordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get hours => $composableBuilder(
    column: $table.hours,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  $$ProfilesTableOrderingComposer get profileId {
    final $$ProfilesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.profiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProfilesTableOrderingComposer(
            $db: $db,
            $table: $db.profiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$OvertimeRecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $OvertimeRecordsTable> {
  $$OvertimeRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DateTime, String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<double> get hours =>
      $composableBuilder(column: $table.hours, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  $$ProfilesTableAnnotationComposer get profileId {
    final $$ProfilesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.profiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProfilesTableAnnotationComposer(
            $db: $db,
            $table: $db.profiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$OvertimeRecordsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $OvertimeRecordsTable,
          OvertimeRecordRow,
          $$OvertimeRecordsTableFilterComposer,
          $$OvertimeRecordsTableOrderingComposer,
          $$OvertimeRecordsTableAnnotationComposer,
          $$OvertimeRecordsTableCreateCompanionBuilder,
          $$OvertimeRecordsTableUpdateCompanionBuilder,
          (OvertimeRecordRow, $$OvertimeRecordsTableReferences),
          OvertimeRecordRow,
          PrefetchHooks Function({bool profileId})
        > {
  $$OvertimeRecordsTableTableManager(
    _$AppDatabase db,
    $OvertimeRecordsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OvertimeRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OvertimeRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OvertimeRecordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> profileId = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<double> hours = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => OvertimeRecordsCompanion(
                id: id,
                profileId: profileId,
                date: date,
                hours: hours,
                note: note,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String profileId,
                required DateTime date,
                required double hours,
                Value<String?> note = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => OvertimeRecordsCompanion.insert(
                id: id,
                profileId: profileId,
                date: date,
                hours: hours,
                note: note,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$OvertimeRecordsTable, OvertimeRecordRow>(table),
                  $$OvertimeRecordsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({profileId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (profileId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.profileId,
                        referencedTable: $$OvertimeRecordsTableReferences
                            ._profileIdTable(db),
                        referencedColumn: $$OvertimeRecordsTableReferences
                            ._profileIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$OvertimeRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $OvertimeRecordsTable,
      OvertimeRecordRow,
      $$OvertimeRecordsTableFilterComposer,
      $$OvertimeRecordsTableOrderingComposer,
      $$OvertimeRecordsTableAnnotationComposer,
      $$OvertimeRecordsTableCreateCompanionBuilder,
      $$OvertimeRecordsTableUpdateCompanionBuilder,
      (OvertimeRecordRow, $$OvertimeRecordsTableReferences),
      OvertimeRecordRow,
      PrefetchHooks Function({bool profileId})
    >;
typedef $$SettingsTableCreateCompanionBuilder = SettingsCompanion Function({
  Value<int> id,
  required AppThemeMode themeMode,
  Value<String?> activeProfileId,
  required bool holidayReminder,
  required int holidayDaysBefore,
  required bool accrualReminder,
  required bool plannedLeaveReminder,
  required int plannedLeaveDaysBefore,
  required bool yearEndReminder,
});
typedef $$SettingsTableUpdateCompanionBuilder = SettingsCompanion Function({
  Value<int> id,
  Value<AppThemeMode> themeMode,
  Value<String?> activeProfileId,
  Value<bool> holidayReminder,
  Value<int> holidayDaysBefore,
  Value<bool> accrualReminder,
  Value<bool> plannedLeaveReminder,
  Value<int> plannedLeaveDaysBefore,
  Value<bool> yearEndReminder,
});

final class $$SettingsTableReferences
    extends BaseReferences<_$AppDatabase, $SettingsTable, SettingsRow> {
  $$SettingsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ProfilesTable _activeProfileIdTable(_$AppDatabase db) =>
      db.profiles.createAlias('settings__active_profile_id__profiles__id');

  $$ProfilesTableProcessedTableManager? get activeProfileId {
    final $_column = $_itemColumn<String>('active_profile_id');
    if ($_column == null) return null;
    final manager = $$ProfilesTableTableManager(
      $_db,
      $_db.profiles,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_activeProfileIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

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

  ColumnWithTypeConverterFilters<AppThemeMode, AppThemeMode, String>
  get themeMode => $composableBuilder(
    column: $table.themeMode,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<bool> get holidayReminder => $composableBuilder(
    column: $table.holidayReminder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get holidayDaysBefore => $composableBuilder(
    column: $table.holidayDaysBefore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get accrualReminder => $composableBuilder(
    column: $table.accrualReminder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get plannedLeaveReminder => $composableBuilder(
    column: $table.plannedLeaveReminder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get plannedLeaveDaysBefore => $composableBuilder(
    column: $table.plannedLeaveDaysBefore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get yearEndReminder => $composableBuilder(
    column: $table.yearEndReminder,
    builder: (column) => ColumnFilters(column),
  );

  $$ProfilesTableFilterComposer get activeProfileId {
    final $$ProfilesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.activeProfileId,
      referencedTable: $db.profiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProfilesTableFilterComposer(
            $db: $db,
            $table: $db.profiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
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

  ColumnOrderings<String> get themeMode => $composableBuilder(
    column: $table.themeMode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get holidayReminder => $composableBuilder(
    column: $table.holidayReminder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get holidayDaysBefore => $composableBuilder(
    column: $table.holidayDaysBefore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get accrualReminder => $composableBuilder(
    column: $table.accrualReminder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get plannedLeaveReminder => $composableBuilder(
    column: $table.plannedLeaveReminder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get plannedLeaveDaysBefore => $composableBuilder(
    column: $table.plannedLeaveDaysBefore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get yearEndReminder => $composableBuilder(
    column: $table.yearEndReminder,
    builder: (column) => ColumnOrderings(column),
  );

  $$ProfilesTableOrderingComposer get activeProfileId {
    final $$ProfilesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.activeProfileId,
      referencedTable: $db.profiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProfilesTableOrderingComposer(
            $db: $db,
            $table: $db.profiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
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

  GeneratedColumnWithTypeConverter<AppThemeMode, String> get themeMode =>
      $composableBuilder(column: $table.themeMode, builder: (column) => column);

  GeneratedColumn<bool> get holidayReminder => $composableBuilder(
    column: $table.holidayReminder,
    builder: (column) => column,
  );

  GeneratedColumn<int> get holidayDaysBefore => $composableBuilder(
    column: $table.holidayDaysBefore,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get accrualReminder => $composableBuilder(
    column: $table.accrualReminder,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get plannedLeaveReminder => $composableBuilder(
    column: $table.plannedLeaveReminder,
    builder: (column) => column,
  );

  GeneratedColumn<int> get plannedLeaveDaysBefore => $composableBuilder(
    column: $table.plannedLeaveDaysBefore,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get yearEndReminder => $composableBuilder(
    column: $table.yearEndReminder,
    builder: (column) => column,
  );

  $$ProfilesTableAnnotationComposer get activeProfileId {
    final $$ProfilesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.activeProfileId,
      referencedTable: $db.profiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProfilesTableAnnotationComposer(
            $db: $db,
            $table: $db.profiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SettingsTable,
          SettingsRow,
          $$SettingsTableFilterComposer,
          $$SettingsTableOrderingComposer,
          $$SettingsTableAnnotationComposer,
          $$SettingsTableCreateCompanionBuilder,
          $$SettingsTableUpdateCompanionBuilder,
          (SettingsRow, $$SettingsTableReferences),
          SettingsRow,
          PrefetchHooks Function({bool activeProfileId})
        > {
  $$SettingsTableTableManager(_$AppDatabase db, $SettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<AppThemeMode> themeMode = const Value.absent(),
                Value<String?> activeProfileId = const Value.absent(),
                Value<bool> holidayReminder = const Value.absent(),
                Value<int> holidayDaysBefore = const Value.absent(),
                Value<bool> accrualReminder = const Value.absent(),
                Value<bool> plannedLeaveReminder = const Value.absent(),
                Value<int> plannedLeaveDaysBefore = const Value.absent(),
                Value<bool> yearEndReminder = const Value.absent(),
              }) => SettingsCompanion(
                id: id,
                themeMode: themeMode,
                activeProfileId: activeProfileId,
                holidayReminder: holidayReminder,
                holidayDaysBefore: holidayDaysBefore,
                accrualReminder: accrualReminder,
                plannedLeaveReminder: plannedLeaveReminder,
                plannedLeaveDaysBefore: plannedLeaveDaysBefore,
                yearEndReminder: yearEndReminder,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required AppThemeMode themeMode,
                Value<String?> activeProfileId = const Value.absent(),
                required bool holidayReminder,
                required int holidayDaysBefore,
                required bool accrualReminder,
                required bool plannedLeaveReminder,
                required int plannedLeaveDaysBefore,
                required bool yearEndReminder,
              }) => SettingsCompanion.insert(
                id: id,
                themeMode: themeMode,
                activeProfileId: activeProfileId,
                holidayReminder: holidayReminder,
                holidayDaysBefore: holidayDaysBefore,
                accrualReminder: accrualReminder,
                plannedLeaveReminder: plannedLeaveReminder,
                plannedLeaveDaysBefore: plannedLeaveDaysBefore,
                yearEndReminder: yearEndReminder,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SettingsTable, SettingsRow>(table),
                  $$SettingsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({activeProfileId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (activeProfileId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.activeProfileId,
                        referencedTable: $$SettingsTableReferences
                            ._activeProfileIdTable(db),
                        referencedColumn: $$SettingsTableReferences
                            ._activeProfileIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$SettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SettingsTable,
      SettingsRow,
      $$SettingsTableFilterComposer,
      $$SettingsTableOrderingComposer,
      $$SettingsTableAnnotationComposer,
      $$SettingsTableCreateCompanionBuilder,
      $$SettingsTableUpdateCompanionBuilder,
      (SettingsRow, $$SettingsTableReferences),
      SettingsRow,
      PrefetchHooks Function({bool activeProfileId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ProfilesTableTableManager get profiles =>
      $$ProfilesTableTableManager(_db, _db.profiles);
  $$LeaveRecordsTableTableManager get leaveRecords =>
      $$LeaveRecordsTableTableManager(_db, _db.leaveRecords);
  $$OvertimeRecordsTableTableManager get overtimeRecords =>
      $$OvertimeRecordsTableTableManager(_db, _db.overtimeRecords);
  $$SettingsTableTableManager get settings =>
      $$SettingsTableTableManager(_db, _db.settings);
}
