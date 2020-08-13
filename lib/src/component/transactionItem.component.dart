import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fvbank/themes/common.theme.dart';

class TransactionItemComponent extends StatelessWidget {
  TransactionItemComponent(
      {this.companyName = '',
      this.dateTime = '',
      this.amount = '',
      this.transactionId = '',
      this.description = '',
      this.imagePath = ''});

  final String companyName;

  final String dateTime;
  final String amount;
  final String transactionId;
  final dynamic description;
  final String imagePath;

  @override
  Widget build(BuildContext context) {
    double doubleTypeAmount = double.parse(amount);
    return Container(
      color: Colors.white,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(16),
            child: Image.asset(imagePath),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(top: 16, bottom: 16, right: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(right: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                companyName,
                                style: TextStyle(
                                  fontSize: CommonTheme.TEXT_SIZE_DEFAULT,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                dateTime,
                                style: TextStyle(
                                  fontSize: CommonTheme.TEXT_SIZE_SMALL,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Text(
                            doubleTypeAmount < 0 ? amount : '+' + amount,
                            style: TextStyle(
                              fontSize: CommonTheme.TEXT_SIZE_DEFAULT,
                              fontWeight: FontWeight.bold,
                              color: doubleTypeAmount < 0
                                  ? Colors.red
                                  : Colors.green,
                            ),
                          ),
                          Text(
                            transactionId,
                            style: TextStyle(
                              fontSize: CommonTheme.TEXT_SIZE_SMALL,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  description != null
                      ? Expanded(
                          child: Container(
                            padding: EdgeInsets.only(top: 4),
                            child: Text(
                              description,
                              style: TextStyle(
                                fontSize: CommonTheme.TEXT_SIZE_SMALL,
                              ),
                            ),
                          ),
                        )
                      : SizedBox.shrink(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
