import 'package:klicum/domain/datasources/coupon_datasource.dart';
import 'package:klicum/domain/repositories/coupon_repository.dart';

class CouponRepositoryImpl implements CouponRepository {
  final CouponDatasource datasource;

  CouponRepositoryImpl({required this.datasource});
  
  @override
  Future<void> useCoupon({required String coupon}) async => await datasource.useCoupon(coupon: coupon);
}