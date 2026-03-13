<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Payment Receipt</title>
</head>
<body style="margin:0;padding:0;background:#f3f4f6;font-family:Arial,sans-serif;color:#111827;">
<table role="presentation" width="100%" cellspacing="0" cellpadding="0" style="padding:24px 0;">
<tr><td align="center">
<table role="presentation" width="640" cellspacing="0" cellpadding="0" style="max-width:640px;background:#ffffff;border:1px solid #e5e7eb;border-radius:10px;overflow:hidden;">
<tr><td style="background:#1D2A68;padding:20px 24px;"><h1 style="margin:0;color:#ffffff;font-size:24px;">Payment Receipt</h1></td></tr>
<tr><td style="padding:24px;">
<p style="margin:0 0 12px 0;font-size:15px;line-height:1.6;">Dear {{ $profile->company_name }},</p>
<p style="margin:0 0 12px 0;font-size:15px;line-height:1.6;">Thank you. Your payment has been successfully recorded.</p>
<p style="margin:0 0 10px 0;font-size:15px;line-height:1.6;"><strong>Amount:</strong> ZMW {{ number_format((float) $amount, 2) }}</p>
<p style="margin:0 0 10px 0;font-size:15px;line-height:1.6;"><strong>Date:</strong> {{ \Illuminate\Support\Carbon::parse($paymentDate)->format('M d, Y') }}</p>
<p style="margin:0 0 10px 0;font-size:15px;line-height:1.6;"><strong>Method:</strong> {{ $paymentMethod }}</p>
@if(!empty($reference))
<p style="margin:0 0 10px 0;font-size:15px;line-height:1.6;"><strong>Reference:</strong> {{ $reference }}</p>
@endif
<p style="margin:0 0 12px 0;font-size:15px;line-height:1.6;">Your payment has been added to your account and your financial progress will be reflected in your dashboard.</p>
<p style="margin:20px 0 0 0;font-size:15px;line-height:1.6;">Regards,<br><strong>LiVCCI Secretariat</strong></p>
<p style="margin:16px 0 0 0;font-size:12px;line-height:1.6;color:#6b7280;">Livingstone Chamber of Commerce, [Your Address], Livingstone, Zambia.</p>
<p style="margin:8px 0 0 0;font-size:12px;line-height:1.6;color:#6b7280;">You are receiving this because you registered for the LiVCCI Member Portal. To manage notifications, login to your dashboard.</p>
</td></tr>
</table>
</td></tr>
</table>
</body>
</html>
