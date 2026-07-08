import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../widgets/clay_container.dart';

/// Bali waste-sorting guide with trivia corner,
/// bin category cards, and eco-tips.
class GuideScreen extends StatefulWidget {
  const GuideScreen({super.key});

  @override
  State<GuideScreen> createState() =>
      _GuideScreenState();
}

class _GuideScreenState extends State<GuideScreen> {
  int _triviaIndex = 0;

  final List<String> _triviaFacts = [
    'Bali memproduksi sekitar 4.281 ton sampah setiap hari, namun hanya sekitar 10-15% yang berhasil didaur ulang.',
    'Sejak 2019, Pemprov Bali secara resmi melarang penggunaan kantong plastik sekali pakai, styrofoam, dan sedotan plastik di supermarket dan pertokoan.',
    'Sampah organik seperti sisa makanan dan sesaji ("Canang Sari") menyumbang lebih dari 60% total sampah rumah tangga di Bali.',
    'Menumpuknya sampah organik di TPA Suwung tanpa oksigen menghasilkan gas metana, gas rumah kaca yang 25 kali lebih kuat menangkap panas dibanding CO2.',
    'Membersihkan atau membilas kemasan plastik/kaca dari sisa makanan meningkatkan peluang daur ulangnya hingga 90% di pusat pemilahan Bali.',
    'Sungai Watch, sebuah LSM lingkungan di Bali, telah memasang lebih dari 150 jaring sampah di sungai-sungai Bali dan mengumpulkan ratusan ton plastik.',
    'Membuat lubang biopori di halaman rumah adalah cara termudah menyerap air hujan sekaligus mengompos sisa canang sari dan dedaunan di Bali.',
  ];

  void _nextTrivia() {
    setState(() {
      _triviaIndex =
          (_triviaIndex + 1) % _triviaFacts.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final binColors = theme.extension<BinColors>();

    return Scaffold(
      appBar: const CustomAppBar(title: 'Panduan Bali Hijau'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 24.0,
            vertical: 16.0,
          ),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.stretch,
            children: [
              _buildTriviaCorner(theme),
              const SizedBox(height: 28),
              Text(
                'Tiga Wadah Sampah Bali',
                style: GoogleFonts.outfit(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Berdasarkan Pergub Bali No. 47 Tahun '
                '2019 tentang Pengelolaan Sampah '
                'Berbasis Sumber.',
                style: GoogleFonts.outfit(
                  fontSize: 12.5,
                  color: theme
                      .colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 16),

              // Bin Cards
              _buildBinCard(
                title: '1. ORGANIK (Hijau)',
                description:
                    'Sampah alami yang mudah membusuk '
                    'dan terurai kembali ke tanah.',
                details:
                    '• Sisa makanan & potongan sayur\n'
                    '• Daun kering & ranting kebun\n'
                    '• Bekas sesaji Canang Sari '
                    '(bunga & janur)\n'
                    '• Kulit buah\n\n'
                    'Tips Bali: Jadikan kompos mandiri '
                    'di rumah atau masukkan ke lubang '
                    'biopori keluarga untuk '
                    'menyuburkan tanah Bali.',
                color:
                    binColors?.organik ?? Colors.green,
              ),
              const SizedBox(height: 14),
              _buildBinCard(
                title: '2. NON-ORGANIK (Kuning)',
                description:
                    'Bahan yang tidak membusuk tapi '
                    'bernilai untuk didaur ulang kembali.',
                details:
                    '• Botol plastik minuman '
                    '(PET/HDPE)\n'
                    '• Kaleng aluminium & kemasan logam\n'
                    '• Kertas, kardus, koran & buku\n'
                    '• Botol & wadah kaca\n\n'
                    'Tips Bali: Bilas dari sisa makanan'
                    '/cairan terlebih dahulu. Wadah yang '
                    'kotor tidak diterima oleh bank '
                    'sampah lokal.',
                color: binColors?.nonOrganik ??
                    Colors.amber,
              ),
              const SizedBox(height: 14),
              _buildBinCard(
                title: '3. RESIDU (Merah/Abu)',
                description:
                    'Sampah yang tidak bisa didaur ulang'
                    ' maupun dikomposkan. Harus ke TPA.',
                details:
                    '• Popok bayi & pembalut bekas\n'
                    '• Pembalut/tissue basah kotor\n'
                    '• Plastik sachet multi-layer '
                    '(kemasan kopi/snack)\n'
                    '• Puntung rokok & pecahan keramik'
                    '\n\nTips Bali: Kurangi penggunaan '
                    'barang sachet dan beralihlah ke '
                    'produk isi ulang (refill) guna '
                    'meminimalisir beban TPA Suwung.',
                color: binColors?.residu ?? Colors.red,
              ),
              const SizedBox(height: 28),

              // Eco tips section
              Text(
                'Langkah Menuju Bali Zero-Waste',
                style: GoogleFonts.outfit(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              _buildEcoTipsSection(theme),
              const SizedBox(height: 32),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 16.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildTriviaCorner(theme),
                const SizedBox(height: 28),
                Text(
                  'Tiga Wadah Sampah Bali',
                  style: GoogleFonts.outfit(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Berdasarkan Pergub Bali No. 47 Tahun 2019 tentang Pengelolaan Sampah Berbasis Sumber.',
                  style: GoogleFonts.outfit(
                    fontSize: 12.5,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 16),

                // Bin Cards
                _buildBinCard(
                  title: '1. ORGANIK (Hijau)',
                  description:
                      'Sampah alami yang mudah membusuk dan terurai kembali ke tanah.',
                  details:
                      '• Sisa makanan & potongan sayur\n'
                      '• Daun kering & ranting kebun\n'
                      '• Bekas sesaji Canang Sari (bunga & janur)\n'
                      '• Kulit buah\n\n'
                      'Tips Bali: Jadikan kompos mandiri di rumah atau masukkan ke lubang biopori keluarga untuk menyuburkan tanah Bali.',
                  color: binColors?.organik ?? Colors.green,
                ),
                const SizedBox(height: 14),
                _buildBinCard(
                  title: '2. NON-ORGANIK (Kuning)',
                  description:
                      'Bahan yang tidak membusuk tapi bernilai untuk didaur ulang kembali.',
                  details:
                      '• Botol plastik minuman (PET/HDPE)\n'
                      '• Kaleng aluminium & kemasan logam\n'
                      '• Kertas, kardus, koran & buku\n'
                      '• Botol & wadah kaca\n\n'
                      'Tips Bali: Bilas dari sisa makanan/cairan terlebih dahulu. Wadah yang kotor tidak diterima oleh bank sampah lokal.',
                  color: binColors?.nonOrganik ?? Colors.amber,
                ),
                const SizedBox(height: 14),
                _buildBinCard(
                  title: '3. RESIDU (Merah/Abu)',
                  description:
                      'Sampah yang tidak bisa didaur ulang maupun dikomposkan. Harus ke TPA.',
                  details:
                      '• Popok bayi & pembalut bekas\n'
                      '• Pembalut/tissue basah kotor\n'
                      '• Plastik sachet multi-layer (kemasan kopi/snack)\n'
                      '• Puntung rokok & pecahan keramik\n\n'
                      'Tips Bali: Kurangi penggunaan barang sachet dan beralihlah ke produk isi ulang (refill) guna meminimalisir beban TPA Suwung.',
                  color: binColors?.residu ?? Colors.red,
                ),
                const SizedBox(height: 28),

                // Eco tips section
                Text(
                  'Langkah Menuju Bali Zero-Waste',
                  style: GoogleFonts.outfit(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                _buildEcoTipsSection(theme),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTriviaCorner(ThemeData theme) {
    return ClayContainer(
      padding: const EdgeInsets.all(20),
      color: theme.colorScheme.primaryContainer.withAlpha(80),
      borderRadius: 24,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.lightbulb_outline_rounded,
                color: theme.colorScheme.primary,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                'Tahukah Anda? (Trivia Eco Bali)',
                style: GoogleFonts.outfit(
                  fontSize: 14.5,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.neonGreen,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          AnimatedSwitcher(
            duration:
                const Duration(milliseconds: 300),
            child: Text(
              _triviaFacts[_triviaIndex],
              key: ValueKey<int>(_triviaIndex),
              style: GoogleFonts.outfit(
                fontSize: 13.5,
                height: 1.45,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: _nextTrivia,
              icon: Icon(
                Icons.refresh_rounded,
                size: 18,
                color: theme.colorScheme.primary,
              ),
              label: Text(
                'Fakta Lain',
                style: GoogleFonts.outfit(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                backgroundColor: theme.colorScheme.primary.withAlpha(20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBinCard({
    required String title,
    required String description,
    required String details,
    required Color color,
  }) {
    return Theme(
      data: ThemeData(
        useMaterial3: true,
      ).copyWith(dividerColor: Colors.transparent),
      child: ClayContainer(
        borderRadius: 20,
        color: color.withAlpha(15),
        child: ExpansionTile(
          collapsedIconColor: color,
          iconColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          collapsedShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: Text(
            title,
            style: GoogleFonts.outfit(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: color,
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(
              description,
              style: GoogleFonts.outfit(
                fontSize: 12.5,
                color:
                    theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                16,
                0,
                16,
                16,
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.stretch,
                children: [
                  Divider(
                    height: 16,
                    color: color.withAlpha(40),
                  ),
                  Text(
                    details,
                    style: GoogleFonts.outfit(
                      fontSize: 13,
                      height: 1.5,
                      color: theme
                          .colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEcoTipsSection(ThemeData theme) {
    final brightness = theme.brightness;
    final tips = [
      {
        'title': 'Bawa Tas Belanja',
        'desc':
            'Hindari tas plastik kresek dengan selalu siap sedia "Tas Belanja" kain lipat di bagasi motor Anda.',
        'icon': Icons.shopping_bag_outlined,
      },
      {
        'title': 'Pilah Dari Sumber',
        'desc':
            'Sediakan 3 wadah terpisah langsung di dapur Anda. Pemilahan sejak dini mempermudah petugas kebersihan.',
        'icon': Icons.layers_outlined,
      },
      {
        'title': 'Bilas Wadah Plastik',
        'desc':
            'Kemasan yogurt/susu kotor berbau busuk merusak ribuan kertas/kardus lain. Bilas cepat sebelum dibuang!',
        'icon': Icons.cleaning_services_outlined,
      },
    ];

    return SizedBox(
      height: 148,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: tips.length,
        itemBuilder: (context, index) {
          final tip = tips[index];
          return ClayContainer(
            width: 250,
            margin: const EdgeInsets.only(right: 14),
            padding: const EdgeInsets.all(16),
            color: theme.colorScheme.surfaceContainerLow,
            borderRadius: 20,
            child: Row(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: ClayDecoration.pill(
                    color: AppTheme.neonGreen
                        .withAlpha(20),
                    brightness: brightness,
                  ).copyWith(
                    borderRadius:
                        BorderRadius.circular(14),
                  ),
                  child: Icon(
                    tip['icon'] as IconData,
                    color: AppTheme.neonGreen,
                    size: 22,
                  ),
                  child: Icon(
                    tip['icon'] as IconData,
                    color: theme.colorScheme.secondary,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        tip['title'] as String,
                        style: GoogleFonts.outfit(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Expanded(
                        child: Text(
                          tip['desc'] as String,
                          maxLines: 4,
                          overflow:
                              TextOverflow.ellipsis,
                          style: GoogleFonts.outfit(
                            fontSize: 11.5,
                            color: theme.colorScheme
                                .onSurfaceVariant,
                            height: 1.35,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
