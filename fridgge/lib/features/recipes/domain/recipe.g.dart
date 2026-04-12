// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RecipeIngredientImpl _$$RecipeIngredientImplFromJson(
        Map<String, dynamic> json) =>
    _$RecipeIngredientImpl(
      name: json['name'] as String,
      requiredAmount: (json['requiredAmount'] as num).toDouble(),
      unit: json['unit'] as String,
      isMatchedInInventory: json['isMatchedInInventory'] as bool? ?? false,
      availableAmount: (json['availableAmount'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$$RecipeIngredientImplToJson(
        _$RecipeIngredientImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'requiredAmount': instance.requiredAmount,
      'unit': instance.unit,
      'isMatchedInInventory': instance.isMatchedInInventory,
      'availableAmount': instance.availableAmount,
    };

_$RecipeImpl _$$RecipeImplFromJson(Map<String, dynamic> json) => _$RecipeImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      preparationTime: (json['preparationTime'] as num).toInt(),
      imageUrl: json['imageUrl'] as String? ?? '',
      ingredients: (json['ingredients'] as List<dynamic>?)
              ?.map((e) => RecipeIngredient.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      instructions: (json['instructions'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
      isFavorite: json['isFavorite'] as bool? ?? false,
      difficulty: json['difficulty'] as String? ?? 'Łatwe',
    );

Map<String, dynamic> _$$RecipeImplToJson(_$RecipeImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'preparationTime': instance.preparationTime,
      'imageUrl': instance.imageUrl,
      'ingredients': instance.ingredients,
      'instructions': instance.instructions,
      'tags': instance.tags,
      'isFavorite': instance.isFavorite,
      'difficulty': instance.difficulty,
    };

_$RecipeGenerationResponseImpl _$$RecipeGenerationResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$RecipeGenerationResponseImpl(
      recipes: (json['recipes'] as List<dynamic>?)
              ?.map((e) => Recipe.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$RecipeGenerationResponseImplToJson(
        _$RecipeGenerationResponseImpl instance) =>
    <String, dynamic>{
      'recipes': instance.recipes,
    };
