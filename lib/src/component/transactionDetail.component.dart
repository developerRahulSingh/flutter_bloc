import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fvbank/themes/common.theme.dart';

class TransactionDetailComponent extends StatelessWidget {
  TransactionDetailComponent({
    this.transactionNumber = '',
    this.date = '',
    this.amount = '',
    this.performedBy = '',
    this.from = '',
    this.to = '',
    this.paymentType = '',
    this.channel = '',
    this.description = '',
  });

  final String transactionNumber;
  final String date;
  final String amount;
  final String performedBy;
  final String from;
  final String to;
  final String paymentType;
  final String channel;
  final String description;

  dynamic rowItem(String label, String value) {
    return Container(
      padding: EdgeInsets.only(top: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            label,
            style: TextStyle(
              fontSize: CommonTheme.TEXT_SIZE_SMALL,
              color: Colors.grey[600],
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: CommonTheme.TEXT_SIZE_SMALL,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double doubleTypeAmount = double.parse(amount);
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 32),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: new BoxDecoration(
          color: Colors.white,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10.0,
              offset: const Offset(0.0, 10.0),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min, // To make the card compact
          children: <Widget>[
            Text(
              'Transfer Detail',
              style: TextStyle(
                fontSize: CommonTheme.TEXT_SIZE_MEDIUM,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            rowItem('Transaction Number', transactionNumber),
            rowItem('Date', date),
            rowItem('Amount', doubleTypeAmount < 0 ? amount : '+' + amount),
            rowItem('Performed By', performedBy),
            rowItem('From', from),
            rowItem('To', to),
            rowItem('Payment Type', paymentType),
            rowItem('Channel', channel),
            rowItem('Description', description),
            SizedBox(height: 8.0),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: FlatButton(
                  color: Color.fromRGBO(17, 17, 68, 1),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4)),
                  onPressed: () {
                    Navigator.of(context).pop(); // To close the dialog
                  },
                  child: Text(
                    'Done',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
