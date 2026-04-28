// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'recipe.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

RecipeIngredient _$RecipeIngredientFromJson(Map<String, dynamic> json) {
  return _RecipeIngredient.fromJson(json);
}

/// @nodoc
mixin _$RecipeIngredient {
  /// Name of the ingredient (e.g. "Jajko", "Mąka").
  String get name => throw _privateConstructorUsedError;

  /// Amount required by the recipe.
  double get requiredAmount => throw _privateConstructorUsedError;

  /// Unit string (e.g. "szt", "g", "ml").
  String get unit => throw _privateConstructorUsedError;

  /// True if this ingredient is currently in the user's Isar inventory.
  bool get isMatchedInInventory => throw _privateConstructorUsedError;

  /// Amount available in inventory (null if not matched).
  double? get availableAmount => throw _privateConstructorUsedError;

  /// Serializes this RecipeIngredient to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RecipeIngredient
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RecipeIngredientCopyWith<RecipeIngredient> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RecipeIngredientCopyWith<$Res> {
  factory $RecipeIngredientCopyWith(
          RecipeIngredient value, $Res Function(RecipeIngredient) then) =
      _$RecipeIngredientCopyWithImpl<$Res, RecipeIngredient>;
  @useResult
  $Res call(
      {String name,
      double requiredAmount,
      String unit,
      bool isMatchedInInventory,
      double? availableAmount});
}

/// @nodoc
class _$RecipeIngredientCopyWithImpl<$Res, $Val extends RecipeIngredient>
    implements $RecipeIngredientCopyWith<$Res> {
  _$RecipeIngredientCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RecipeIngredient
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? requiredAmount = null,
    Object? unit = null,
    Object? isMatchedInInventory = null,
    Object? availableAmount = freezed,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      requiredAmount: null == requiredAmount
          ? _value.requiredAmount
          : requiredAmount // ignore: cast_nullable_to_non_nullable
              as double,
      unit: null == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as String,
      isMatchedInInventory: null == isMatchedInInventory
          ? _value.isMatchedInInventory
          : isMatchedInInventory // ignore: cast_nullable_to_non_nullable
              as bool,
      availableAmount: freezed == availableAmount
          ? _value.availableAmount
          : availableAmount // ignore: cast_nullable_to_non_nullable
              as double?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RecipeIngredientImplCopyWith<$Res>
    implements $RecipeIngredientCopyWith<$Res> {
  factory _$$RecipeIngredientImplCopyWith(_$RecipeIngredientImpl value,
          $Res Function(_$RecipeIngredientImpl) then) =
      __$$RecipeIngredientImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String name,
      double requiredAmount,
      String unit,
      bool isMatchedInInventory,
      double? availableAmount});
}

/// @nodoc
class __$$RecipeIngredientImplCopyWithImpl<$Res>
    extends _$RecipeIngredientCopyWithImpl<$Res, _$RecipeIngredientImpl>
    implements _$$RecipeIngredientImplCopyWith<$Res> {
  __$$RecipeIngredientImplCopyWithImpl(_$RecipeIngredientImpl _value,
      $Res Function(_$RecipeIngredientImpl) _then)
      : super(_value, _then);

  /// Create a copy of RecipeIngredient
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? requiredAmount = null,
    Object? unit = null,
    Object? isMatchedInInventory = null,
    Object? availableAmount = freezed,
  }) {
    return _then(_$RecipeIngredientImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      requiredAmount: null == requiredAmount
          ? _value.requiredAmount
          : requiredAmount // ignore: cast_nullable_to_non_nullable
              as double,
      unit: null == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as String,
      isMatchedInInventory: null == isMatchedInInventory
          ? _value.isMatchedInInventory
          : isMatchedInInventory // ignore: cast_nullable_to_non_nullable
              as bool,
      availableAmount: freezed == availableAmount
          ? _value.availableAmount
          : availableAmount // ignore: cast_nullable_to_non_nullable
              as double?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RecipeIngredientImpl implements _RecipeIngredient {
  const _$RecipeIngredientImpl(
      {required this.name,
      required this.requiredAmount,
      required this.unit,
      this.isMatchedInInventory = false,
      this.availableAmount});

  factory _$RecipeIngredientImpl.fromJson(Map<String, dynamic> json) =>
      _$$RecipeIngredientImplFromJson(json);

  /// Name of the ingredient (e.g. "Jajko", "Mąka").
  @override
  final String name;

  /// Amount required by the recipe.
  @override
  final double requiredAmount;

  /// Unit string (e.g. "szt", "g", "ml").
  @override
  final String unit;

  /// True if this ingredient is currently in the user's Isar inventory.
  @override
  @JsonKey()
  final bool isMatchedInInventory;

  /// Amount available in inventory (null if not matched).
  @override
  final double? availableAmount;

  @override
  String toString() {
    return 'RecipeIngredient(name: $name, requiredAmount: $requiredAmount, unit: $unit, isMatchedInInventory: $isMatchedInInventory, availableAmount: $availableAmount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RecipeIngredientImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.requiredAmount, requiredAmount) ||
                other.requiredAmount == requiredAmount) &&
            (identical(other.unit, unit) || other.unit == unit) &&
            (identical(other.isMatchedInInventory, isMatchedInInventory) ||
                other.isMatchedInInventory == isMatchedInInventory) &&
            (identical(other.availableAmount, availableAmount) ||
                other.availableAmount == availableAmount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name, requiredAmount, unit,
      isMatchedInInventory, availableAmount);

  /// Create a copy of RecipeIngredient
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RecipeIngredientImplCopyWith<_$RecipeIngredientImpl> get copyWith =>
      __$$RecipeIngredientImplCopyWithImpl<_$RecipeIngredientImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RecipeIngredientImplToJson(
      this,
    );
  }
}

abstract class _RecipeIngredient implements RecipeIngredient {
  const factory _RecipeIngredient(
      {required final String name,
      required final double requiredAmount,
      required final String unit,
      final bool isMatchedInInventory,
      final double? availableAmount}) = _$RecipeIngredientImpl;

  factory _RecipeIngredient.fromJson(Map<String, dynamic> json) =
      _$RecipeIngredientImpl.fromJson;

  /// Name of the ingredient (e.g. "Jajko", "Mąka").
  @override
  String get name;

  /// Amount required by the recipe.
  @override
  double get requiredAmount;

  /// Unit string (e.g. "szt", "g", "ml").
  @override
  String get unit;

  /// True if this ingredient is currently in the user's Isar inventory.
  @override
  bool get isMatchedInInventory;

  /// Amount available in inventory (null if not matched).
  @override
  double? get availableAmount;

  /// Create a copy of RecipeIngredient
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RecipeIngredientImplCopyWith<_$RecipeIngredientImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Recipe _$RecipeFromJson(Map<String, dynamic> json) {
  return _Recipe.fromJson(json);
}

/// @nodoc
mixin _$Recipe {
  /// Stable identifier (UUID or LLM-generated slug).
  String get id => throw _privateConstructorUsedError;

  /// Display title of the recipe.
  String get title => throw _privateConstructorUsedError;

  /// Estimated preparation time in minutes.
  int get preparationTime => throw _privateConstructorUsedError;

  /// URL of the recipe image (placeholder or AI-generated).
  String get imageUrl => throw _privateConstructorUsedError;

  /// List of required ingredients with inventory match status.
  List<RecipeIngredient> get ingredients => throw _privateConstructorUsedError;

  /// Step-by-step cooking instructions.
  List<String> get instructions => throw _privateConstructorUsedError;

  /// Meal tags (e.g. ["Kolacja", "Wegetariańskie", "Szybkie"]).
  List<String> get tags => throw _privateConstructorUsedError;

  /// Whether the user has saved this recipe as a favourite.
  bool get isFavorite => throw _privateConstructorUsedError;

  /// Difficulty level: "Łatwe", "Średnie", "Trudne".
  String get difficulty => throw _privateConstructorUsedError;

  /// Serializes this Recipe to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Recipe
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RecipeCopyWith<Recipe> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RecipeCopyWith<$Res> {
  factory $RecipeCopyWith(Recipe value, $Res Function(Recipe) then) =
      _$RecipeCopyWithImpl<$Res, Recipe>;
  @useResult
  $Res call(
      {String id,
      String title,
      int preparationTime,
      String imageUrl,
      List<RecipeIngredient> ingredients,
      List<String> instructions,
      List<String> tags,
      bool isFavorite,
      String difficulty});
}

/// @nodoc
class _$RecipeCopyWithImpl<$Res, $Val extends Recipe>
    implements $RecipeCopyWith<$Res> {
  _$RecipeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Recipe
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? preparationTime = null,
    Object? imageUrl = null,
    Object? ingredients = null,
    Object? instructions = null,
    Object? tags = null,
    Object? isFavorite = null,
    Object? difficulty = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      preparationTime: null == preparationTime
          ? _value.preparationTime
          : preparationTime // ignore: cast_nullable_to_non_nullable
              as int,
      imageUrl: null == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String,
      ingredients: null == ingredients
          ? _value.ingredients
          : ingredients // ignore: cast_nullable_to_non_nullable
              as List<RecipeIngredient>,
      instructions: null == instructions
          ? _value.instructions
          : instructions // ignore: cast_nullable_to_non_nullable
              as List<String>,
      tags: null == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isFavorite: null == isFavorite
          ? _value.isFavorite
          : isFavorite // ignore: cast_nullable_to_non_nullable
              as bool,
      difficulty: null == difficulty
          ? _value.difficulty
          : difficulty // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RecipeImplCopyWith<$Res> implements $RecipeCopyWith<$Res> {
  factory _$$RecipeImplCopyWith(
          _$RecipeImpl value, $Res Function(_$RecipeImpl) then) =
      __$$RecipeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String title,
      int preparationTime,
      String imageUrl,
      List<RecipeIngredient> ingredients,
      List<String> instructions,
      List<String> tags,
      bool isFavorite,
      String difficulty});
}

/// @nodoc
class __$$RecipeImplCopyWithImpl<$Res>
    extends _$RecipeCopyWithImpl<$Res, _$RecipeImpl>
    implements _$$RecipeImplCopyWith<$Res> {
  __$$RecipeImplCopyWithImpl(
      _$RecipeImpl _value, $Res Function(_$RecipeImpl) _then)
      : super(_value, _then);

  /// Create a copy of Recipe
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? preparationTime = null,
    Object? imageUrl = null,
    Object? ingredients = null,
    Object? instructions = null,
    Object? tags = null,
    Object? isFavorite = null,
    Object? difficulty = null,
  }) {
    return _then(_$RecipeImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      preparationTime: null == preparationTime
          ? _value.preparationTime
          : preparationTime // ignore: cast_nullable_to_non_nullable
              as int,
      imageUrl: null == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String,
      ingredients: null == ingredients
          ? _value._ingredients
          : ingredients // ignore: cast_nullable_to_non_nullable
              as List<RecipeIngredient>,
      instructions: null == instructions
          ? _value._instructions
          : instructions // ignore: cast_nullable_to_non_nullable
              as List<String>,
      tags: null == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isFavorite: null == isFavorite
          ? _value.isFavorite
          : isFavorite // ignore: cast_nullable_to_non_nullable
              as bool,
      difficulty: null == difficulty
          ? _value.difficulty
          : difficulty // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RecipeImpl implements _Recipe {
  const _$RecipeImpl(
      {required this.id,
      required this.title,
      required this.preparationTime,
      this.imageUrl = '',
      final List<RecipeIngredient> ingredients = const [],
      final List<String> instructions = const [],
      final List<String> tags = const [],
      this.isFavorite = false,
      this.difficulty = 'Łatwe'})
      : _ingredients = ingredients,
        _instructions = instructions,
        _tags = tags;

  factory _$RecipeImpl.fromJson(Map<String, dynamic> json) =>
      _$$RecipeImplFromJson(json);

  /// Stable identifier (UUID or LLM-generated slug).
  @override
  final String id;

  /// Display title of the recipe.
  @override
  final String title;

  /// Estimated preparation time in minutes.
  @override
  final int preparationTime;

  /// URL of the recipe image (placeholder or AI-generated).
  @override
  @JsonKey()
  final String imageUrl;

  /// List of required ingredients with inventory match status.
  final List<RecipeIngredient> _ingredients;

  /// List of required ingredients with inventory match status.
  @override
  @JsonKey()
  List<RecipeIngredient> get ingredients {
    if (_ingredients is EqualUnmodifiableListView) return _ingredients;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_ingredients);
  }

  /// Step-by-step cooking instructions.
  final List<String> _instructions;

  /// Step-by-step cooking instructions.
  @override
  @JsonKey()
  List<String> get instructions {
    if (_instructions is EqualUnmodifiableListView) return _instructions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_instructions);
  }

  /// Meal tags (e.g. ["Kolacja", "Wegetariańskie", "Szybkie"]).
  final List<String> _tags;

  /// Meal tags (e.g. ["Kolacja", "Wegetariańskie", "Szybkie"]).
  @override
  @JsonKey()
  List<String> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  /// Whether the user has saved this recipe as a favourite.
  @override
  @JsonKey()
  final bool isFavorite;

  /// Difficulty level: "Łatwe", "Średnie", "Trudne".
  @override
  @JsonKey()
  final String difficulty;

  @override
  String toString() {
    return 'Recipe(id: $id, title: $title, preparationTime: $preparationTime, imageUrl: $imageUrl, ingredients: $ingredients, instructions: $instructions, tags: $tags, isFavorite: $isFavorite, difficulty: $difficulty)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RecipeImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.preparationTime, preparationTime) ||
                other.preparationTime == preparationTime) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            const DeepCollectionEquality()
                .equals(other._ingredients, _ingredients) &&
            const DeepCollectionEquality()
                .equals(other._instructions, _instructions) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            (identical(other.isFavorite, isFavorite) ||
                other.isFavorite == isFavorite) &&
            (identical(other.difficulty, difficulty) ||
                other.difficulty == difficulty));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      title,
      preparationTime,
      imageUrl,
      const DeepCollectionEquality().hash(_ingredients),
      const DeepCollectionEquality().hash(_instructions),
      const DeepCollectionEquality().hash(_tags),
      isFavorite,
      difficulty);

  /// Create a copy of Recipe
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RecipeImplCopyWith<_$RecipeImpl> get copyWith =>
      __$$RecipeImplCopyWithImpl<_$RecipeImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RecipeImplToJson(
      this,
    );
  }
}

abstract class _Recipe implements Recipe {
  const factory _Recipe(
      {required final String id,
      required final String title,
      required final int preparationTime,
      final String imageUrl,
      final List<RecipeIngredient> ingredients,
      final List<String> instructions,
      final List<String> tags,
      final bool isFavorite,
      final String difficulty}) = _$RecipeImpl;

  factory _Recipe.fromJson(Map<String, dynamic> json) = _$RecipeImpl.fromJson;

  /// Stable identifier (UUID or LLM-generated slug).
  @override
  String get id;

  /// Display title of the recipe.
  @override
  String get title;

  /// Estimated preparation time in minutes.
  @override
  int get preparationTime;

  /// URL of the recipe image (placeholder or AI-generated).
  @override
  String get imageUrl;

  /// List of required ingredients with inventory match status.
  @override
  List<RecipeIngredient> get ingredients;

  /// Step-by-step cooking instructions.
  @override
  List<String> get instructions;

  /// Meal tags (e.g. ["Kolacja", "Wegetariańskie", "Szybkie"]).
  @override
  List<String> get tags;

  /// Whether the user has saved this recipe as a favourite.
  @override
  bool get isFavorite;

  /// Difficulty level: "Łatwe", "Średnie", "Trudne".
  @override
  String get difficulty;

  /// Create a copy of Recipe
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RecipeImplCopyWith<_$RecipeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

RecipeGenerationResponse _$RecipeGenerationResponseFromJson(
    Map<String, dynamic> json) {
  return _RecipeGenerationResponse.fromJson(json);
}

/// @nodoc
mixin _$RecipeGenerationResponse {
  List<Recipe> get recipes => throw _privateConstructorUsedError;

  /// Serializes this RecipeGenerationResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RecipeGenerationResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RecipeGenerationResponseCopyWith<RecipeGenerationResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RecipeGenerationResponseCopyWith<$Res> {
  factory $RecipeGenerationResponseCopyWith(RecipeGenerationResponse value,
          $Res Function(RecipeGenerationResponse) then) =
      _$RecipeGenerationResponseCopyWithImpl<$Res, RecipeGenerationResponse>;
  @useResult
  $Res call({List<Recipe> recipes});
}

/// @nodoc
class _$RecipeGenerationResponseCopyWithImpl<$Res,
        $Val extends RecipeGenerationResponse>
    implements $RecipeGenerationResponseCopyWith<$Res> {
  _$RecipeGenerationResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RecipeGenerationResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? recipes = null,
  }) {
    return _then(_value.copyWith(
      recipes: null == recipes
          ? _value.recipes
          : recipes // ignore: cast_nullable_to_non_nullable
              as List<Recipe>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RecipeGenerationResponseImplCopyWith<$Res>
    implements $RecipeGenerationResponseCopyWith<$Res> {
  factory _$$RecipeGenerationResponseImplCopyWith(
          _$RecipeGenerationResponseImpl value,
          $Res Function(_$RecipeGenerationResponseImpl) then) =
      __$$RecipeGenerationResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<Recipe> recipes});
}

/// @nodoc
class __$$RecipeGenerationResponseImplCopyWithImpl<$Res>
    extends _$RecipeGenerationResponseCopyWithImpl<$Res,
        _$RecipeGenerationResponseImpl>
    implements _$$RecipeGenerationResponseImplCopyWith<$Res> {
  __$$RecipeGenerationResponseImplCopyWithImpl(
      _$RecipeGenerationResponseImpl _value,
      $Res Function(_$RecipeGenerationResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of RecipeGenerationResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? recipes = null,
  }) {
    return _then(_$RecipeGenerationResponseImpl(
      recipes: null == recipes
          ? _value._recipes
          : recipes // ignore: cast_nullable_to_non_nullable
              as List<Recipe>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RecipeGenerationResponseImpl implements _RecipeGenerationResponse {
  const _$RecipeGenerationResponseImpl({final List<Recipe> recipes = const []})
      : _recipes = recipes;

  factory _$RecipeGenerationResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$RecipeGenerationResponseImplFromJson(json);

  final List<Recipe> _recipes;
  @override
  @JsonKey()
  List<Recipe> get recipes {
    if (_recipes is EqualUnmodifiableListView) return _recipes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_recipes);
  }

  @override
  String toString() {
    return 'RecipeGenerationResponse(recipes: $recipes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RecipeGenerationResponseImpl &&
            const DeepCollectionEquality().equals(other._recipes, _recipes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_recipes));

  /// Create a copy of RecipeGenerationResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RecipeGenerationResponseImplCopyWith<_$RecipeGenerationResponseImpl>
      get copyWith => __$$RecipeGenerationResponseImplCopyWithImpl<
          _$RecipeGenerationResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RecipeGenerationResponseImplToJson(
      this,
    );
  }
}

abstract class _RecipeGenerationResponse implements RecipeGenerationResponse {
  const factory _RecipeGenerationResponse({final List<Recipe> recipes}) =
      _$RecipeGenerationResponseImpl;

  factory _RecipeGenerationResponse.fromJson(Map<String, dynamic> json) =
      _$RecipeGenerationResponseImpl.fromJson;

  @override
  List<Recipe> get recipes;

  /// Create a copy of RecipeGenerationResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RecipeGenerationResponseImplCopyWith<_$RecipeGenerationResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}
