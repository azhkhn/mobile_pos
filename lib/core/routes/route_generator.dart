import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mobile_pos/core/constant/colors.dart';
import 'package:mobile_pos/core/constant/sizes.dart';
import 'package:mobile_pos/core/constant/text.dart';
import 'package:mobile_pos/core/routes/router.dart';
import 'package:mobile_pos/core/utils/converters/converters.dart';
import 'package:mobile_pos/core/utils/user/user.dart';
import 'package:mobile_pos/core/utils/validators/validators.dart';
import 'package:mobile_pos/db/db_functions/cash_register/cash_register_database.dart';
import 'package:mobile_pos/model/auth/user_model.dart';
import 'package:mobile_pos/model/business_profile/business_profile_model.dart';
import 'package:mobile_pos/model/cash_register/cash_register_model.dart';
import 'package:mobile_pos/model/group/group_model.dart';
import 'package:mobile_pos/model/permission/permission_model.dart';
import 'package:mobile_pos/model/purchase/purchase_model.dart';
import 'package:mobile_pos/model/sales/sales_model.dart';
import 'package:mobile_pos/screens/barcode/screen_barcode.dart';
import 'package:mobile_pos/screens/cash_register/screen_cash_register.dart';
import 'package:mobile_pos/screens/customer/screen_manage_customer.dart';
import 'package:mobile_pos/screens/database/pages/screen_list_database.dart';
import 'package:mobile_pos/screens/database/screen_database.dart';
import 'package:mobile_pos/screens/expense/manage_expense/screen_manage_expense.dart';
import 'package:mobile_pos/screens/invoices/screen_sales_invoice.dart';
import 'package:mobile_pos/screens/item_master/screen_item_master.dart';
import 'package:mobile_pos/screens/item_master/screen_manage_products.dart';
import 'package:mobile_pos/screens/pos/screen_pos.dart';
import 'package:mobile_pos/screens/purchase/pages/screen_list_purchases.dart';
import 'package:mobile_pos/screens/purchase_return/pages/screen_purchase_return.dart';
import 'package:mobile_pos/screens/purchase_return/pages/screen_purchase_return_list.dart';
import 'package:mobile_pos/screens/reports/pages/expenses_report/screen_expenses_report.dart';
import 'package:mobile_pos/screens/reports/pages/negative_stock_report/screen_negative_stock_report.dart';
import 'package:mobile_pos/screens/reports/pages/operation_summary/screen_operation_summary.dart';
import 'package:mobile_pos/screens/reports/pages/pending_payment/screen_pending_payment.dart';
import 'package:mobile_pos/screens/reports/pages/purchases_report/screen_purchases_report.dart';
import 'package:mobile_pos/screens/reports/pages/purchases_tax_report/screen_purchases_tax_report.dart';
import 'package:mobile_pos/screens/reports/pages/sales_report/screen_sales_report.dart';
import 'package:mobile_pos/screens/reports/pages/sales_tax_report/screen_sales_tax_report.dart';
import 'package:mobile_pos/screens/reports/pages/stock_re_order_report/screen_stock_re_order_report.dart';
import 'package:mobile_pos/screens/reports/pages/tax_summary_report/screen_tax_summary_report.dart';
import 'package:mobile_pos/screens/reports/pages/transactions_report/screen_transactions_report.dart';
import 'package:mobile_pos/screens/reports/screen_reports.dart';
import 'package:mobile_pos/screens/sales/pages/screen_sales_list.dart';
import 'package:mobile_pos/screens/sales_return/pages/screen_sales_return.dart';
import 'package:mobile_pos/screens/sales_return/pages/screen_sales_return_list.dart';
import 'package:mobile_pos/screens/stock/screen_stock.dart';
import 'package:mobile_pos/screens/sub_category/screen_sub_category.dart';
import 'package:mobile_pos/screens/supplier/screen_manage_supplier.dart';
import 'package:mobile_pos/screens/transaction/purchase_transaction/screen_transaction_purchase.dart';
import 'package:mobile_pos/screens/transaction/sales_transaction/screen_transaction_sale.dart';
import 'package:mobile_pos/screens/user_manage/pages/group/screen_add_group.dart';
import 'package:mobile_pos/screens/user_manage/pages/group/screen_list_groups.dart';
import 'package:mobile_pos/screens/user_manage/pages/user/screen_add_user.dart';
import 'package:mobile_pos/screens/user_manage/pages/user/screen_list_users.dart';
import 'package:mobile_pos/screens/user_manage/screen_user_manage.dart';
import 'package:mobile_pos/widgets/alertdialog/custom_alert.dart';
import 'package:mobile_pos/widgets/button_widgets/material_button_widget.dart';
import 'package:mobile_pos/widgets/text_field_widgets/text_field_widgets.dart';

import '../../screens/auth/pages/login_screen.dart';
import '../../screens/auth/pages/signup_screen.dart';
import '../../screens/brand/screen_brand.dart';
import '../../screens/business_profile/business_profile_screen.dart';
import '../../screens/category/screen_category.dart';
import '../../screens/customer/screen_add_customer.dart';
import '../../screens/expense/add_expense/screen_add_expense.dart';
import '../../screens/expense/add_expense_category/screen_add_expense_category.dart';
import '../../screens/home/home_screen.dart';
import '../../screens/item_master/screen_add_product.dart';
import '../../screens/payments/partial_payment/screen_partial_payment.dart';
import '../../screens/purchase/pages/screen_add_purchase.dart';
import '../../screens/purchase/pages/screen_purchase.dart';
import '../../screens/sales/pages/screen_sales.dart';
import '../../screens/splash/splash_screen.dart';
import '../../screens/supplier/screen_add_supplier.dart';
import '../../screens/unit/screen_unit.dart';
import '../../screens/vat/vat_screen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    //get arguments passed in while calling Navigator.pushNamed
    final args = settings.arguments;

    final PermissionModel? permission = UserUtils.instance.permissionModel;

    switch (settings.name) {
      case routeRoot:
        return MaterialPageRoute(builder: (_) => ScreenSplash());
      case routeHome:
        return MaterialPageRoute(builder: (_) => ScreenHome());

      //==========================================================================================
      //===================================== Authentication =====================================
      //==========================================================================================
      case routeLogin:
        return MaterialPageRoute(builder: (_) => ScreenLogin());
      case routeSignUp:
        return MaterialPageRoute(builder: (_) => ScreenSignUp());

      //=======================================================================================
      //===================================== Item Master =====================================
      //=======================================================================================

      case routeItemMaster:
        return MaterialPageRoute(builder: (_) => const ScreenItemMaster());

      case routeAddProduct:
        if (args is Map) {
          if (permission!.products.contains('3')) {
            return MaterialPageRoute(
                builder: (_) =>
                    ScreenAddProduct(from: args.containsKey('from'), itemMasterModel: args.containsKey('product') ? args['product'] : null));
          }
          return _errorPermission();
        }
        if (permission!.products.contains('2')) return MaterialPageRoute(builder: (_) => ScreenAddProduct());
        return _errorPermission();

      case routeManageProducts:
        if (permission!.products.contains('1')) return MaterialPageRoute(builder: (_) => ScreenManageProducts());
        return _errorPermission();

      case routeStock:
        return MaterialPageRoute(builder: (_) => ScreenStock());

      //=====================================================================================
      //===================================== Suppliers =====================================
      //=====================================================================================
      case routeAddSupplier:
        if (args is Map) {
          if (permission!.supplier.contains('3')) {
            return MaterialPageRoute(
                builder: (_) =>
                    SupplierAddScreen(from: args.containsKey('from'), supplierModel: args.containsKey('supplier') ? args['supplier'] : null));
          }
          return _errorPermission();
        }
        if (permission!.supplier.contains('2')) return MaterialPageRoute(builder: (_) => SupplierAddScreen(from: args is bool));
        return _errorPermission();

      case routeManageSupplier:
        if (permission!.supplier.contains('1')) return MaterialPageRoute(builder: (_) => SupplierManageScreen());
        return _errorPermission();

      //======================================================================================
      //===================================== Categories =====================================
      //======================================================================================
      case routeCategory:
        return MaterialPageRoute(builder: (_) => CategoryScreen());
      case routeSubCategory:
        return MaterialPageRoute(builder: (_) => SubCategoryScreen());
      case routeBrand:
        return MaterialPageRoute(builder: (_) => BrandScreen());
      case routeUnit:
        return MaterialPageRoute(builder: (_) => UnitScreen());
      case routeVat:
        return MaterialPageRoute(builder: (_) => VatScreen());
      case routeBarcode:
        return MaterialPageRoute(builder: (_) => ScreenBarcode());

      //======================================================================================
      //===================================== Customers ======================================
      //======================================================================================
      case routeAddCustomer:
        if (args is Map) {
          if (permission!.customer.contains('3')) {
            return MaterialPageRoute(
                builder: (_) =>
                    CustomerAddScreen(from: args.containsKey('from'), customerModel: args.containsKey('customer') ? args['customer'] : null));
          }
          return _errorPermission();
        }
        if (permission!.customer.contains('2')) return MaterialPageRoute(builder: (_) => CustomerAddScreen(from: args is bool));
        return _errorPermission();

      case routeManageCustomer:
        if (permission!.customer.contains('1')) return MaterialPageRoute(builder: (_) => CustomerManageScreen());
        return _errorPermission();

      //======================================================================================
      //===================================== Expenses =======================================
      //======================================================================================
      case routeAddExpenseCategory:
        return MaterialPageRoute(builder: (_) => const ScreenAddExpenseCategory());
      case routeAddExpense:
        return MaterialPageRoute(builder: (_) => ScreenAddExpense());
      case routeManageExpense:
        return MaterialPageRoute(builder: (_) => ScreenManageExpense());

      //======================================================================================
      //===================================== Sales =======================================
      //======================================================================================
      case routePos:
        if (permission!.sale.contains('2')) {
          final CashRegisterModel? _cashModel = UserUtils.instance.cashRegisterModel;
          final BusinessProfileModel? _businessModel = UserUtils.instance.businessProfileModel;
          if (_businessModel == null) return registerBusiness();
          if (_cashModel == null || _cashModel.action == 'close') return cashRegister();
          return MaterialPageRoute(builder: (_) => const PosScreen());
        }
        return _errorPermission();

      case routeSales:
        return MaterialPageRoute(builder: (_) => ScreenSales());
      case routeSalesList:
        if (permission!.sale.contains('1')) return MaterialPageRoute(builder: (_) => const ScreenSalesList());
        return _errorPermission();

      case routeSalesReturn:
        return MaterialPageRoute(builder: (_) => const SalesReturn());

      case routeSalesReturnList:
        return MaterialPageRoute(builder: (_) => const SalesReturnList());

      case routePartialPayment:
        if (args is Map) {
          return MaterialPageRoute(
              builder: (_) => PartialPayment(paymentDetails: args, purchase: args.containsKey('purchase'), isVertical: args['isVertical']));
        }
        return _errorRoute();

      case routeTransactionSale:
        if (args is SalesModel) {
          return MaterialPageRoute(builder: (_) => TransactionScreenSale(salesModel: args));
        }
        return _errorRoute();

      case routeSalesInvoice:
        if (args is List) {
          return MaterialPageRoute(
              builder: (_) => args.last
                  ? ScreenSalesInvoice(salesReturnModal: args.first, isReturn: args.last)
                  : ScreenSalesInvoice(salesModel: args.first, isReturn: args.last));
        }
        return _errorRoute();

      //======================================================================================
      //===================================== Purchases ======================================
      //======================================================================================
      case routePurchase:
        return MaterialPageRoute(builder: (_) => ScreenPurchase());

      case routeAddPurchase:
        final BusinessProfileModel? _businessModel = UserUtils.instance.businessProfileModel;
        if (_businessModel == null) return registerBusiness();
        if (permission!.purchase.contains('2')) return MaterialPageRoute(builder: (_) => const Purchase());
        return _errorPermission();

      case routeListPurchase:
        if (permission!.purchase.contains('1')) return MaterialPageRoute(builder: (_) => const ScreenPurchasesList());
        return _errorPermission();

      case routePurchaseReturn:
        return MaterialPageRoute(builder: (_) => const PurchaseReturn());

      case routePurchaseReturnList:
        return MaterialPageRoute(builder: (_) => const PurchaseReturnList());

      case routeTransactionPurchase:
        if (args is PurchaseModel) {
          return MaterialPageRoute(builder: (_) => TransactionScreenPurchase(purchaseModel: args));
        }
        return _errorRoute();

      //=========================================================================================
      //======================================== Database =======================================
      //=========================================================================================
      case routeDatabase:
        return MaterialPageRoute(builder: (_) => const ScreenDatabase());
      case routeDatabaseList:
        return MaterialPageRoute(builder: (_) => const ScreenDatabaseList());

      //=========================================================================================
      //======================================== User & Group ===================================
      //=========================================================================================
      case routeUserManage:
        if (permission!.user.contains('0')) return _errorPermission();
        if (permission.user.contains('1')) return MaterialPageRoute(builder: (_) => const ScreenUserManage());
        return _errorPermission();

      case routeAddUser:
        if (args is UserModel) {
          if (permission!.user.contains('3')) return MaterialPageRoute(builder: (_) => ScreenAddUser(userModel: args));
          return _errorPermission();
        }
        if (permission!.user.contains('2')) return MaterialPageRoute(builder: (_) => ScreenAddUser());
        return _errorPermission();

      case routeBusinessProfile:
        return MaterialPageRoute(builder: (_) => const BusinessProfile());

      case routeListUser:
        if (permission!.user.contains('1')) return MaterialPageRoute(builder: (_) => ScreenUserList());
        return _errorPermission();
      case routeAddGroup:
        if (args is GroupModel) {
          if (permission!.user.contains('3')) return MaterialPageRoute(builder: (_) => ScreenAddGroup(groupModel: args));
          return _errorPermission();
        }
        if (permission!.user.contains('2')) return MaterialPageRoute(builder: (_) => ScreenAddGroup());
        return _errorPermission();

      case routeListGroup:
        if (permission!.user.contains('1')) return MaterialPageRoute(builder: (_) => ScreenGroupList());
        return _errorPermission();

      case routeCashRegister:
        return MaterialPageRoute(builder: (_) => const ScreenCashRegister());

      //=========================================================================================
      //======================================== Reports ========================================
      //=========================================================================================
      case routeReports:
        return MaterialPageRoute(builder: (_) => const ScreenReports());
      case routeOperationSummary:
        return MaterialPageRoute(builder: (_) => const ScreenOperationSummary());
      case routeTransactionReport:
        return MaterialPageRoute(builder: (_) => ScreenTransactionsReport());
      case routePendingInvoice:
        return MaterialPageRoute(builder: (_) => ScreenPendingInvoice());
      case routeSalesReport:
        return MaterialPageRoute(builder: (_) => const ScreenSalesReport());
      case routePurchasesReport:
        return MaterialPageRoute(builder: (_) => const ScreenPurchasesReport());
      case routeExpenseReport:
        return MaterialPageRoute(builder: (_) => ScreenExpensesReport());
      case routeNegativeStockReport:
        return MaterialPageRoute(builder: (_) => ScreenNegativeStockReport());
      case routeStockReOrderReport:
        return MaterialPageRoute(builder: (_) => ScreenStockReOrderReport());
      case routeTaxSummaryReport:
        return MaterialPageRoute(builder: (_) => ScreenTaxSummaryReport());
      case routeSalesTaxReport:
        if (args is Map) return MaterialPageRoute(builder: (_) => ScreenSalesTaxReport(fromDate: args['fromDate'], toDate: args['toDate']));
        return MaterialPageRoute(builder: (_) => ScreenSalesTaxReport());
      case routePurchasesTaxReport:
        if (args is Map) return MaterialPageRoute(builder: (_) => ScreenPurchasesTaxReport(fromDate: args['fromDate'], toDate: args['toDate']));
        return MaterialPageRoute(builder: (_) => ScreenPurchasesTaxReport());

      default:
        return _errorRoute();
    }
  }

  //========== Error Page if Navigation goes wrong ==========
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

  //========== Error Page if not permitted ==========
  static Route<dynamic> _errorPermission() {
    return PageRouteBuilder(
      opaque: false,
      barrierColor: kColorDim,
      pageBuilder: (context, __, ___) => AlertDialog(
        content: const Text("You don't have enough permission to access this feature."),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Okay',
                style: TextStyle(color: kBlack, fontWeight: FontWeight.bold),
              )),
        ],
      ),
    );
  }

  //========== Cash Register ==========
  static Route<dynamic> cashRegister() {
    return PageRouteBuilder(
      opaque: false,
      barrierColor: kColorDim,
      pageBuilder: (context, __, ___) {
        final CashRegisterModel? _cashModel = UserUtils.instance.cashRegisterModel;

        final String cashInHand = _cashModel?.amount ?? '0';

        final TextEditingController _cashController = TextEditingController(text: cashInHand);
        final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Cash In Hand : ', style: kText12),
                  Text(
                    Converter.currency.format(num.parse(cashInHand)),
                    style: kText12,
                  )
                ],
              ),
              kHeight15,
              Form(
                key: _formKey,
                child: TextFeildWidget(
                  labelText: 'Cash in hand',
                  controller: _cashController,
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  inputBorder: const OutlineInputBorder(),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  inputFormatters: Validators.digitsOnly,
                  isDense: true,
                  textInputType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty || value == '.') {
                      return 'This field is required*';
                    }
                    if (num.parse(value) < num.parse(cashInHand)) return 'Amount cannot be lower*';

                    return null;
                  },
                ),
              ),
              kHeight5,
              CustomMaterialBtton(
                  onPressed: () async {
                    if (!_formKey.currentState!.validate()) return;

                    Navigator.pop(context);

                    final String amount = _cashController.text;
                    final String dateTime = DateTime.now().toIso8601String();
                    final int userId = UserUtils.instance.userModel!.id!;
                    const String action = 'open';

                    log('Amount = $amount');
                    log('DateTime = $dateTime');
                    log('User Id =  $userId');
                    log('Action = $action');

                    final CashRegisterModel cashRegisterModel = CashRegisterModel(dateTime: dateTime, amount: amount, userId: userId, action: action);

                    CashRegisterDatabase.instance.createCashRegister(cashRegisterModel);
                  },
                  buttonText: 'Start Register'),
            ],
          ),
        );
      },
    );
  }

  static Route registerBusiness() {
    return PageRouteBuilder(
      opaque: false,
      barrierColor: kColorDim,
      pageBuilder: (context, __, ___) {
        return KAlertDialog(
          content: Text('Please fill out business information in the Business Profile to access it throughout the application.', style: kText12sp),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, routeBusinessProfile);
              },
              child: Text('Business Profile', style: kText12sp),
            )
          ],
        );
      },
    );
  }
}
