/*
 * Copyright (C) 2020-2023 HERE Europe B.V.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 * SPDX-License-Identifier: Apache-2.0
 * License-Filename: LICENSE
 */

import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:here_sdk/routing.dart';
import 'package:provider/provider.dart';

import '../../common/ui_style.dart';
import '../enum_string_helper.dart';
import '../route_preferences_model.dart';

/// Road features avoidance options screen widget.
class RoadFeaturesAvoidanceScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AvoidanceOptions avoidanceOptions =
        context.select((RoutePreferencesModel model) => model.sharedAvoidanceOptions);

    LinkedHashMap<String, RoadFeatures> roadFeaturesMap = EnumStringHelper.sortedRoadFeaturesMap(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.avoidRoadFeaturesTitle),
      ),
      body: Container(
        color: UIStyle.preferencesBackgroundColor,
        child: ListView(
          children: roadFeaturesMap.keys.map((String key) {
            return CheckboxListTile(
              title: Text(key),
              value: avoidanceOptions.roadFeatures.contains(roadFeaturesMap[key]),
              onChanged: (bool? enable) {
                RoadFeatures? changedFeature = roadFeaturesMap[key];
                if (changedFeature == null) {
                  return;
                }
                List<RoadFeatures> updatedFeatures = List.from(avoidanceOptions.roadFeatures);
                if (enable ?? false) {
                  updatedFeatures.add(changedFeature);
                } else {
                  updatedFeatures.remove(changedFeature);
                }
                final AvoidanceOptions newOptions = AvoidanceOptions()
                  ..roadFeatures = updatedFeatures
                  ..countries = avoidanceOptions.countries
                  ..avoidAreas = avoidanceOptions.avoidAreas
                  ..zoneCategories = avoidanceOptions.zoneCategories
                  ..segments = avoidanceOptions.segments;
                context.read<RoutePreferencesModel>().sharedAvoidanceOptions = newOptions;
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}
