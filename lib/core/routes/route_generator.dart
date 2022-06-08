import 'package:flutter/material.dart';
import 'package:shop_ez/core/routes/router.dart';
import 'package:shop_ez/model/sales/sales_model.dart';
import 'package:shop_ez/screens/barcode/screen_barcode.dart';
import 'package:shop_ez/screens/customer/screen_customer_list.dart';
import 'package:shop_ez/screens/invoices/screen_sales_invoice.dart';
import 'package:shop_ez/screens/purchase/pages/screen_list_purchases.dart';
import 'package:shop_ez/screens/purchase_return/screen_purchase_return.dart';
import 'package:shop_ez/screens/sales/pages/screen_sales_list.dart';
import 'package:shop_ez/screens/sales_return/pages/screen_sales_return.dart';
import 'package:shop_ez/screens/sales_return/pages/screen_sales_return_list.dart';
import 'package:shop_ez/screens/stock/screen_stock.dart';
import 'package:shop_ez/screens/transaction/screen_transaction.dart';

import '../../screens/auth/pages/login_screen.dart';
import '../../screens/auth/pages/signup_screen.dart';
import '../../screens/brand/screen_brand.dart';
import '../../screens/business_profile/business_profile_screen.dart';
import '../../screens/category/screen_category.dart';
import '../../screens/customer/screen_add_customer.dart';
import '../../screens/expense/screen_expense.dart';
import '../../screens/expense/screen_expense_category.dart';
import '../../screens/home/home_screen.dart';
import '../../screens/item_master/screen_item_master.dart';
import '../../screens/payments/partial_payment/screen_partial_payment.dart';
import '../../screens/pos/screen_pos.dart';
import '../../screens/purchase/pages/screen_add_purchase.dart';
import '../../screens/purchase/pages/screen_purchase.dart';
import '../../screens/sales/pages/screen_sales.dart';
import '../../screens/splash/splash_screen.dart';
import '../../screens/sub-category/screen_sub_category.dart';
import '../../screens/supplier/supplier_screen.dart';
import '../../screens/unit/screen_unit.dart';
import '../../screens/vat/vat_screen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    //get arguments passed in while calling Navigator.pushNamed
    final args = settings.arguments;

    switch (settings.name) {
      case routeRoot:
        return MaterialPageRoute(builder: (_) => ScreenSplash());
      case routeHome:
        return MaterialPageRoute(builder: (_) => ScreenHome());
      case routeLogin:
        return MaterialPageRoute(builder: (_) => const ScreenLogin());
      case routeSignUp:
        return MaterialPageRoute(builder: (_) => const ScreenSignUp());
      case routeItemMaster:
        return MaterialPageRoute(builder: (_) => ScreenItemMaster());
      case routeAddSupplier:
        return MaterialPageRoute(builder: (_) => ScreenSupplier(purchase: args == true));
      case routeCategory:
        return MaterialPageRoute(builder: (_) => CategoryScreen());
      case routeSubCategory:
        return MaterialPageRoute(builder: (_) => SubCategoryScreen());
      case routeBrand:
        return MaterialPageRoute(builder: (_) => BrandScreen());
      case routeAddCustomer:
        return MaterialPageRoute(builder: (_) => AddCustomerScreen(fromPos: args == true));
      case routeManageCustomer:
        return MaterialPageRoute(builder: (_) => CustomerList());
      case routeUnit:
        return MaterialPageRoute(builder: (_) => UnitScreen());
      case routeExpense:
        return MaterialPageRoute(builder: (_) => const ManageExpenseScreen());
      case routeBusinessProfile:
        return MaterialPageRoute(builder: (_) => const BusinessProfile());
      case routeVat:
        return MaterialPageRoute(builder: (_) => VatScreen());
      case routeExpenseCategory:
        return MaterialPageRoute(builder: (_) => const ExpenseCategory());
      case routePos:
        return MaterialPageRoute(builder: (_) => const PosScreen());
      case routePartialPayment:
        if (args is Map) {
          return MaterialPageRoute(
              builder: (_) => PartialPayment(
                    paymentDetails: args,
                    purchase: args.containsKey('purchase'),
                    isVertical: args['isVertical'],
                  ));
        }
        return _errorRoute();
      case routeTransaction:
        if (args is SalesModel) {
          return MaterialPageRoute(
              builder: (_) => TransactionScreen(
                    salesModel: args,
                  ));
        }
        return _errorRoute();
      case routeSales:
        return MaterialPageRoute(builder: (_) => ScreenSales());
      case routeSalesList:
        return MaterialPageRoute(builder: (_) => const SalesList());
      case routePurchase:
        return MaterialPageRoute(builder: (_) => ScreenPurchase());
      case routeAddPurchase:
        return MaterialPageRoute(builder: (_) => const Purchase());
      case routeListPurchase:
        return MaterialPageRoute(builder: (_) => const PurchasesList());
      case routeStock:
        return MaterialPageRoute(builder: (_) => ScreenStock());
      case routeBarcode:
        return MaterialPageRoute(builder: (_) => const ScreenBarcode());
      case routeSalesReturn:
        return MaterialPageRoute(builder: (_) => const SalesReturn());
      case routeSalesReturnList:
        return MaterialPageRoute(builder: (_) => const SalesReturnList());
      case routePurchaseReturn:
        return MaterialPageRoute(builder: (_) => const PurchaseReturn());
      case routeSalesInvoice:
        if (args is List) {
          return MaterialPageRoute(
              builder: (_) => args.last
                  ? ScreenSalesInvoice(
                      salesReturnModal: args.first,
                      isReturn: args.last,
                    )
                  : ScreenSalesInvoice(
                      salesModel: args.first,
                      isReturn: args.last,
                    ));
        } else {
          return _errorRoute();
        }

      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: const Center(
          child: Text(
            'Error',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
