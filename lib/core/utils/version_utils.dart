int compareSemver(String current, String minimum) {
  final c = current.split('.').map(int.parse).toList();
  final m = minimum.split('.').map(int.parse).toList();
  final n = (c.length > m.length) ? c.length : m.length;
  for (int i = 0; i < n; i++) {
    final ci = (i < c.length) ? c[i] : 0;
    final mi = (i < m.length) ? m[i] : 0;
    if (ci < mi) return -1;
    if (ci > mi) return 1;
  }
  return 0;
}
