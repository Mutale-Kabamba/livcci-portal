<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Renewal Reminder</title>
</head>
<body style="margin:0;padding:0;background:#f3f4f6;font-family:Arial,sans-serif;color:#111827;">
<table role="presentation" width="100%" cellspacing="0" cellpadding="0" style="padding:24px 0;">
<tr><td align="center">
<table role="presentation" width="640" cellspacing="0" cellpadding="0" style="max-width:640px;background:#ffffff;border:1px solid #e5e7eb;border-radius:10px;overflow:hidden;">
<tr><td style="background:#1D2A68;padding:20px 24px;"><h1 style="margin:0;color:#ffffff;font-size:24px;">Membership Renewal Reminder</h1></td></tr>
<tr><td style="padding:24px;">
<p style="margin:0 0 12px 0;font-size:15px;line-height:1.6;">Dear {{ $profile->company_name }},</p>
<p style="margin:0 0 12px 0;font-size:15px;line-height:1.6;">Your LiVCCI membership will expire in <strong>{{ $daysRemaining }} day{{ $daysRemaining === 1 ? '' : 's' }}</strong>.</p>
@if($profile->subscription_expiry)
<p style="margin:0 0 12px 0;font-size:15px;line-height:1.6;"><strong>Expiry Date:</strong> {{ $profile->subscription_expiry->format('M d, Y') }}</p>
@endif
<p style="margin:0 0 12px 0;font-size:15px;line-height:1.6;">Please renew on time to keep your profile active in the member directory and maintain access to chamber services.</p>
<p style="margin:0 0 12px 0;font-size:15px;line-height:1.6;">If you have already made your payment, please disregard this reminder and allow some time for processing.</p>
<p style="margin:20px 0 0 0;font-size:15px;line-height:1.6;">Regards,<br><strong>LiVCCI Secretariat</strong></p>
<p style="margin:16px 0 0 0;font-size:12px;line-height:1.6;color:#6b7280;">Address: PO Box 4037, Livingstone | Email: livcci@yahoo.com | Tel: +260 977 105068 / +260 977 885959</p>
<p style="margin:8px 0 0 0;font-size:12px;line-height:1.6;color:#6b7280;">You are receiving this because you registered for the LiVCCI Member Portal. To manage notifications, login to your dashboard.</p>
</td></tr>
</table>
</td></tr>
</table>
</body>
</html>
