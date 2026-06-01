import 'package:flutter/material.dart';
import '../config/theme_config.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  static const List<_TeamMember> _team = [
    _TeamMember(
      name: 'Izzul Fath Marwansyah',
      role: 'Backend & Database',
      photoAsset: 'assets/images/team/izzul.jpeg',
      isLeader: true,
      avatarColor: Color(0xFFD94A6E),
      description:
          'Merancang dan mengembangkan seluruh struktur backend aplikasi menggunakan PHP dan MySQL. Bertanggung jawab atas desain database, pembuatan REST API (9 endpoint), konfigurasi server, serta memastikan keamanan dan performa sistem secara keseluruhan.',
    ),
    _TeamMember(
      name: 'Maulinda Rizna Putri',
      role: 'Admin Panel & Product Management',
      photoAsset: 'assets/images/team/linda.jpeg',
      isLeader: false,
      avatarColor: Color(0xFF7B1FA2),
      description:
          'Membangun antarmuka panel admin secara lengkap, mencakup halaman manajemen produk, kategori, dan data pelanggan. Mengembangkan fitur CRUD produk dengan integrasi gambar dan sistem kategori yang terstruktur.',
    ),
    _TeamMember(
      name: 'Ayu Salsa Aulia',
      role: 'Customer UI/UX',
      photoAsset: 'assets/images/team/ayu.jpeg',
      isLeader: false,
      avatarColor: Color(0xFF0288D1),
      description:
          'Merancang dan mengimplementasikan tampilan sisi pelanggan, termasuk beranda, detail produk, wishlist, dan halaman profil. Berfokus pada pengalaman pengguna (UX) yang intuitif, responsif, dan estetis.',
    ),
    _TeamMember(
      name: 'Alfadhila Abelia Saputri',
      role: 'Cart & Checkout',
      photoAsset: 'assets/images/team/alfadhila.jpeg',
      isLeader: false,
      avatarColor: Color(0xFF388E3C),
      description:
          'Mengembangkan fitur keranjang belanja (cart) dengan penyimpanan persisten menggunakan SharedPreferences, serta halaman checkout lengkap dengan kalkulasi ongkos kirim otomatis untuk setiap kota.',
    ),
    _TeamMember(
      name: 'Sumiyati',
      role: 'Order Management & Analytics',
      photoAsset: 'assets/images/team/sumiyati.jpeg',
      isLeader: false,
      avatarColor: Color(0xFFF57C00),
      description:
          'Mengimplementasikan sistem manajemen pesanan dari sisi pelanggan maupun admin, termasuk fitur tracking status pesanan secara real-time dan analitik dashboard admin untuk memantau kinerja toko.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeConfig.backgroundColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 220.0,
            floating: false,
            pinned: true,
            elevation: 0,
            backgroundColor: ThemeConfig.primaryColor,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 0, bottom: 16),
              centerTitle: true,
              title: const Text(
                'Tentang Kami',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [ThemeConfig.primaryColor, ThemeConfig.accentColor],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      top: -30,
                      right: -30,
                      child: Container(
                        width: 130,
                        height: 130,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.08),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 30,
                      left: -20,
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.06),
                        ),
                      ),
                    ),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 20),
                          Container(
                            width: 72,
                            height: 72,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.cake_rounded,
                              size: 40,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'SweetBake',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 26,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const Text(
                            'Versi 1.0.0',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SectionCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: ThemeConfig.primaryColor.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(
                                Icons.info_outline_rounded,
                                color: ThemeConfig.primaryColor,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text('Tentang Aplikasi', style: ThemeConfig.heading3),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Text(
                          'SweetBake adalah aplikasi mobile e-commerce toko kue yang dirancang untuk memudahkan proses pembelian dan manajemen produk kue secara digital.',
                          style: ThemeConfig.bodyMedium.copyWith(
                            color: ThemeConfig.textSecondaryColor,
                            height: 1.6,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Dibangun dengan Flutter & PHP sebagai tugas akhir mata kuliah Pemrograman Mobile.',
                          style: ThemeConfig.bodyMedium.copyWith(
                            color: ThemeConfig.textSecondaryColor,
                            height: 1.6,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: ThemeConfig.primaryColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.people_alt_rounded,
                          color: ThemeConfig.primaryColor,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text('Tim Developer', style: ThemeConfig.heading3),
                    ],
                  ),
                  const SizedBox(height: 16),

                  ...(_team.map((member) => Padding(
                        padding: const EdgeInsets.only(bottom: 14),
                        child: _TeamCard(member: member, index: _team.indexOf(member)),
                      ))),

                  const SizedBox(height: 24),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          ThemeConfig.primaryColor.withValues(alpha: 0.08),
                          ThemeConfig.accentColor.withValues(alpha: 0.06),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: ThemeConfig.primaryColor.withValues(alpha: 0.15),
                      ),
                    ),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.favorite_rounded,
                          color: ThemeConfig.primaryColor,
                          size: 28,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Dibuat dengan ❤️ oleh Tim SweetBake',
                          style: ThemeConfig.bodyMedium.copyWith(
                            fontWeight: FontWeight.w600,
                            color: ThemeConfig.textPrimaryColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Mata Kuliah Pemrograman Mobile · 2025',
                          style: ThemeConfig.bodySmall,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TeamMember {
  final String name;
  final String role;
  final String photoAsset;
  final bool isLeader;
  final Color avatarColor;
  final String description;

  const _TeamMember({
    required this.name,
    required this.role,
    required this.photoAsset,
    required this.isLeader,
    required this.avatarColor,
    required this.description,
  });

  String get initials {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return parts[0].substring(0, 1).toUpperCase();
  }
}

class _TeamCard extends StatelessWidget {
  final _TeamMember member;
  final int index;

  const _TeamCard({required this.member, required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: ThemeConfig.softShadow,
        border: Border.all(color: Colors.grey.shade200, width: 1.5),
      ),
      child: Material(
        color: ThemeConfig.cardColor,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => _MemberDetailPage(
                  key: ValueKey(member.name),
                  member: member, 
                  heroTag: 'team_avatar_$index',
                ),
              ),
            );
          },
          borderRadius: BorderRadius.circular(20),
          splashColor: member.avatarColor.withValues(alpha: 0.08),
          highlightColor: member.avatarColor.withValues(alpha: 0.04),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Stack(
                  children: [
                    Hero(
                      tag: 'team_avatar_$index',
                      child: ClipOval(
                        child: Image.asset(
                          member.photoAsset,
                          width: 66,
                          height: 66,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 66,
                              height: 66,
                              decoration: BoxDecoration(
                                color: member.avatarColor,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  member.initials,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    if (member.isLeader)
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          width: 22,
                          height: 22,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFB300),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: const Icon(
                            Icons.star_rounded,
                            size: 12,
                            color: Colors.white,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        member.name,
                        style: ThemeConfig.bodyLarge.copyWith(
                          fontWeight: FontWeight.w700,
                          color: ThemeConfig.textPrimaryColor,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: member.avatarColor.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          member.isLeader ? '👑 Ketua · ${member.role}' : member.role,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: member.avatarColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14,
                  color: ThemeConfig.textSecondaryColor.withValues(alpha: 0.5),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MemberDetailPage extends StatelessWidget {
  final _TeamMember member;
  final String heroTag;

  const _MemberDetailPage({super.key, required this.member, required this.heroTag});

  Widget _buildPhoto(double height) {
    return Hero(
      tag: heroTag,
      child: SizedBox(
        width: double.infinity,
        height: height,
        child: Image.asset(
          member.photoAsset,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              width: double.infinity,
              height: height,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    member.avatarColor,
                    member.avatarColor.withValues(alpha: 0.7),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    member.initials,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: height * 0.28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const double photoHeight = 300;

    return Scaffold(
      backgroundColor: ThemeConfig.backgroundColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: photoHeight,
            pinned: true,
            elevation: 0,
            backgroundColor: member.avatarColor,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: _buildPhoto(photoHeight),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          member.name,
                          style: ThemeConfig.heading2,
                        ),
                      ),
                      if (member.isLeader)
                        Container(
                          margin: const EdgeInsets.only(top: 4),
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFB300),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.star_rounded, size: 13, color: Colors.white),
                              SizedBox(width: 4),
                              Text(
                                'Ketua',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: member.avatarColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: member.avatarColor.withValues(alpha: 0.25),
                      ),
                    ),
                    child: Text(
                      member.role,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: member.avatarColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: ThemeConfig.cardColor,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: ThemeConfig.softShadow,
                      border: Border.all(color: Colors.grey.shade200, width: 1.5),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: member.avatarColor.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                Icons.assignment_ind_rounded,
                                color: member.avatarColor,
                                size: 18,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'Kontribusi',
                              style: ThemeConfig.heading3.copyWith(fontSize: 17),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Text(
                          member.description,
                          style: ThemeConfig.bodyMedium.copyWith(
                            color: ThemeConfig.textSecondaryColor,
                            height: 1.7,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: ThemeConfig.cardColor,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: ThemeConfig.softShadow,
                      border: Border.all(color: Colors.grey.shade200, width: 1.5),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: member.avatarColor.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                Icons.cake_rounded,
                                color: member.avatarColor,
                                size: 18,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'Tentang Proyek',
                              style: ThemeConfig.heading3.copyWith(fontSize: 17),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        _InfoRow(label: 'Nama Proyek', value: 'SweetBake'),
                        const SizedBox(height: 8),
                        _InfoRow(label: 'Mata Kuliah', value: 'Pemrograman Mobile'),
                        const SizedBox(height: 8),
                        _InfoRow(label: 'Teknologi', value: 'Flutter · PHP · MySQL'),
                        const SizedBox(height: 8),
                        _InfoRow(label: 'Tahun', value: '2025'),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 110,
          child: Text(
            label,
            style: ThemeConfig.bodyMedium.copyWith(
              color: ThemeConfig.textSecondaryColor,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: ThemeConfig.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
              color: ThemeConfig.textPrimaryColor,
            ),
          ),
        ),
      ],
    );
  }
}

class _SectionCard extends StatelessWidget {
  final Widget child;

  const _SectionCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: ThemeConfig.cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: ThemeConfig.softShadow,
        border: Border.all(color: Colors.grey.shade200, width: 1.5),
      ),
      child: child,
    );
  }
}
