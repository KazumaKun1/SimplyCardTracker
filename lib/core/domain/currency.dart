enum Currency {
  php('PHP', '₱', 2),
  usd('USD', r'$', 2);

  const Currency(this.code, this.symbol, this.decimals);
  final String code;
  final String symbol;
  final int decimals;
}
