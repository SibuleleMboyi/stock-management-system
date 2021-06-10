import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:stock_management_system/models/models.dart';

class EmailSender {
  static String adminEmail;
  static String adminPassword;
  static String managerEmail;
  static String senderName = 'Admin-Account';

  static Future<void> sendEmail({@required String pdfFilePath}) async {
    final smtpServer = gmail(adminEmail, adminPassword);

    final message = Message()
      ..toString()
      ..from = Address(adminEmail, senderName)
      ..recipients.add(managerEmail)
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
      throw Failure(
        message:
            'Incorrect Admin Email or Password.\nGo to Edit Profile and update Admin email credentials.',
      );
      /* for (var p in error.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      } */
    }
  }
}
