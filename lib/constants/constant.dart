class Constant {
  // static const baseurl = "http://savvywater.sitsolutions.co.in/";
  static const baseurl = "https://savvywater.demosoftware.co.in/api/";
  // static const baseurl = "http://192.168.1.43:8000/api/";

  // static const login = "${baseurl}APP_loginCheck";
  // static const addFuel = "${baseurl}APP_FuleAdd";
  // static const viewFuel = "${baseurl}APP_FuleView";
  // static const storeMaintenance = "${baseurl}APP_MaintenanceAdd";
  // static const viewMaintenance = "${baseurl}APP_MaintenanceView";
  // static const veiwAllOrder = "${baseurl}APP_OrdersViewAll";
  // static const confirmOrder = "${baseurl}APP_OrdersQtyUpdate";
  // static const digitalCard = "${baseurl}APP_DriverDigitalCard";
  // static const orderDetails = "${baseurl}APP_OrdersDetailsViewAll";
  // static const orderStatistics = "${baseurl}APP_DashboardAPI";
  // static const deleteAccount = "${baseurl}deleteProfile";

  static const login = "${baseurl}send-otp"; // this is post request
  static const verifyOtp = "${baseurl}verify-otp";
  static const addFuel = "${baseurl}maintenance";
  static const viewFuel = "${baseurl}";
  static const storeMaintenance = "${baseurl}maintenance";
  static const viewMaintenance = "${baseurl}";
  static const veiwAllOrder = "${baseurl}";
  static const confirmOrder = "${baseurl}";
  static const digitalCard = "${baseurl}";
  static const orderDetails = "${baseurl}";
  static const orderStatistics = "$baseurl";
  static const deleteAccount =
      "${baseurl}profile/"; // this one is yet to integrate.
  static const logout = "${baseurl}logout";
}
