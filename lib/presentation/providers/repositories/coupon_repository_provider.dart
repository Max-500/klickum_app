import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:klicum/infraestructure/datasources/coupon_datasource_impl.dart';
import 'package:klicum/infraestructure/repositories/coupon_repository_impl.dart';

final couponRepositoryProvider = Provider((ref) => CouponRepositoryImpl(datasource: CouponDatasourceImpl()));