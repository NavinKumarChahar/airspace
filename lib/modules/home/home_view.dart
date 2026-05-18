import 'package:air_app/modules/home/home_best_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../entities/entities_view.dart';
import '../identity/identity_view.dart';
import '../unions/unions_view.dart';
import 'drawer_navigation_copy.dart';
import 'home_controller.dart';

class HomeView extends StatelessWidget {
  HomeView({super.key});

  HomeController controller = Get.find<HomeController>();

  final List<Widget> pages = [
    EntitiesView(),
    UnionsView(),
    IdentityView(),
    HomeBestView(),
  ];

  /// =========================================================
  /// FILTERED RESULTS
  /// =========================================================

  /// ─── BUTTER-SMOOTH SCROLL ────────────────────────────────────────────────
  ///
  /// Strategy (3 phases):
  ///
  ///  Phase 1 — Jump near: animate the main ScrollController to the
  ///            pre-measured section offset so the target item is built
  ///            in the viewport (or very close to it).
  ///
  ///  Phase 2 — Wait for build: the ListView.builder only renders items
  ///            that are near the viewport. After Phase 1 the target tile
  ///            may not be laid out yet. We retry up to 15× (150 ms each)
  ///            until its GlobalKey has a valid RenderObject.
  ///
  ///  Phase 3 — Fine-tune: once the context is live, use
  ///            Scrollable.ensureVisible which handles the last few pixels
  ///            precisely without any hard-coded offsets.
  ///
  /// Total worst-case time ≈ 600 ms coarse + 150 ms × retries + 600 ms fine
  /// = well under 2 s, smooth on any device.
  /// ─────────────────────────────────────────────────────────────────────────
  Future<void> scrollToItem({
    required String sectionTitle,
    required String routeTemp,
    required GlobalKey key,   // key of the result-list tile (unused now)
  }) async {
    // ── 0. Close search overlay immediately ──────────────────
    controller.isDrawerSearchVisible.value = false;

    // ── 1. Resolve the ACTUAL drawer item key ────────────────
    GlobalKey? itemKey;
    try {
      itemKey = controller.drawerSections
          .firstWhere((s) => s.title == sectionTitle)
          .items
          .firstWhere((i) => i.route == routeTemp)
          .key;
    } catch (_) {
      debugPrint('[scroll] item not found → $routeTemp');
      return;
    }

    if (itemKey == null) {
      debugPrint('[scroll] key is null → $routeTemp');
      return;
    }

    // ── 2. Phase 1 — coarse scroll to section ────────────────
    //      Use the live measured offset when available,
    //      otherwise fall back to 0 (top of list).
    final sectionOffset = controller.itemOffsets[sectionTitle] ?? 0.0;
    final sc = controller.scrollController;

    // Clamp to max scroll extent so we never overshoot on short lists.
    final safeOffset = sectionOffset.clamp(
      0.0,
      sc.hasClients ? sc.position.maxScrollExtent : sectionOffset,
    );

    await sc.animateTo(
      safeOffset,
      duration: const Duration(milliseconds: 520),
      curve: Curves.easeInOut,
    );

    // ── 3. Phase 2 — wait until target tile is built ─────────
    //      ListView.builder only renders visible items; after the coarse
    //      scroll the item may not exist yet in the widget tree.
    const maxRetries = 15;
    for (int i = 0; i < maxRetries; i++) {
      if (itemKey.currentContext != null) break;
      await Future.delayed(const Duration(milliseconds: 80));
    }

    final ctx = itemKey.currentContext;
    if (ctx == null) {
      debugPrint('[scroll] context still null after retries → $routeTemp');
      return;
    }

    // ── 4. Phase 3 — fine-tune with ensureVisible ─────────────
    //      alignment: 0.15 puts the item 15 % from the top — clearly
    //      visible but not jammed against the app bar.
    await Scrollable.ensureVisible(
      ctx,
      duration: const Duration(milliseconds: 540),
      curve: Curves.easeInOutCubic,
      alignment: 0.15,
    );
  }

  /// Called by PositionTracker — kept for back-compat but logic
  /// is now inlined in scrollToItem above.
  Future<void> scrollToSectionNewItem(String sectionTitle) async {
    final offset = controller.itemOffsets[sectionTitle];
    if (offset == null) {
      debugPrint('[scroll] offset not found for $sectionTitle');
      return;
    }
    final sc = controller.scrollController;
    await sc.animateTo(
      offset.clamp(0.0, sc.hasClients ? sc.position.maxScrollExtent : offset),
      duration: const Duration(milliseconds: 520),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final isDark = theme.brightness == Brightness.dark;

    final onSurface = theme.colorScheme.onSurface;

    return Obx(
      () => DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('All-Space', style: TextStyle(letterSpacing: 3)),

            bottom: const TabBar(
              tabAlignment: TabAlignment.start,
              isScrollable: true,
              tabs: [
                Tab(icon: Icon(Icons.category), text: 'ENTITIES'),
                Tab(icon: Icon(Icons.account_tree), text: 'UNIONS'),
                Tab(icon: Icon(Icons.fingerprint), text: 'IDENTITY'),
                Tab(icon: Icon(Icons.home), text: 'Home UI & UX'),
              ],
            ),
          ),

          /// =========================================================
          /// DRAWER
          /// =========================================================
          drawer: Container(
            width: 330,
            decoration: BoxDecoration(color: theme.colorScheme.surface),

            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      /// =========================================================
                      /// MAIN LIST
                      /// =========================================================
                      ListView.builder(
                        controller: controller.scrollController,
                        // itemScrollController: controller.drawerSections.isNotEmpty
                        //     ? controller.itemScrollSectionController
                        //     : ItemScrollController(),
                        // physics: const NeverScrollableScrollPhysics(),
                        // shrinkWrap: true,
                        itemCount: controller.drawerSections.length + 1,

                        itemBuilder: (context, index) {
                          DrawerActualSection? itemSectionActual;
                          if (index == (controller.drawerSections.length)) {
                          } else {
                            itemSectionActual =
                                controller.drawerSections[index];
                          }

                          return Column(
                            children: [
                              /// HEADER
                              if (index == 0) ...{
                                UserAccountsDrawerHeader(
                                  decoration: const BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage(
                                        'assets/images/AIR_Picture.png',
                                      ),

                                      fit: BoxFit.fill,

                                      colorFilter: ColorFilter.mode(
                                        Colors.black54,
                                        BlendMode.darken,
                                      ),
                                    ),
                                  ),

                                  accountName: const Text('Alifiyas-Mazeasta'),

                                  accountEmail: const Text(
                                    'AsathesCumIRoofantal',
                                  ),
                                ),
                              },

                              /// =========================================================
                              /// ORIGINAL DRAWER DESIGN
                              /// =========================================================
                              if (itemSectionActual == null) ...{
                                SizedBox(height: 10),
                              } else ...{
                                PositionTracker(
                                  title: itemSectionActual.title,
                                  itemOffsets: controller.itemOffsets,
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                      vertical: 0,
                                    ),

                                    padding: const EdgeInsets.symmetric(
                                      vertical: 0,
                                    ),

                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topLeft,

                                        end: Alignment.bottomRight,

                                        colors: isDark
                                            ? [
                                                theme.scaffoldBackgroundColor,

                                                theme.colorScheme.surface,
                                              ]
                                            : [
                                                theme.colorScheme.surface,

                                                theme.scaffoldBackgroundColor,
                                              ],
                                      ),
                                    ),

                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,

                                      children: [
                                        /// SECTION TITLE
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                            8,
                                            4,
                                            8,
                                            6,
                                          ),

                                          child: Row(
                                            children: [
                                              Container(
                                                width: 5,
                                                height: 32,

                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                        100,
                                                      ),

                                                  gradient:
                                                      const LinearGradient(
                                                        colors: [
                                                          Color(0xFFFFE8A3),

                                                          Color(0xFFD4AF37),

                                                          Color(0xFF8C6A16),
                                                        ],
                                                      ),
                                                ),
                                              ),

                                              const SizedBox(width: 12),

                                              Expanded(
                                                child: Text(
                                                  itemSectionActual.title
                                                      .toUpperCase(),

                                                  style: const TextStyle(
                                                    color: Color(0xFFFFD369),

                                                    fontSize: 13,

                                                    fontWeight: FontWeight.w700,

                                                    letterSpacing: 2.2,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),

                                        /// SECTION DESCRIPTION
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                            18,
                                            0,
                                            18,
                                            0,
                                          ),

                                          child: Text(
                                            DrawerNavigationCopy.sectionBlurb(
                                              itemSectionActual.title,
                                            ),

                                            style: TextStyle(
                                              fontSize: 11.2,

                                              height: 1.45,

                                              color: onSurface,
                                            ),
                                          ),
                                        ),

                                        /// ITEMS
                                        Column(
                                          children: List.generate(
                                            itemSectionActual.items.length,
                                            (indexTabActual) {
                                              final itemTabsActual =
                                                  itemSectionActual!
                                                      .items[indexTabActual];

                                              return Container(
                                                key: itemTabsActual.key,
                                                child: buildDrawerActualItem(
                                                  context: context,
                                                  item: itemTabsActual,
                                                  onSurface: onSurface,
                                                ),
                                              );
                                            },
                                          ),
                                        ),

                                        // const SizedBox(height: 10),
                                      ],
                                    ),
                                  ),
                                ),
                              },
                            ],
                          );
                        },
                      ),

                      /// =========================================================
                      /// FLOATING SEARCH BUTTON
                      /// =========================================================
                      Positioned(
                        bottom: 20,
                        right: 18,

                        child: Material(
                          color: Colors.transparent,

                          elevation: 12,

                          borderRadius: BorderRadius.circular(100),

                          child: InkWell(
                            borderRadius: BorderRadius.circular(100),

                            onTap: () {
                              controller.isDrawerSearchVisible.value = true;
                            },

                            child: Ink(
                              width: 62,
                              height: 62,

                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,

                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xFF00C6FF),
                                    Color(0xFF0072FF),
                                  ],
                                ),
                              ),

                              child: const Icon(
                                Icons.search_rounded,
                                color: Colors.white,
                                size: 28,
                              ),
                            ),
                          ),
                        ),
                      ),

                      /// =========================================================
                      /// SEARCH OVERLAY
                      /// =========================================================
                      controller.isDrawerSearchVisible.value
                          ? Positioned.fill(
                              // top: 0,
                              child: GestureDetector(
                                behavior: HitTestBehavior.opaque,

                                onTap: () {
                                  controller.drawerSearchController.clear();

                                  controller.drawerSearchText.value = '';

                                  controller.isDrawerSearchVisible.value =
                                      false;
                                },

                                child: Container(
                                  color: Colors.black.withValues(alpha: 0.72),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      /// SEARCH BAR
                                      GestureDetector(
                                        onTap: () {},

                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 20,
                                          ),

                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 16,
                                            ),

                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(22),

                                              gradient: const LinearGradient(
                                                colors: [
                                                  Color(0xFF182848),

                                                  Color(0xFF4B6CB7),
                                                ],
                                              ),
                                            ),

                                            child: Row(
                                              children: [
                                                const Icon(
                                                  Icons.search,
                                                  color: Colors.white,
                                                ),

                                                const SizedBox(width: 10),

                                                Expanded(
                                                  child: TextField(
                                                    autofocus: true,

                                                    controller: controller
                                                        .drawerSearchController,

                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                    ),

                                                    onChanged: (value) {
                                                      controller
                                                              .drawerSearchText
                                                              .value =
                                                          value;
                                                    },

                                                    decoration:
                                                        const InputDecoration(
                                                          border:
                                                              InputBorder.none,

                                                          hintText:
                                                              'Search anything...',

                                                          hintStyle: TextStyle(
                                                            color:
                                                                Colors.white70,
                                                          ),
                                                        ),
                                                  ),
                                                ),

                                                GestureDetector(
                                                  onTap: () {
                                                    controller
                                                        .drawerSearchController
                                                        .clear();

                                                    controller
                                                            .drawerSearchText
                                                            .value =
                                                        '';

                                                    controller
                                                            .isDrawerSearchVisible
                                                            .value =
                                                        false;
                                                  },

                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.all(7),

                                                    decoration: BoxDecoration(
                                                      color: Colors.white
                                                          .withValues(
                                                            alpha: 0.12,
                                                          ),

                                                      shape: BoxShape.circle,
                                                    ),

                                                    child: const Icon(
                                                      Icons.close_rounded,
                                                      color: Colors.white,
                                                      size: 18,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),

                                      /// RESULTS
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () {},

                                          child: getFilterResultsUIComponent(),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          : const SizedBox(),
                    ],
                  ),
                ),
              ],
            ),
          ),

          body: TabBarView(children: pages),
        ),
      ),
    );
  }

  Widget getFilterResultsUIComponent() {
    controller.getFilteredResults();

    if (controller.results.value.isEmpty) {
      return const Center(
        child: Text(
          "No Results Found",

          style: TextStyle(color: Colors.white, fontSize: 15),
        ),
      );
    }

    // final grouped = <String, List<DrawerSearchResult>>{};

    // for (var r in controller.results.value) {
    //   grouped.putIfAbsent(r.section, () => []);

    //   grouped[r.section]!.add(r);
    // }

    return ListView(
      padding: const EdgeInsets.fromLTRB(14, 0, 14, 120),

      children: controller.results.value.map((listItem) {
        return Container(
          margin: const EdgeInsets.only(bottom: 18),

          padding: const EdgeInsets.all(16),

          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),

            gradient: const LinearGradient(
              colors: [Color(0xFF16222A), Color(0xFF3A6073)],
            ),
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Text(
                listItem.title,

                style: const TextStyle(
                  color: Colors.white,

                  fontSize: 15,

                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 14),

              ...listItem.items.map((e) {
                return Padding(
                  key: e.key!,
                  padding: const EdgeInsets.only(bottom: 10),

                  child: InkWell(
                    borderRadius: BorderRadius.circular(18),

                    onTap: () {
                      scrollToItem(
                        sectionTitle: listItem.title,
                        routeTemp: e.route,
                        key: e.key!,
                      );
                      controller.isDrawerSearchVisible.refresh();
                    },

                    child: Ink(
                      padding: const EdgeInsets.all(14),

                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),

                        color: Colors.white.withValues(alpha: 0.08),
                      ),

                      child: Row(
                        children: [
                          Icon(e.icon, color: Colors.white),

                          const SizedBox(width: 14),

                          Expanded(
                            child: Text(
                              e.title,

                              style: const TextStyle(color: Colors.white),
                            ),
                          ),

                          const Icon(
                            Icons.arrow_forward_ios_rounded,

                            color: Colors.white70,

                            size: 14,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        );
      }).toList(),
    );
  }

  /// =========================================================
  /// DRAWER ITEM
  /// =========================================================

  Widget buildDrawerActualItem({
    required BuildContext context,
    required DrawerActualItem item,
    required Color onSurface,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 0),

      child: Material(
        color: Colors.transparent,

        child: InkWell(
          borderRadius: BorderRadius.circular(18),

          onTap: () {
            Get.toNamed(item.route);
          },

          child: Ink(
            padding: EdgeInsets.only(left: 14, top: 10, right: 14, bottom: 0),

            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(0),

              color: Theme.of(
                context,
              ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.22),
            ),

            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Container(
                  padding: const EdgeInsets.all(10),

                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,

                    gradient: LinearGradient(
                      colors: [Color(0xFFFFE082), Color(0xFFD4AF37)],
                    ),
                  ),

                  child: Icon(item.icon, color: Colors.black, size: 20),
                ),

                const SizedBox(width: 14),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Text(
                        item.title,

                        style: const TextStyle(
                          color: Color(0xFFFFD369),

                          fontSize: 14.5,

                          fontWeight: FontWeight.w700,

                          letterSpacing: 0.4,
                        ),
                      ),

                      const SizedBox(height: 5),

                      Text(
                        DrawerNavigationCopy.linkSubtitle(
                          item.route ?? item.title,
                          item.title,
                        ),

                        maxLines: 3,

                        overflow: TextOverflow.ellipsis,

                        style: TextStyle(
                          fontSize: 11,

                          height: 1.4,

                          color: onSurface.withValues(alpha: 0.75),
                        ),
                      ),
                    ],
                  ),
                ),

                Icon(
                  Icons.arrow_forward_ios_rounded,

                  size: 15,

                  color: const Color(0xFFD4AF37).withValues(alpha: 0.7),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PositionTracker extends StatefulWidget {
  final Widget child;
  final String title;
  final Map<String, double> itemOffsets;

  const PositionTracker({
    super.key,
    required this.child,
    required this.title,
    required this.itemOffsets,
  });

  @override
  State<PositionTracker> createState() => _PositionTrackerState();
}

class _PositionTrackerState extends State<PositionTracker> {
  @override
  void initState() {
    super.initState();
    // Measure after the first frame so RenderBox is ready.
    WidgetsBinding.instance.addPostFrameCallback((_) => _measure());
  }

  void _measure() {
    if (!mounted) return;
    final box = context.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize) return;

    // Find the nearest Scrollable ancestor and measure offset within it.
    final scrollable = Scrollable.maybeOf(context);
    if (scrollable == null) return;

    final scrollBox =
        scrollable.context.findRenderObject() as RenderBox?;
    if (scrollBox == null) return;

    // Position of this widget in the scrollable's coordinate space
    // + current scroll offset = absolute offset in the full list.
    final localPos = scrollBox.globalToLocal(
      box.localToGlobal(Offset.zero),
    );

    final sc = scrollable.position;
    widget.itemOffsets[widget.title] =
        (localPos.dy + sc.pixels).clamp(0.0, double.infinity);
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

