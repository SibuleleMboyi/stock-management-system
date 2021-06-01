import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class EmailSender {
  // TODO: create email for this project
  static String senderName = 'Admin-Account';
  static String senderUsername = 'luckysimcard2021@gmail.com';
  static String senderPassword = '1521128sibuleleh';
  static String receiverUsername = 'smboyi2016@gmail.com';

  static Future<void> sendEmail({@required String pdfFilePath}) async {
    final smtpServer = gmail(senderUsername, senderPassword);

    final message = Message()
      ..toString()
      ..from = Address(senderUsername, senderName)
      ..recipients.add(receiverUsername)
      ..subject = 'TRANSACTION'
      ..text = '- New Transaction.'
      ..html = '<p>Please find the attachment of the new transaction</p>'
      ..attachments = [
        FileAttachment(File(pdfFilePath))
          ..location = Location.inline
          ..cid = '<myimg@3.141>'
      ];

    try {
      final sendReport = await send(message, smtpServer);

      print('Email sent : ' + sendReport.toString());
    } on MailerException catch (error) {
      print('Message not sent.');
      for (var p in error.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
    }
  }
}
