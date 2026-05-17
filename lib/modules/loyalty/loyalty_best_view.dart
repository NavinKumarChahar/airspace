<<<<<<< HEAD
import 'package:air_app/modules/loyalty/loyalty_enhanced_view.dart';
import 'package:flutter/material.dart';

/// Expansion Tiles design wrapper for Loyalty module
/// Features: Collapsible sections, hierarchical information, exploration-friendly
class LoyaltyBestView extends StatefulWidget {
  const LoyaltyBestView({super.key});

  @override
  State<LoyaltyBestView> createState() => _LoyaltyBestViewState();
}

class _LoyaltyBestViewState extends State<LoyaltyBestView> {
  int _expandedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    const loyaltyColor = Color(0xffd4a574);

    return Scaffold(
      backgroundColor: isDark ? const Color(0xff1a1a1a) : Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 180,
            backgroundColor: isDark ? const Color(0xff1a1a1a) : Colors.white,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              background: _ExpansionHeader(isDark: isDark),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                children: [
                  Text(
                    'The Strength of Loyalty',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white : Colors.black87,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Loyalty is steadfastness and commitment. Explore the different dimensions of this profound value.',
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.6,
                      color: isDark ? Colors.white70 : Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _LoyaltyExpansionTile(
                    title: 'Personal Loyalty',
                    icon: Icons.person_rounded,
                    description: 'Being true to yourself and your values',
                    isExpanded: _expandedIndex == 0,
                    onExpanded: () => setState(() => _expandedIndex = 0),
                    isDark: isDark,
                    items: [
                      'Honor your commitments to yourself',
                      'Stay true to your core values',
                      'Practice consistency in actions',
                      'Grow without losing your essence',
                    ],
                  ),
                  const SizedBox(height: 12),
                  _LoyaltyExpansionTile(
                    title: 'Relational Loyalty',
                    icon: Icons.handshake_rounded,
                    description: 'Commitment to those you care about',
                    isExpanded: _expandedIndex == 1,
                    onExpanded: () => setState(() => _expandedIndex = 1),
                    isDark: isDark,
                    items: [
                      'Show up for loved ones consistently',
                      'Support them through challenges',
                      'Celebrate their victories',
                      'Maintain trust and transparency',
                    ],
                  ),
                  const SizedBox(height: 12),
                  _LoyaltyExpansionTile(
                    title: 'Professional Loyalty',
                    icon: Icons.business_rounded,
                    description: 'Dedication to your work and team',
                    isExpanded: _expandedIndex == 2,
                    onExpanded: () => setState(() => _expandedIndex = 2),
                    isDark: isDark,
                    items: [
                      'Deliver quality work consistently',
                      'Contribute to team success',
                      'Build lasting professional relationships',
                      'Uphold organizational values',
                    ],
                  ),
                  const SizedBox(height: 12),
                  _LoyaltyExpansionTile(
                    title: 'Community Loyalty',
                    icon: Icons.public_rounded,
                    description: 'Service to the greater good',
                    isExpanded: _expandedIndex == 3,
                    onExpanded: () => setState(() => _expandedIndex = 3),
                    isDark: isDark,
                    items: [
                      'Contribute to your community',
                      'Support collective causes',
                      'Be a reliable community member',
                      'Work toward shared prosperity',
                    ],
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                children: [
                  Container(width: 4, height: 22, color: loyaltyColor),
                  const SizedBox(width: 10),
                  Text(
                    'ORIGINAL CONTENT',
                    style: TextStyle(
                      letterSpacing: 2,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white60 : Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(child: const LoyaltyEnhancedView()),
        ],
      ),
    );
  }
}

class _ExpansionHeader extends StatelessWidget {
  final bool isDark;
  const _ExpansionHeader({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xffd4a574).withValues(alpha: 0.1),
                Colors.orange.withValues(alpha: 0.06),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xffd4a574).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xffd4a574).withValues(alpha: 0.3),
                  ),
                ),
                child: const Icon(
                  Icons.verified_rounded,
                  color: Color(0xffd4a574),
                  size: 28,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Loyalty'.toUpperCase(),
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black87,
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Expansion Tiles Design',
                style: TextStyle(
                  color: isDark ? Colors.white60 : Colors.black54,
                  fontSize: 12,
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _LoyaltyExpansionTile extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final List<String> items;
  final bool isExpanded;
  final VoidCallback onExpanded;
  final bool isDark;
  const _LoyaltyExpansionTile({
    required this.title,
    required this.description,
    required this.icon,
    required this.items,
    required this.isExpanded,
    required this.onExpanded,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.08)
            : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.1)
              : Colors.black.withValues(alpha: 0.05),
        ),
      ),
      child: Column(
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onExpanded,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xffd4a574).withValues(alpha: 0.15),
                      ),
                      child: Icon(
                        icon,
                        color: const Color(0xffd4a574),
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: isDark ? Colors.white : Colors.black87,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            description,
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark ? Colors.white60 : Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      isExpanded
                          ? Icons.expand_less_rounded
                          : Icons.expand_more_rounded,
                      color: const Color(0xffd4a574),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (isExpanded)
            Container(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: items
                    .map(
                      (item) => Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Container(
                                width: 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: const Color(
                                    0xffd4a574,
                                  ).withValues(alpha: 0.6),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                item,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: isDark
                                      ? Colors.white70
                                      : Colors.black54,
                                  height: 1.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
=======
import 'package:flutter/material.dart';

/// DESIGN: Stacked Card Deck — overlapping offset cards with depth effect
class LoyaltyBestView extends StatelessWidget {
  const LoyaltyBestView({super.key});

  static const _gold = Color(0xFFD4A853);
  static const _amber = Color(0xFFF59E0B);
  static const _bronze = Color(0xFFB45309);
  static const _teal = Color(0xFF0D9488);
  static const _violet = Color(0xFF7C3AED);
  static const _rose = Color(0xFFF43F5E);
  static const _bg = Color(0xFF080500);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _bg,
        foregroundColor: Colors.white,
        title: const Text('LOYALTY', style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 4, fontSize: 14, color: Colors.white)),
        centerTitle: true,
        actions: [Padding(padding: const EdgeInsets.only(right: 14), child: Icon(Icons.loyalty_rounded, color: _gold, size: 22))],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
        children: [
          // HERO
          Container(
            padding: const EdgeInsets.all(20), decoration: BoxDecoration(
              gradient: LinearGradient(colors: [const Color(0xFF2A1800), const Color(0xFF140C00)], begin: Alignment.topLeft, end: Alignment.bottomRight),
              borderRadius: BorderRadius.circular(22), border: Border.all(color: _gold.withOpacity(0.3)),
            ),
            child: Row(children: [
              Icon(Icons.loyalty_rounded, color: _gold, size: 38),
              const SizedBox(width: 16),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('LOYALTY INTELLIGENCE', style: TextStyle(color: _gold, fontSize: 9, fontWeight: FontWeight.w800, letterSpacing: 2)),
                const SizedBox(height: 6),
                const Text('Loyalty is the long game — a compounding asset that the disloyal will never understand.', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700, height: 1.3)),
              ])),
            ]),
          ),
          const SizedBox(height: 28),
          Text('THE LOYALTY STACK', style: TextStyle(color: _gold.withOpacity(0.7), fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 3)),
          const SizedBox(height: 16),
          // STACKED CARD DECK
          _StackedDeck(cards: [
            _DeckCard(depth: 3, color: _bronze.withOpacity(0.4), title: '', body: ''),
            _DeckCard(depth: 2, color: _amber.withOpacity(0.5), title: '', body: ''),
            _DeckCard(depth: 1, color: _gold.withOpacity(0.6), title: '', body: ''),
            _DeckCard(depth: 0, color: _gold, title: 'The Foundation Card', body: 'Loyalty begins with keeping the promises no one is watching you keep. The private commitments — the ones with no audience, no recognition, and no immediate benefit — are the true test of loyal character. AIR tracks these private commitments and logs your adherence rate.'),
          ]),
          const SizedBox(height: 24),
          // INDIVIDUAL INSIGHT CARDS
          _LoyaltyCard(index: '01', color: _amber, icon: Icons.handshake_rounded, title: 'Consistency Principle',
              body: 'Loyalty is consistency across contexts. A person who is loyal only when it is convenient or beneficial is not loyal — they are strategically compliant. True loyalty holds when it costs something: when your friend is unpopular, when your organisation is struggling, when speaking up carries personal risk.'),
          const SizedBox(height: 10),
          _LoyaltyCard(index: '02', color: _teal, icon: Icons.balance_rounded, title: 'Loyalty vs. Blind Allegiance',
              body: 'Healthy loyalty includes the courage to tell truth to the people or institutions you are loyal to. The person who enables bad behaviour in the name of loyalty is not loyal — they are complicit. True loyalty protects the long-term wellbeing of its object, even at short-term cost.'),
          const SizedBox(height: 10),
          _LoyaltyCard(index: '03', color: _violet, icon: Icons.trending_up_rounded, title: 'Loyalty Compounds',
              body: 'Loyalty is a compounding relationship currency. Each act of loyalty — showing up when it was hard, advocating when absent, keeping a secret entrusted — builds a credit balance that produces proportionate returns in crisis. People with decades of demonstrated loyalty experience a qualitatively different level of trust.'),
          const SizedBox(height: 10),
          _LoyaltyCard(index: '04', color: _rose, icon: Icons.warning_rounded, title: 'When Loyalty Must End',
              body: 'Loyalty has a terminus when its object requires you to participate in harm — to others, to yourself, or to the truth. Knowing when to withdraw loyalty honourably is as important as knowing how to maintain it. The withdrawal should be explicit, explained, and as respectful as the relationship earned.'),
          const SizedBox(height: 10),
          _LoyaltyCard(index: '05', color: _gold, icon: Icons.people_rounded, title: 'Mutual Loyalty Audit',
              body: 'Every loyalty relationship requires periodic audit: is this loyalty mutual? Am I being loyal to someone or something that consistently demonstrates they are not loyal to me? Asymmetric loyalty is not a virtue — it is a form of self-abandonment that ultimately costs both parties.'),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16), decoration: BoxDecoration(gradient: LinearGradient(colors: [_gold.withOpacity(0.1), _bronze.withOpacity(0.06)]), borderRadius: BorderRadius.circular(16), border: Border.all(color: _gold.withOpacity(0.2))),
            child: Row(children: [
              Icon(Icons.format_quote_rounded, color: _amber, size: 26), const SizedBox(width: 12),
              const Expanded(child: Text('"The strength of a family, like the strength of an army, lies in its loyalty to each other." — Mario Puzo', style: TextStyle(color: Colors.white, fontSize: 12, height: 1.4, fontStyle: FontStyle.italic))),
            ]),
          ),
>>>>>>> 6421d17fb7c28391288439a654a84723ee2d8c08
        ],
      ),
    );
  }
}
<<<<<<< HEAD
=======

class _DeckCard {
  final int depth; final Color color; final String title, body;
  const _DeckCard({required this.depth, required this.color, required this.title, required this.body});
}

class _StackedDeck extends StatelessWidget {
  final List<_DeckCard> cards;
  const _StackedDeck({required this.cards});
  @override
  Widget build(BuildContext context) => SizedBox(
    height: 160,
    child: Stack(children: cards.map((c) {
      final offset = c.depth * 6.0;
      return Positioned(
        top: offset, left: offset, right: -offset,
        child: Container(
          padding: c.depth == 0 ? const EdgeInsets.all(16) : null,
          height: 140,
          decoration: BoxDecoration(
            color: c.color.withOpacity(c.depth == 0 ? 0.12 : 0.06),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: c.color.withOpacity(c.depth == 0 ? 0.4 : 0.15)),
            boxShadow: [BoxShadow(color: c.color.withOpacity(0.08), blurRadius: 8, offset: const Offset(0, 4))],
          ),
          child: c.depth == 0 ? Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(c.title, style: TextStyle(color: const Color(0xFFD4A853), fontSize: 13, fontWeight: FontWeight.w800)),
            const SizedBox(height: 8),
            Text(c.body, style: const TextStyle(color: Colors.white70, fontSize: 11, height: 1.45)),
          ]) : null,
        ),
      );
    }).toList()),
  );
}

class _LoyaltyCard extends StatelessWidget {
  final String index, title, body; final Color color; final IconData icon;
  const _LoyaltyCard({required this.index, required this.color, required this.icon, required this.title, required this.body});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: color.withOpacity(0.07), borderRadius: BorderRadius.circular(16), border: Border.all(color: color.withOpacity(0.2))),
    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Column(children: [
        Text(index, style: TextStyle(color: color.withOpacity(0.5), fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1)),
        const SizedBox(height: 4),
        Icon(icon, color: color, size: 20),
      ]),
      const SizedBox(width: 14),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: TextStyle(color: color, fontSize: 14, fontWeight: FontWeight.w800)),
        const SizedBox(height: 6),
        Text(body, style: const TextStyle(color: Colors.white70, fontSize: 12, height: 1.5)),
      ])),
    ]),
  );
}
>>>>>>> 6421d17fb7c28391288439a654a84723ee2d8c08
