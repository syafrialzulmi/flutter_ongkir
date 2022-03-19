import 'package:dropdown_search/dropdown_search.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/home_controller.dart';
import '../../../data/models/province_model.dart';
import '../../../data/models/city_model.dart';

class HomeView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CEK ONGKOS KIRIM'),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          DropdownSearch<Province>(
            showSearchBox: true,
            popupItemBuilder: (context, item, isSelected) => ListTile(
              title: Text("${item.province}"),
            ),
            dropdownSearchDecoration: InputDecoration(
              labelText: "Provinsi Asal",
              contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
              border: OutlineInputBorder(),
            ),
            onFind: (text) async {
              var response = await Dio().get(
                "https://api.rajaongkir.com/starter/province",
                queryParameters: {"key": "372146ea941c8f928014866aba042c0f"},
              );

              return Province.fromJsonList(
                  response.data["rajaongkir"]["results"]);
            },
            onChanged: (value) =>
                controller.provAsalId.value = value?.provinceId ?? "0",
          ),
          SizedBox(
            height: 20,
          ),
          DropdownSearch<City>(
            showSearchBox: true,
            popupItemBuilder: (context, item, isSelected) => ListTile(
              title: Text("${item.type} ${item.cityName}"),
            ),
            dropdownSearchDecoration: InputDecoration(
              labelText: "Kota/ Kabupaten Asal",
              contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
              border: OutlineInputBorder(),
            ),
            onFind: (text) async {
              var response = await Dio().get(
                "https://api.rajaongkir.com/starter/city?province=${controller.provAsalId}",
                queryParameters: {"key": "372146ea941c8f928014866aba042c0f"},
              );

              return City.fromJsonList(response.data["rajaongkir"]["results"]);
            },
            onChanged: (value) =>
                controller.cityAsalId.value = value?.cityId ?? "0",
          ),
          SizedBox(
            height: 20,
          ),
          DropdownSearch<Province>(
            showSearchBox: true,
            popupItemBuilder: (context, item, isSelected) => ListTile(
              title: Text("${item.province}"),
            ),
            dropdownSearchDecoration: InputDecoration(
              labelText: "Provinsi Tujuan",
              contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
              border: OutlineInputBorder(),
            ),
            onFind: (text) async {
              var response = await Dio().get(
                "https://api.rajaongkir.com/starter/province",
                queryParameters: {"key": "372146ea941c8f928014866aba042c0f"},
              );

              return Province.fromJsonList(
                  response.data["rajaongkir"]["results"]);
            },
            onChanged: (value) =>
                controller.provTujuanId.value = value?.provinceId ?? "0",
          ),
          SizedBox(
            height: 20,
          ),
          DropdownSearch<City>(
            showSearchBox: true,
            popupItemBuilder: (context, item, isSelected) => ListTile(
              title: Text("${item.type} ${item.cityName}"),
            ),
            dropdownSearchDecoration: InputDecoration(
              labelText: "Kota/ Kabupaten Tujuan",
              contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
              border: OutlineInputBorder(),
            ),
            onFind: (text) async {
              var response = await Dio().get(
                "https://api.rajaongkir.com/starter/city?province=${controller.provTujuanId}",
                queryParameters: {"key": "372146ea941c8f928014866aba042c0f"},
              );

              return City.fromJsonList(response.data["rajaongkir"]["results"]);
            },
            onChanged: (value) =>
                controller.cityTujuanId.value = value?.cityId ?? "0",
          ),
          SizedBox(
            height: 20,
          ),
          TextField(
            controller: controller.beratC,
            autocorrect: false,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: "Berat (gram)",
              contentPadding:
                  EdgeInsets.symmetric(vertical: 25, horizontal: 15),
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          DropdownSearch<Map<String, dynamic>>(
            items: [
              {
                "code": "jne",
                "name": "JNE",
              },
              {
                "code": "pos",
                "name": "POS Indonesia",
              },
              {
                "code": "tiki",
                "name": "TIKI",
              }
            ],
            showSearchBox: true,
            popupItemBuilder: (context, item, isSelected) => ListTile(
              title: Text("${item['name']}"),
            ),
            dropdownSearchDecoration: InputDecoration(
              labelText: "Pilih Kurir",
              contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
              border: OutlineInputBorder(),
            ),
            dropdownBuilder: (context, selectedItem) =>
                Text("${selectedItem?['name'] ?? "Pilih Kurir"}"),
            onChanged: (value) =>
                controller.codeKurir.value = value?['code'] ?? "",
          ),
          SizedBox(
            height: 20,
          ),
          Obx(() => ElevatedButton(
              onPressed: () {
                if (controller.isLoading.isFalse) {
                  controller.cekOngkir();
                }
              },
              child: Text(controller.isLoading.isFalse
                  ? "CEK ONGKOS KIRIM"
                  : "LOADING...")))
        ],
      ),
    );
  }
}
