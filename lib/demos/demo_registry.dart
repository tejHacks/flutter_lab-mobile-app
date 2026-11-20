import 'package:flutter/material.dart';

import 'advanced_demos.dart';
import 'fundamentals_demos.dart';
import 'layout_demos.dart';
import 'list_nav_demos.dart';
import 'theme_state_demos.dart';
import 'widget_demos.dart';

/// Every live demo, by key. Lessons and the Widget Catalog refer to these keys.
final Map<String, WidgetBuilder> demos = {
  // Fundamentals
  'hot_reload': (_) => const HotReloadDemo(),
  'widget_tree': (_) => const WidgetTreeDemo(),
  'scaffold': (_) => const ScaffoldDemo(),
  'stateless': (_) => const StatelessDemo(),
  'counter': (_) => const CounterDemo(),
  'setstate_bug': (_) => const SetStateBugDemo(),
  'lifecycle': (_) => const LifecycleDemo(),
  'context': (_) => const ContextDemo(),
  'keys': (_) => const KeysDemo(),
  // Layout
  'constraints': (_) => const ConstraintsDemo(),
  'container': (_) => const ContainerDemo(),
  'rowcol': (_) => const RowColDemo(),
  'expanded': (_) => const ExpandedDemo(),
  'stack': (_) => const StackDemo(),
  'align': (_) => const AlignDemo(),
  'wrap': (_) => const WrapDemo(),
  'overflow': (_) => const OverflowDemo(),
  // Common widgets
  'text_style': (_) => const TextStyleDemo(),
  'icons': (_) => const IconsDemo(),
  'boxfit': (_) => const BoxFitDemo(),
  'buttons': (_) => const ButtonsDemo(),
  'cards': (_) => const CardsDemo(),
  'chips': (_) => const ChipsDemo(),
  'progress': (_) => const ProgressDemo(),
  // Input
  'textfield': (_) => const TextFieldDemo(),
  'form': (_) => const FormDemo(),
  'toggles': (_) => const TogglesDemo(),
  'selection': (_) => const SelectionDemo(),
  'gestures': (_) => const GesturesDemo(),
  'dismissible': (_) => const DismissibleDemo(),
  'pickers': (_) => const PickersDemo(),
  // Lists
  'listview_builder': (_) => const ListViewBuilderDemo(),
  'gridview': (_) => const GridViewDemo(),
  'slivers': (_) => const SliversDemo(),
  'pageview': (_) => const PageViewDemo(),
  'refresh': (_) => const RefreshDemo(),
  // Navigation
  'nav_push': (_) => const NavPushDemo(),
  'nav_result': (_) => const NavResultDemo(),
  'drawer': (_) => const DrawerDemo(),
  'navbar': (_) => const NavBarDemo(),
  'tabs': (_) => const TabsDemo(),
  'dialogs': (_) => const DialogsDemo(),
  // Theming
  'theme_seed': (_) => const ThemeSeedDemo(),
  'dark_mode': (_) => const DarkModeDemo(),
  'decoration': (_) => const DecorationDemo(),
  'responsive': (_) => const ResponsiveDemo(),
  // State
  'lifting': (_) => const LiftingDemo(),
  'value_notifier': (_) => const ValueNotifierDemo(),
  'cart': (_) => const CartDemo(),
  // Data
  'future_builder': (_) => const FutureBuilderDemo(),
  'stream_builder': (_) => const StreamBuilderDemo(),
  // Animations
  'implicit': (_) => const ImplicitDemo(),
  'curves': (_) => const CurvesDemo(),
  'explicit': (_) => const ExplicitDemo(),
  'hero': (_) => const HeroDemo(),
  'switcher': (_) => const SwitcherDemo(),
  'animated_list': (_) => const AnimatedListDemo(),
  // Advanced
  'custom_paint': (_) => const CustomPaintDemo(),
  'todo_app': (_) => const TodoAppDemo(),
};
