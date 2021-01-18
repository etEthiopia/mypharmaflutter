import 'package:mypharma/exceptions/exceptions.dart';
import 'package:mypharma/models/models.dart';

class Datta {
  int user;
  int visits;
  int totalCustomerOrders;
  int customerProcessingOrders;
  int customerDeliveredgOrders;
  int customerOnholdOrders;
  int customerFailedOrders;
  int customerShippingOrders;
  int totalMyOrders;
  int myProcessingOrders;
  int myOnholdOrders;
  int myOndeliveredOrders;
  int myShippingOrders;
  int myFailedOrders;
  List<Promo> promos;

  Datta.Importer(
      {this.user,
      this.visits,
      this.totalCustomerOrders,
      this.customerProcessingOrders,
      this.customerDeliveredgOrders,
      this.customerOnholdOrders,
      this.customerFailedOrders,
      this.customerShippingOrders,
      this.promos});

  Datta.WholeSeller(
      {this.user,
      this.visits,
      this.totalCustomerOrders,
      this.customerProcessingOrders,
      this.customerDeliveredgOrders,
      this.customerOnholdOrders,
      this.customerFailedOrders,
      this.customerShippingOrders,
      this.totalMyOrders,
      this.myProcessingOrders,
      this.myOnholdOrders,
      this.myOndeliveredOrders,
      this.myShippingOrders,
      this.myFailedOrders,
      this.promos});

  Datta.Pharmacy(
      {this.user,
      this.visits,
      this.totalMyOrders,
      this.myProcessingOrders,
      this.myOnholdOrders,
      this.myOndeliveredOrders,
      this.myShippingOrders,
      this.myFailedOrders,
      this.promos});

  factory Datta.fromJson(Map<String, dynamic> json) {
    print(json);
    if (int.parse(json['user'].toString()) == 2) {
      return Datta.Importer(
          user: json['user'],
          visits: json['ttvisit'],
          totalCustomerOrders: json['ttotal_order'].length,
          customerProcessingOrders: json['pprocessing'].length,
          customerDeliveredgOrders: json['ddelivered'].length,
          customerOnholdOrders: json['oonhold'].length,
          customerFailedOrders: json['ffailed'].length,
          customerShippingOrders: json['sshipping'].length,
          promos: Promo.generatePromoList(json['promo']));
    } else if (int.parse(json['user'].toString()) == 3) {
      return Datta.WholeSeller(
          user: json['user'],
          visits: json['ttvisit'],
          totalCustomerOrders: json['ttotal_order'].length,
          customerProcessingOrders: json['pprocessing'].length,
          customerDeliveredgOrders: json['ddelivered'].length,
          customerOnholdOrders: json['oonhold'].length,
          customerFailedOrders: json['ffailed'].length,
          customerShippingOrders: json['sshipping'].length,
          totalMyOrders: json['oorder'].length,
          myProcessingOrders: json['oporder'].length,
          myOnholdOrders: json['ooorder'].length,
          myOndeliveredOrders: json['odorder'].length,
          myShippingOrders: json['osorder'].length,
          myFailedOrders: json['oforder'].length,
          promos: Promo.generatePromoList(json['promo']));
    } else if (int.parse(json['user'].toString()) == 4) {
      return Datta.Pharmacy(
          user: json['user'],
          visits: json['ttvisit'],
          totalMyOrders: json['oorder'].length,
          myProcessingOrders: json['oporder'].length,
          myOnholdOrders: json['ooorder'].length,
          myOndeliveredOrders: json['odorder'].length,
          myShippingOrders: json['osorder'].length,
          myFailedOrders: json['oforder'].length,
          promos: Promo.generatePromoList(json['promo']));
    } else {
      throw DashboardException(message: 'Could not Fetch');
    }
  }
}
