<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Welcome to LiVCCI</title>
</head>
<body style="margin:0;padding:0;background:#f3f4f6;font-family:Arial,sans-serif;color:#111827;">
<table role="presentation" width="100%" cellspacing="0" cellpadding="0" style="padding:24px 0;">
<tr><td align="center">
<table role="presentation" width="640" cellspacing="0" cellpadding="0" style="max-width:640px;background:#ffffff;border:1px solid #e5e7eb;border-radius:10px;overflow:hidden;">
<tr><td style="background:#1D2A68;padding:20px 24px;"><h1 style="margin:0;color:#ffffff;font-size:24px;line-height:1.3;">Welcome to LiVCCI Member Portal</h1></td></tr>
<tr><td style="padding:24px;">
<p style="margin:0 0 12px 0;font-size:15px;line-height:1.6;">Dear {{ $user->name }},</p>
<p style="margin:0 0 12px 0;font-size:15px;line-height:1.6;">Your email has been successfully verified, and your member portal access is now active. We are delighted to welcome you to the Livingstone Chamber of Commerce and Industry digital platform.</p>
<p style="margin:0 0 12px 0;font-size:15px;line-height:1.6;">You can now manage your membership profile, track invoices and payments, and stay updated with chamber opportunities and events through your dashboard.</p>
@if($profile?->invoice_pdf_path)
<p style="margin:0 0 12px 0;font-size:15px;line-height:1.6;">Your latest invoice is attached to this email as <strong>Invoice.pdf</strong>.</p>
@endif
<p style="margin:20px 0 0 0;font-size:15px;line-height:1.6;">Regards,<br><strong>LiVCCI Secretariat</strong></p>
<p style="margin:16px 0 0 0;font-size:12px;line-height:1.6;color:#6b7280;">Address: PO Box 4037, Livingstone | Email: livcci@yahoo.com | Tel: +260 977 105068 / +260 977 885959</p>
<p style="margin:8px 0 0 0;font-size:12px;line-height:1.6;color:#6b7280;">You are receiving this because you registered for the LiVCCI Member Portal. To manage notifications, login to your dashboard.</p>
</td></tr>
</table>
</td></tr>
</table>
</body>
</html>
